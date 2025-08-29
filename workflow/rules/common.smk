__author__ = "Pádraic Corcoran"
__copyright__ = "Copyright 2024, Pádraic Corcoran"
__email__ = "padraic.corcoran@sciliflab.uu.se"
__license__ = "GPL-3"

import itertools
import numpy as np
import pathlib
import pandas as pd
import yaml
from datetime import datetime
from snakemake.utils import validate
from snakemake.utils import min_version
from hydra_genetics import min_version as hydra_min_version
from hydra_genetics.utils.misc import get_module_snakefile

from hydra_genetics.utils.resources import load_resources
from hydra_genetics.utils.samples import *
from hydra_genetics.utils.units import *

from hydra_genetics.utils.misc import replace_dict_variables
from hydra_genetics.utils.misc import extract_chr

from hydra_genetics.utils.misc import export_config_as_file
from hydra_genetics.utils.software_versions import add_version_files_to_multiqc
from hydra_genetics.utils.software_versions import add_software_version_to_config
from hydra_genetics.utils.software_versions import export_pipeline_version_as_file
from hydra_genetics.utils.software_versions import export_software_version_as_file
from hydra_genetics.utils.software_versions import get_pipeline_version
from hydra_genetics.utils.software_versions import touch_pipeline_version_file_name
from hydra_genetics.utils.software_versions import touch_software_version_file
from hydra_genetics.utils.software_versions import use_container

hydra_min_version("3.0.0")

min_version("7.8.0")

### Set and validate config file

if not workflow.overwrite_configfiles:
    sys.exit("At least one config file must be passed using --configfile/--configfiles, by command line or a profile!")

try:
    validate(config, schema="../schemas/config.schema.yaml")
except WorkflowError as we:
    # Probably a validation error, but the original exception in lost in
    # snakemake. Pull out the most relevant information instead of a potentially
    # *very* long error message.
    if not we.args[0].lower().startswith("error validating config file"):
        raise
    error_msg = "\n".join(we.args[0].splitlines()[:2])
    parent_rule_ = we.args[0].splitlines()[3].split()[-1]
    if parent_rule_ == "schema:":
        sys.exit(error_msg)
    else:
        schema_hiearachy = parent_rule_.split()[-1]
        schema_section = ".".join(re.findall(r"\['([^']+)'\]", schema_hiearachy)[1::2])
        sys.exit(f"{error_msg} in {schema_section}")

pipeline_name = "Fada"
pipeline_version = get_pipeline_version(workflow, pipeline_name=pipeline_name)
version_file = touch_pipeline_version_file_name(
    pipeline_version, date_string=pipeline_name, directory="results/versions/software"
)

if use_container(workflow):
    version_file.append(touch_software_version_file(config, date_string=pipeline_name, directory="results/versions/software"))
add_version_files_to_multiqc(config, version_file)


onstart:
    export_pipeline_version_as_file(pipeline_version, date_string=pipeline_name, directory="results/versions/software")
    # Make sure that the user have the requested containers to be used
    if use_container(workflow):
        # From the config retrieve all dockers used and parse labels for software versions. Add
        # this information to config dict.
        update_config, software_info = add_software_version_to_config(config, workflow, False)
        # Print all softwares used as files. Additional parameters that can be set
        # - directory, default value: software_versions
        # - file_name_ending, default value: mqc_versions.yaml
        # date_string, a string that will be added to the folder name to make it unique (preferably a timestamp)
        export_software_version_as_file(software_info, date_string=pipeline_name, directory="results/versions/software")
        # print config dict as a file. Additional parameters that can be set
        # output_file, default config
        # output_directory, default = None, i.e no folder
        # date_string, a string that will be added to the folder name to make it unique (preferably a timestamp)
    date_string = datetime.now().strftime("%Y%m%d")
    export_config_as_file(update_config, date_string=date_string, directory="results/versions")


### Read and validate resources file

config = load_resources(config, config["resources"])
config = replace_dict_variables(config)
validate(config, schema="../schemas/resources.schema.yaml")


### Read and validate samples file

samples = pd.read_table(config["samples"], dtype=str, sep="\t").set_index("sample", drop=False)
validate(samples, schema="../schemas/samples.schema.yaml")

### Read and validate units file

units = (
    pandas.read_table(config["units"], dtype=str)
    .set_index(["sample", "type", "processing_unit", "barcode"], drop=False)
    .sort_index()
)

validate(units, schema="../schemas/units.schema.yaml")

## genarate chromosome list


def get_chr_from_re(contig_patterns):
    contigs = []
    ref_fasta = config.get("reference", {}).get("fasta", "")
    all_contigs = extract_chr(f"{ref_fasta}.fai", filter_out=[])
    for pattern in contig_patterns:
        for contig in all_contigs:
            # print(pattern, contig)
            contig_match = re.match(pattern, contig)
            if contig_match is not None:
                # print(contig_match, contig_match.group())
                contigs.append(contig_match.group())
    # print(contigs)
    if len(set(contigs)) < len(contigs):  # check for duplicate conting entries
        chr_set = set()
        duplicate_contigs = [c for c in contigs if c in chr_set or chr_set.add(c)]
        dup_contigs_str = ", ".join(duplicate_contigs)
        sys.exit(
            f"Duplicate contigs detected:\n {dup_contigs_str}\n\
        Please revise the regular expressions listed under reference in the config"
        )

    return contigs


skip_contig_patterns = config.get("reference", {}).get("skip_contigs", [])

if len(skip_contig_patterns) == 0:
    skip_contigs = []
else:
    skip_contigs = get_chr_from_re(skip_contig_patterns)

ref_fai = config.get("reference", {}).get("fai", "")
chr_list = extract_chr(ref_fai, filter_out=skip_contigs)


### Read and validate output file

with open(config["output"]) as output:
    if config["output"].endswith("json"):
        output_spec = json.load(output)
    elif config["output"].endswith("yaml") or config["output"].endswith("yml"):
        output_spec = yaml.safe_load(output.read())

validate(output_spec, schema="../schemas/output_files.schema.yaml")


### Set wildcard constraints
wildcard_constraints:
    barcode="[A-Z-]+",
    sample="|".join(samples.index),
    type="N|T|R",


def get_bam_query(wildcards):
    markdups = config.get("markdups", "")
    unit = units.loc[(wildcards.sample, wildcards.type, wildcards.processing_unit, wildcards.barcode)]
    if markdups == "pbmarkdup":
        bam_file = f"prealignment/pbmarkdup/{{sample}}_{{type}}_{{processing_unit}}_{{barcode}}.bam"
    else:
        unit = units.loc[(wildcards.sample, wildcards.type, wildcards.processing_unit, wildcards.barcode)]
        bam_file = unit["bam"]

    return bam_file


def get_bam_input(wildcards, phaser=None):
    sample_str = f"{wildcards.sample}_{wildcards.type}"
    aligner = config.get("aligner")

    if not aligner:
        sys.exit("aligner missing from config, valid options: minimap2 or pbmm2")

    if phaser == "hiphase" and units.platform.iloc[0] == "ONT":
        sys.exit("Hiphase is restricted to Pacbio sequence data")

    bam_paths = {
        (None, "minimap2"): f"alignment/minimap2_align/{sample_str}.bam",
        (None, "pbmm2"): f"alignment/pbmm2_align/{sample_str}.bam",
        ("hiphase", "pbmm2"): f"snv_indels/hiphase/{sample_str}.haplotagged.bam",
        ("longphase", "minimap2"): f"snv_indels/longhase/{sample_str}.haplotagged.bam",
        ("hiphase", "minimap2"): f"snv_indels/hiphase/{sample_str}.haplotagged.bam",
    }

    bam_input = bam_paths.get((phaser, aligner))
    if not bam_input:
        sys.exit(
            "Valid options for aligner are: minimap2 or pbmm2. Valid phasers are hiphase for Pacbio or longphase for Pacbio and ONT"
        )

    return bam_input, f"{bam_input}.bai"


def get_haplotagged_bam(wildcards):
    sample_str = "{}_{}".format(wildcards.sample, wildcards.type)
    phaser = config.get("phaser", None)

    if phaser == "hiphase":
        bam_input = f"snv_indels/hiphase/{sample_str}.haplotagged.bam"
    elif aligner == "longphase":
        bam_input = f"snv_indels/longphase/{sample_str}.haplotagged.bam"
    else:
        sys.exit("valid options for phaser are: hiphase or longphase")

    bai_input = "{}.bai".format(bam_input)

    return (bam_input, bai_input)


def get_trgt_loci(wildcards):
    trgt_bed = config.get("trgt_genotype", {}).get("bed", "")
    rep_ids = []
    with open(trgt_bed, "r") as infile:
        for line in infile:
            cols = line.split("\t")
            rep_id = cols[3].split(";")[0]
            rep_ids.append(rep_id.split("=")[1])
    return rep_ids


def get_gvcf_output(wildcards, name):
    if config.get(name, {}).get("output_gvcf", False):
        return f" --output_gvcf snv_indels/deepvariant/{wildcards.sample}_{wildcards.type}_{wildcards.chr}.g.vcf.gz "
    else:
        return ""


def get_deepvariant_region(wildcards, input):
    try:
        bed_file = input.bed
        region_param = f"--regions {bed_file}"
    except KeyError:
        chrom = wildcards.chr
        region_param = f"--regions {chrom}"
    return region_param


def get_tr_bed(wildcards):
    tr_bed = config.get("sniffles2_call", {}).get("tandem_repeats", "")

    if tr_bed != "":
        tr_bed = f"--tandem-repeats {tr_bed}"

    return tr_bed


def compile_output_file_list(wildcards):
    outdir = pathlib.Path(output_spec.get("directory", "./"))
    output_files = []

    for f in output_spec["files"]:
        if config["pipeline"] == "pacbio_wgs":
            outputpaths = set(
                [
                    f["output"].format(sample=sample, type=unit_type, locus=locus, gene=gene, suffix=suffix)
                    for sample in get_samples(samples)
                    for unit_type in get_unit_types(units, sample)
                    for gene in config["paraphase"]["genes"]
                    for locus in get_trgt_loci(wildcards)
                    for suffix in [config.get("trgt_plot_motif", {}).get("image", "svg")]
                ]
            )
        elif config["pipeline"] == "pacbio_twist_cancer":
            print('testing')
            outputpaths = set(
                [
                    f["output"].format(sample=sample, type=unit_type, gene=gene)
                    for sample in get_samples(samples)
                    for unit_type in get_unit_types(units, sample)
                    for gene in config["paraphase"]["genes"]
                ]
            )
        elif config["pipeline"] == "ont_target_str":
            outputpaths = set(
                [
                    f["output"].format(sample=sample, type=unit_type)
                    for sample in get_samples(samples)
                    for unit_type in get_unit_types(units, sample)
                ]
            )
        else:
            sys.exit("pipeline has not be specified in the config file")

        for op in outputpaths:
            output_files.append(outdir / Path(op))

    return output_files


def generate_copy_rules(output_spec):
    output_directory = pathlib.Path(output_spec.get("directory", "./"))
    rulestrings = []

    for f in output_spec["files"]:
        if f["input"] is None:
            continue

        rule_name = "_copy_{}".format("_".join(re.split(r"\W{1,}", f["name"].strip().lower())))
        input_file = pathlib.Path(f["input"])
        output_file = output_directory / pathlib.Path(f["output"])

        mem_mb = config.get("_copy", {}).get("mem_mb", config["default_resources"]["mem_mb"])
        mem_per_cpu = config.get("_copy", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"])
        partition = config.get("_copy", {}).get("partition", config["default_resources"]["partition"])
        threads = config.get("_copy", {}).get("threads", config["default_resources"]["threads"])
        time = config.get("_copy", {}).get("time", config["default_resources"]["time"])
        copy_container = config.get("_copy", {}).get("container", config["default_container"])

        rule_code = "\n".join(
            [
                f'@workflow.rule(name="{rule_name}")',
                f'@workflow.input("{input_file}")',
                f'@workflow.output("{output_file}")',
                f'@workflow.log("logs/{rule_name}_{output_file.name}.log")',
                f'@workflow.container("{copy_container}")',
                f'@workflow.resources(time="{time}", threads={threads}, mem_mb="{mem_mb}", '
                f'mem_per_cpu={mem_per_cpu}, partition="{partition}")',
                f'@workflow.shellcmd("{copy_container}")',
                "@workflow.run\n",
                f"def __rule_{rule_name}(input, output, params, wildcards, threads, resources, "
                "log, version, rule, conda_env, container_img, singularity_args, use_singularity, "
                "env_modules, bench_record, jobid, is_shell, bench_iteration, cleanup_scripts, "
                "shadow_dir, edit_notebook, conda_base_path, basedir, runtime_sourcecache_path, "
                "__is_snakemake_rule_func=True):",
                '\tshell("(cp --preserve=timestamps {input[0]} {output[0]}) &> {log}", bench_record=bench_record, '
                "bench_iteration=bench_iteration)\n\n",
            ]
        )

        rulestrings.append(rule_code)

    exec(compile("\n".join(rulestrings), "copy_result_files", "exec"), workflow.globals)


generate_copy_rules(output_spec)

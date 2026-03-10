__author__ = "Padraic Corcoran"
__copyright__ = "Copyright 2025, Padraic Corcoran"
__email__ = "padraic.corcoran@scilifelab.uu.se"
__license__ = "GPL-3"


rule straglr:
    input:
        bam="alignment/minimap2_align/{sample}_{type}.bam",
        loci=config.get("reference", {}).get("straglr_loci", ""),
        ref=config.get("reference", {}).get("fasta", ""),
    output:
        vcf="cnv_sv/straglr/{sample}_{type}.vcf",
        tsv="cnv_sv/straglr/{sample}_{type}.tsv",
        bed="cnv_sv/straglr/{sample}_{type}.bed",
    params:
        extra=config.get("straglr", {}).get("extra", ""),
        prefix=lambda wildcards, output: "{}/{}_{}".format(os.path.split(output[0])[0], wildcards.sample, wildcards.type),
    log:
        "cnv_sv/straglr/{sample}_{type}.vcf.log",
    benchmark:
        repeat(
            "cnv_sv/straglr/{sample}_{type}.vcf.benchmark.tsv",
            config.get("straglr", {}).get("benchmark_repeats", 1)
        )
    threads: config.get("straglr", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("straglr", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("straglr", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("straglr", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("straglr", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("straglr", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("straglr", {}).get("container", config["default_container"])
    message:
        "{rule}: run straglr on {input.bam}"
    shell:
        "(straglr.py {input.bam} "
        "{input.ref} "
        "{params.prefix} "
        "--loci {input.loci} "
        "{params.extra}) &> {log}"
__author__ = "Padraic Corcoran"
__copyright__ = "Copyright 2024, Padraic Corcoran"
__email__ = "padraic.corcoran@scilifelab.uu.se"
__license__ = "GPL-3"


rule picard_bed_to_interval_list:
    input:
        bed=config.get("reference", {}).get("design_bed", ""),
        reference=config["reference"]["fasta"],
        dict="qc/picard_create_sequence_dictionary/reference.dict"
    output:
        "qc/picard_bed_to_interval_list/targets.interval_list",
    params:
        extra=config.get("picard_bed_to_interval_list", {}).get("extra", ""),
    log:
        "qc/picard_bed_to_interval_list/targets.interval_list.log",
    benchmark:
        repeat(
            "qc/picard_bed_to_interval_list/targets.interval_list.benchmark.tsv",
            config.get("picard_bed_to_interval_list", {}).get("benchmark_repeats", 1)
        )
    threads: config.get("picard_bed_to_interval_list", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("picard_bed_to_interval_list", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("picard_bed_to_interval_list", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("picard_bed_to_interval_list", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("picard_bed_to_interval_list", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("picard_bed_to_interval_list", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("picard_bed_to_interval_list", {}).get("container", config["default_container"])
    message:
        "{rule}: create interval_list file from {input.bed}"
    wrapper:
        "0.79.0/bio/picard/bedtointervallist"


rule picard_create_sequence_dictionary:
    input:
        config["reference"]["fasta"],
    output:
        temp("qc/picard_create_sequence_dictionary/reference.dict"),
    params:
        extra=config.get("picard_create_sequence_dictionary", {}).get("extra", ""),
    log:
        "qc/picard_create_sequence_dictionary/reference.dict.log",
    benchmark:
        repeat(
            "qc/picard_create_sequence_dictionary/reference.dict.benchmark.tsv",
            config.get("picard_create_sequence_dictionary", {}).get("benchmark_repeats", 1)
        )
    threads: config.get("picard_create_sequence_dictionary", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("picard_create_sequence_dictionary", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("picard_create_sequence_dictionary", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("picard_create_sequence_dictionary", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("picard_create_sequence_dictionary", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("picard_create_sequence_dictionary", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("picard_create_sequence_dictionary", {}).get("container", config["default_container"])
    message:
        "{rule}: create a sequence dictionary file from {input}"
    wrapper:
        "0.79.0/bio/picard/createsequencedictionary"

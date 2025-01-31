__author__ = "Padraic Corcoran"
__copyright__ = "Copyright 2025, Padraic Corcoran"
__email__ = "padraic.corcoran@scilifelab.uu.se"
__license__ = "GPL-3"


rule extract_read_metrics:
    input:
        bam="prealignment/pbmarkdup/{sample}_{type}.bam",
    output:
        reads_metrics=temp("qc/extract_read_metrics/{sample}_{type}.metrics.tsv"),
        reads_summary=temp("qc/extract_read_metrics/{sample}_{type}.summary.tsv"),
    params:
        extra=config.get("extract_read_metrics", {}).get("extra", ""),
    log:
        "qc/extract_read_metrics/{sample}_{type}.metrics.log",
    benchmark:
        repeat(
            "extract_read_metrics/{sample}_{type}.metrics.benchmark.tsv",
            config.get("extract_read_metrics", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("extract_read_metrics", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("extract_read_metrics", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("extract_read_metrics", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("extract_read_metrics", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("extract_read_metrics", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("extract_read_metrics", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("extract_read_metrics", {}).get("container", config["default_container"])
    message:
        "{rule}: extract read metrics from {input.bam}"
    script:
        "../scripts/calculate_read_metrics.py"

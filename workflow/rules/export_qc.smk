__author__ = "Padraic Corcoran"
__copyright__ = "Copyright 2024, Padraic Corcoran"
__email__ = "padraic.corcoran@scilifelab.uu.se"
__license__ = "GPL-3"


rule export_qc_bedtools_intersect:
    input:
        input1="...",
    output:
        output1="fada/export_qc_bedtools_intersect/{sample}_{type}.output.txt",
    params:
        extra=config.get("export_qc_bedtools_intersect", {}).get("extra", ""),
    log:
        "fada/export_qc_bedtools_intersect/{sample}_{type}.output.log",
    benchmark:
        repeat(
            "fada/export_qc_bedtools_intersect/{sample}_{type}.output.benchmark.tsv",
            config.get("export_qc_bedtools_intersect", {}).get("benchmark_repeats", 1)
        )
    threads: config.get("export_qc_bedtools_intersect", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("export_qc_bedtools_intersect", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("export_qc_bedtools_intersect", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("export_qc_bedtools_intersect", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("export_qc_bedtools_intersect", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("export_qc_bedtools_intersect", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("export_qc_bedtools_intersect", {}).get("container", config["default_container"])
    message:
        "{rule}: do stuff on {input.input1}"
    wrapper:
        "..."


rule export_qc_bedtools_intersect_pgrs:
    input:
        input1="...",
    output:
        output1="fada/export_qc_bedtools_intersect_pgrs/{sample}_{type}.output.txt",
    params:
        extra=config.get("export_qc_bedtools_intersect_pgrs", {}).get("extra", ""),
    log:
        "fada/export_qc_bedtools_intersect_pgrs/{sample}_{type}.output.log",
    benchmark:
        repeat(
            "fada/export_qc_bedtools_intersect_pgrs/{sample}_{type}.output.benchmark.tsv",
            config.get("export_qc_bedtools_intersect_pgrs", {}).get("benchmark_repeats", 1)
        )
    threads: config.get("export_qc_bedtools_intersect_pgrs", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("export_qc_bedtools_intersect_pgrs", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("export_qc_bedtools_intersect_pgrs", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("export_qc_bedtools_intersect_pgrs", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("export_qc_bedtools_intersect_pgrs", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("export_qc_bedtools_intersect_pgrs", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("export_qc_bedtools_intersect_pgrs", {}).get("container", config["default_container"])
    message:
        "{rule}: do stuff on {input.input1}"
    wrapper:
        "..."


rule export_qc_xlsx_report:
    input:
        input1="...",
    output:
        output1="fada/export_qc_xlsx_report/{sample}_{type}.output.txt",
    params:
        extra=config.get("export_qc_xlsx_report", {}).get("extra", ""),
    log:
        "fada/export_qc_xlsx_report/{sample}_{type}.output.log",
    benchmark:
        repeat(
            "fada/export_qc_xlsx_report/{sample}_{type}.output.benchmark.tsv",
            config.get("export_qc_xlsx_report", {}).get("benchmark_repeats", 1)
        )
    threads: config.get("export_qc_xlsx_report", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("export_qc_xlsx_report", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("export_qc_xlsx_report", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("export_qc_xlsx_report", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("export_qc_xlsx_report", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("export_qc_xlsx_report", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("export_qc_xlsx_report", {}).get("container", config["default_container"])
    message:
        "{rule}: do stuff on {input.input1}"
    wrapper:
        "..."

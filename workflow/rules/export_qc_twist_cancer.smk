__author__ = "Padraic Corcoran"
__copyright__ = "Copyright 2024, Padraic Corcoran"
__email__ = "padraic.corcoran@scilifelab.uu.se"
__license__ = "GPL-3"


rule export_qc_bedtools_intersect:
    input:
        left="qc/mosdepth_bed_exon/{sample}_{type}.per-base.bed.gz",
        coverage_csi="qc/mosdepth_bed_exon/{sample}_{type}.per-base.bed.gz.csi",
        right=config["reference"]["exon_bed"],
    output:
        results=temp("qc/mosdepth_bed_exon/{sample}_{type}.mosdepth.per-base.exon_bed.txt"),
    params:
        extra=config.get("export_qc_bedtools_intersect", {}).get("extra", ""),
    log:
        "qc/mosdepth_bed_exon/{sample}_{type}.mosdepth.per-base.exon_bed.log",
    benchmark:
        repeat(
            "qc/mosdepth_bed_exon/{sample}_{type}.mosdepth.per-base.exon_bed.benchmark.tsv",
            config.get("export_qc_bedtools_intersect", {}).get("benchmark_repeats", 1),
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
        "{rule}: export low cov regions from {input.left} based on {input.right}"
    wrapper:
        "v1.32.0/bio/bedtools/intersect"


rule export_qc_bedtools_intersect_pgrs:
    input:
        left="qc/mosdepth_bed_exon/{sample}_{type}.per-base.bed.gz",
        coverage_csi="qc/mosdepth_bed_exon/{sample}_{type}.per-base.bed.gz.csi",
        right=config["reference"]["pgrs_bed"],
    output:
        results=temp("qc/mosdepth_bed_exon/{sample}_{type}.mosdepth.pgrs_cov.txt"),
    params:
        extra=config.get("export_qc_bedtools_intersect_pgrs", {}).get("extra", ""),
    log:
        "qc/mosdepth_bed_exon/{sample}_{type}.mosdepth.pgrs_cov.log",
    benchmark:
        repeat(
            "qc/mosdepth_bed_exon/{sample}_{type}.mosdepth.pgrs_cov.benchmark.tsv",
            config.get("export_qc_bedtools_intersect_pgrs", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("export_qc_bedtools_intersect_pgrs", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("export_qc_bedtools_intersect_pgrs", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("export_qc_bedtools_intersect_pgrs", {}).get(
            "mem_per_cpu", config["default_resources"]["mem_per_cpu"]
        ),
        partition=config.get("export_qc_bedtools_intersect_pgrs", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("export_qc_bedtools_intersect_pgrs", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("export_qc_bedtools_intersect_pgrs", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("export_qc_bedtools_intersect_pgrs", {}).get("container", config["default_container"])
    message:
        "{rule}: export low cov regions from {input.left} based on {input.right}"
    wrapper:
        "v1.32.0/bio/bedtools/intersect"


rule export_qc_xlsx_tc_report:
    input:
        mosdepth_summary="qc/mosdepth_bed_exon/{sample}_{type}.mosdepth.summary.txt",
        mosdepth_thresholds="qc/mosdepth_bed_exon/{sample}_{type}.thresholds.bed.gz",
        mosdepth_regions="qc/mosdepth_bed_exon/{sample}_{type}.regions.bed.gz",
        mosdepth_perbase="qc/mosdepth_bed_exon/{sample}_{type}.mosdepth.per-base.exon_bed.txt",
        pgrs_coverage="qc/mosdepth_bed_exon/{sample}_{type}.mosdepth.pgrs_cov.txt",
        design_bed=config["reference"]["exon_bed"],
        pgrs_bed=config["reference"]["pgrs_bed"],
        reads_summary="qc/extract_read_metrics/{sample}_{type}.summary.tsv",
        wanted_transcripts=config["reference"]["wanted_transcripts"],
    output:
        results=temp("qc/xlsx_report/{sample}_{type}.xlsx"),
    params:
        extra=config.get("export_qc_xlsx_report", {}).get("extra", ""),
        coverage_thresholds=config["mosdepth_bed"]["thresholds"],
        sequenceid=config["sequenceid"],
    log:
        "qc/xlsx_report/{sample}_{type}.xlsx.log",
    benchmark:
        repeat(
            "qc/xlsx_report/{sample}_{type}.xlsx.benchmark.tsv",
            config.get("export_qc_xlsx_report", {}).get("benchmark_repeats", 1),
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
        "{rule}: collecting qc values into {output} for the twist cancer design"
    script:
        "../scripts/export_qc_xlsx_tc_report.py"

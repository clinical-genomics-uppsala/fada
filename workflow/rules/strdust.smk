__author__ = "Padraic Corcoran"
__copyright__ = "Copyright 2025, Padraic Corcoran"
__email__ = "padraic.corcoran@scilifelab.uu.se"
__license__ = "GPL-3"


rule strdust:
    input:
        bam=lambda wildcards: get_input_aligned_bam(wildcards, config)[0],
        bai=lambda wildcards: get_input_aligned_bam(wildcards, config)[1],
        fasta=config.get("reference", {}).get("fasta", ""),
        repeats=config.get("reference", {}).get("str_bed", ""),
    output:
        vcf="cnv_sv/strdust/{sample}_{type}.vcf",
    params:
        extra=config.get("strdust", {}).get("extra", ""),
        sample=lambda wildcards: f"{wildcards.sample}_{wildcards.type}",
    log:
        "cnv_sv/strdust/{sample}_{type}.output.log",
    benchmark:
        repeat("cnv_sv/strdust/{sample}_{type}.output.benchmark.tsv", config.get("strdust", {}).get("benchmark_repeats", 1))
    threads: config.get("strdust", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("strdust", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("strdust", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("strdust", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("strdust", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("strdust", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("strdust", {}).get("container", config["default_container"])
    message:
        "{rule}: Call STRs in {input.bam} using STRdust"
    shell:
        "STRdust "
        "{params.extra} "
        "-t {threads} "
        "-R {input.repeats} "
        "--sample {params.sample} "
        "{input.fasta} "
        "{input.bam} > {output.vcf} 2> {log}"


rule strdust_sort:
    input:
        vcf="cnv_sv/strdust/{sample}_{type}.vcf",
    output:
        vcf="cnv_sv/strdust/{sample}_{type}.sorted.vcf.gz",
    params:
        extra=config.get("strdust_sort", {}).get("extra", ""),
    log:
        "cnv_sv/strdust/{sample}_{type}.sorted.vcf.log",
    benchmark:
        repeat("cnv_sv/strdust/{sample}_{type}.sorted.vcf.benchmark.tsv", config.get("strdust", {}).get("benchmark_repeats", 1))
    threads: config.get("strdust", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("strdust_sort", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("strdust_sort", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("strdust_sort", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("strdust_sort", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("strdust_sort", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("strdust_sort", {}).get("container", config["default_container"])
    message:
        "{rule}: sort {input.vcf} using bcftools"
    shell:
        "bcftools sort "
        "{params.extra} "
        "-O z "
        "-o {output.vcf} "
        "{input.vcf} 2> {log}"

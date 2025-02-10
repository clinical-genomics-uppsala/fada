__author__ = "Padraic Corcoran"
__copyright__ = "Copyright 2025, Padraic Corcoran"
__email__ = "padraic.corcoran@scilifelab.uu.se"
__license__ = "GPL-3"


rule strdust:
    input:
        bam="alignment/minimap2_align/{sample}_{type}.bam",
        bai="alignment/minimap2_align/{sample}_{type}.bam.bai",
        repeats=config.get("reference", {}).get("str_bed", ""),
        fasta=config.get("reference", {}).get("fasta", ""),
    output:
        vcf="cnv_sv/strdust/{sample}_{type}.vcf",
    params:
        extra=config.get("strdust", {}).get("extra", ""),
        sample=lambda wildcards: f"{wildcards.sample}_{wildcards.type}",
    log:
        "cnv_sv/strdust/{sample}_{type}.output.log",
    benchmark:
        repeat(
            "cnv_sv/strdust/{sample}_{type}.output.benchmark.tsv",
            config.get("strdust", {}).get("benchmark_repeats", 1)
        )
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
        "{input.bam} > {output.vcf} &> {log}"

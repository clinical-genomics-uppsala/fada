__author__ = "Padraic Corcoran"
__copyright__ = "Copyright 2025, Padraic Corcoran"
__email__ = "padraic.corcoran@scilifelab.uu.se"
__license__ = "GPL-3"


rule atarva_genotype:
    input:
        bam=lambda wildcards: get_input_aligned_bam(wildcards, config)[0],
        bai=lambda wildcards: get_input_aligned_bam(wildcards, config)[1],
        fasta=config.get("reference", {}).get("fasta", ""),
        regions=config.get("atarva_genotype", {}).get("bed", ""),
    output:
        vcf="cnv_sv/atarva_genotype/{sample}_{type}.vcf",
    params:
        extra=config.get("atarva_genotype", {}).get("extra", ""),
        sample_id=lambda wildcards: f"{wildcards.sample}_{wildcards.type}",
    log:
        "cnv_sv/atarva_genotype/{sample}_{type}.vcf.log",
    benchmark:
        repeat(
            "cnv_sv/atarva_genotype/{sample}_{type}.output.benchmark.tsv", config.get("atarva_genotype", {}).get("benchmark_repeats", 1)
        )
    threads: config.get("atarva_genotype", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("atarva_genotype", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("atarva_genotype", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("atarva_genotype", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("atarva_genotype", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("atarva_genotype", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("atarva_genotype", {}).get("container", config["default_container"])
    message:
        "{rule}: Call STRs in {input.bam} using atarva"
    shell:
        "atarva genotype "
        "--bam {input.bam} "
        "--fasta {input.fasta} "
        "--regions {input.regions} "
        "--vcf {output.vcf} "
        "{params.extra} "
        "--threads {threads} &> {log}"

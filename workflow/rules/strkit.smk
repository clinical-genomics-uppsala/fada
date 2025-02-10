__author__ = "Padraic Corcoran"
__copyright__ = "Copyright 2025, Padraic Corcoran"
__email__ = "padraic.corcoran@scilifelab.uu.se"
__license__ = "GPL-3"


rule strkit_call:
    input:
        bam="alignment/minimap2_align/{sample}_{type}.bam",
        bai="alignment/minimap2_align/{sample}_{type}.bam.bai",
        fasta=config.get("reference", {}).get("fasta", ""),
        loci=config.get("strkit_call", {}).get("bed", ""),
    output:
        vcf="cnv_sv/strkit_call/{sample}_{type}.vcf",
    params:
        extra=config.get("strkit_call", {}).get("extra", ""),
        sample_id=lambda wildcards: f"{wildcards.sample}_{wildcards.type}",
        #sex=get_sample_sex,
    log:
        "cnv_sv/strkit_call/{sample}_{type}.vcf.log",
    benchmark:
        repeat(
            "cnv_sv/strkit_call/{sample}_{type}.output.benchmark.tsv",
            config.get("strkit_call", {}).get("benchmark_repeats", 1)
        )
    threads: config.get("strkit_call", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("strkit_call", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("strkit_call", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("strkit_call", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("strkit_call", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("strkit_call", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("strkit_call", {}).get("container", config["default_container"])
    message:
        "{rule}: Call STRs in {input.bam} using strkit"
    shell:
        "strkit call "
        "{input.bam} " 
        "--ref {input.fasta} " 
        "--sample-id {params.sample_id} "
        "--loci {input.loci} "  
        "--vcf {output.vcf} " 
        "--processes {threads} &> {log}"

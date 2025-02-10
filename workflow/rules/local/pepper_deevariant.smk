



rule pepper_deepvariant:
    input:
        bam=lambda wildcards: get_bam_input(wildcards)[0],
        bai=lambda wildcards: get_bam_input(wildcards)[1],
        ref=config.get("reference", {}).get("fasta", ""),
    output:
        vcf=temp("snv_indels/pepper_deepvariant/{sample}_{type}/{sample}_{type}.vcf.gz"),
        bam=temp("snv_indels/pepper_deepvariant/{sample}_{type}/{sample}_{type}.haplotagged.bam"),
        bai=temp("snv_indels/pepper_deepvariant/{sample}_{type}/{sample}_{type}.haplotagged.bam.bai"),
    params:
        outdir="snv_indels/pepper_deepvariant/{sample}",
        prefix="{sample}_{type}",
        extra=config.get("pepper_deepvariant", {}).get("extra", ""),
    log:
        "snv_indels/pepper_deepvariant/{sample}_{type}.vcf.gz.log",
    benchmark:
        repeat(
            "snv_indels/pepper_deepvariant/{sample}_{type}.vcf.gz.benchmark.tsv",
            config.get("pepper_deepvariant", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("pepper_deepvariant", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("pepper_deepvariant", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("pepper_deepvariant", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("pepper_deepvariant", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("pepper_deepvariant", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("pepper_deepvariant", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("pepper_deepvariant", {}).get("container", config["default_container"])
    message:
        "{rule}: Run pepper_deepvariant on {input.bam}"
    shell:
        """
        run_pepper_margin_deepvariant call_variant \
        --ont_r9_guppy5_sup -f {input.ref} \
        -b {input.bam} \
        -o {params.outdir} \
        -p {params.prefix} \
        --phased_output \
        --t {threads}  &> {log} \

        mv {params.outdir}/intermediate_files/PHASED.PEPPER_MARGIN.haplotagged.bam {params.outdir}/{params.prefix}.haplotagged.bam
        mv {params.outdir}/intermediate_files/PHASED.PEPPER_MARGIN.haplotagged.bam.bai {params.outdir}/{params.prefix}.haplotagged.bam.bai

        """
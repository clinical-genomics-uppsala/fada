
rule samtools_view_on_target:
    input:
        bam=lambda wildcards: get_bam_input(wildcards)[0],
        bai=lambda wildcards: get_bam_input(wildcards)[1],
        bed=config.get("reference", {}).get("design_bed", ""),
    output:
        on_tsv=temp("qc/samtools_view_on_target/{sample}_{type}.reads.on_target.tsv"),
    params:
        extra=config.get("samtools_stats", {}).get("extra", ""),
    log:
        "qc/samtools_view_on_target/{sample}_{type}.reads.on_target.tsv.log",
    benchmark:
        repeat(
            "qc/samtools_view_on_target/{sample}_{type}.reads.on_target.tsv.benchmark.tsv",
            config.get("samtools_view_on_target", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("samtools_view_on_target", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("samtools_view_on_target", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("samtools_view_on_target", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("samtools_view_on_target", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("samtools_view_on_target", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("samtools_view_on_target", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("samtools_view_on_target", {}).get("container", config["default_container"])
    message:
        "{rule}: extract on target reads from {input.bam}"
    shell:
        """
        samtools view  {input.bam} -L {input.bed} | cut -f1 | sort | uniq > {output.on_tsv} 
        """


    
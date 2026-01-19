



rule cnvkit_segment1:
    input:
        log2_bins="cnv_sv/cnvkit_batch/{sample}/{sample}_{type}.cnr",
        snps="snv_indels/deepvariant/{sample}_{type}.fix_af.bcftools_view.SNPS.vcf.gz",
    output:
        segment=temp("cnv_sv/cnvkit_segment/{sample}_{type}.cns"),
    params:
        extra=config.get("cnvkit_segment", {}).get("extra", ""),
        method=config.get("cnvkit_segment", {}).get("method", "hmm-germline"),
    log:
        "cnv_sv/cnvkit_segment/{sample}_{type}.segmetrics.cns.log",
    benchmark:
        repeat(
            "cnv_sv/cnvkit_segment/{sample}_{type}.segmetrics.cns.benchmark.tsv",
            config.get("cnvkit_segment", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("cnvkit_segment", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("cnvkit_segment", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("cnvkit_segment", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("cnvkit_segment", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("cnvkit_segment", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("cnvkit_segment", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("cnvkit_segment", {}).get("container", config["default_container"])
    message:
        "{rule}: segment {input.log2_bins} with cnvkit using SNPs from {input.snps}"
    shell:
        "cnvkit.py segment "
        "-v {input.snps} "
        "-m {params.method} "
        "-o {output.segment} "
        "{params.extra} {input.log2_bins}  > {log} 2>&1 "

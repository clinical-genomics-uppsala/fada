__author__ = "Pádraic Corcoran"
__copyright__ = "Copyright 2026, Pádraic Corcoran"
__email__ = "padraic.corcoran@sciliflab.uu.se"
__license__ = "GPL-3"


rule bedtools_intersect_cnvkit:
    input:
        left="cnv_sv/cnvkit_vcf/{sample}_{type}.annotate_cnv.refseq_genes.bcftools_view.CNVS.vcf.gz",
        right=config.get("reference", {}).get("design_genes_bed", ""),
    output:
        vcf="cnv_sv/cnvkit_vcf/{sample}_{type}.annotate_cnv.refseq_genes.bcftools_view.gene.CNVS.vcf",
    params:
        extra=f"-F 0.6 -u -header {config.get('bedtools_intersect_cnvkit', {}).get('extra', '')}",
    log:
        "cnv_sv/cnvkit_vcf/{sample}_{type}.annotate_cnv.refseq_genes.bcftools_view.gene.CNVS.vcf.log",
    benchmark:
        repeat(
            "cnv_sv/cnvkit_vcf/{sample}_{type}.annotate_cnv.refseq_genes.bcftools_view.gene.CNVS.vcf.benchmark.tsv",
            config.get("bedtools_intersect_cnvkit", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("bedtools_intersect_cnvkit", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("bedtools_intersect_cnvkit", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("bedtools_intersect_cnvkit", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("bedtools_intersect_cnvkit", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("bedtools_intersect_cnvkit", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("bedtools_intersect_cnvkit", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("bedtools_intersect_cnvkit", {}).get("container", config["default_container"])
    message:
        "{rule}: export CNVS that include the majority of the target gene from {input.left} based on {input.right}"
    wrapper:
        "v1.32.0/bio/bedtools/intersect"

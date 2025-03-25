__author__ = "Padraic Corcoran"
__copyright__ = "Copyright 2025, Padraic Corcoran"
__email__ = "padraic.corcoran@scilifelab.uu.se"
__license__ = "GPL-3"


rule add_vcf_ref:
    input:
        vcf="{file}.vcf.gz",
        ref=config["reference"]["fasta"],
    output:
        vcf="{file}_GRCh38.vcf",
    params:
        extra=config.get("add_vcf_ref", {}).get("extra", ""),
    log:
        "fada/add_vcf_ref/{file}_GRCh38.vcf.gz.log",
    benchmark:
        repeat(
            "fada/add_vcf_ref/{file}_GRCh38.vcf.gz.benchmark.tsv",
            config.get("add_vcf_ref", {}).get("benchmark_repeats", 1)
        )
    threads: config.get("add_vcf_ref", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("add_vcf_ref", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("add_vcf_ref", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("add_vcf_ref", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("add_vcf_ref", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("add_vcf_ref", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("add_vcf_ref", {}).get("container", config["default_container"])
    message:
        "{rule}: Add reference to the header of the {input.vcf}"
    script:
        "../scripts/add_ref.py"

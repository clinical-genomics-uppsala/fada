#!/bin/python3.9

import gzip


def add_reference_to_vcf(input_vcf, output_vcf, ref_str):
    """
    Adds a reference line to a gzipped VCF file.

    Args:
        input_vcf (str): Path to the input gzipped VCF file.
        output_vcf (str): Path to the output VCF file.
        ref_str (str): The reference string to add.
    """
    with gzip.open(input_vcf, 'r') as vcf_in:
        with open(output_vcf, 'w') as vcf_out:
            line_count = 0
            for line in vcf_in:
                line_count += 1
                if line_count == 4:
                    print(f"##reference={ref_str}", file=vcf_out)
                print(line.decode(encoding="utf-8").rstrip(), file=vcf_out)


if __name__ == "__main__":
    add_reference_to_vcf(snakemake.input.vcf, snakemake.output.vcf, snakemake.input.ref)

#!/bin/python3.9

import gzip
import tempfile
import os


def test_add_reference_to_vcf():
    from add_ref import add_reference_to_vcf
    # Create a temporary input VCF file
    with tempfile.NamedTemporaryFile(delete=False, suffix=".vcf.gz") as input_file:
        input_file.write(gzip.compress(b"""##fileformat=VCFv4.2
##INFO=<ID=DP,Number=1,Type=Integer,Description="Read Depth">
##INFO=<ID=AF,Number=A,Type=Float,Description="Allele Frequency">
#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO
chr1\t100\trs123\tA\tC\t60\tPASS\tDP=10;AF=0.5
chr1\t200\trs456\tG\tT\t50\tPASS\tDP=20;AF=1.0
""".replace(b"\n", b"\r\n")))  # windows line endings
        input_file_path = input_file.name

    # Create a temporary output VCF file
    with tempfile.NamedTemporaryFile(delete=False, suffix=".vcf") as output_file:
        output_file_path = output_file.name

    # Process the VCF file
    ref_str = "GRCh38"
    add_reference_to_vcf(input_file_path, output_file_path, ref_str)

    # Read the output VCF file and verify the contents
    with open(output_file_path, 'r') as output_file:
        output_lines = output_file.readlines()

    expected_lines = [
        "##fileformat=VCFv4.2\n",
        "##INFO=<ID=DP,Number=1,Type=Integer,Description=\"Read Depth\">\n",
        "##INFO=<ID=AF,Number=A,Type=Float,Description=\"Allele Frequency\">\n",
        f"##reference={ref_str}\n",
        "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\n",
        "chr1\t100\trs123\tA\tC\t60\tPASS\tDP=10;AF=0.5\n",
        "chr1\t200\trs456\tG\tT\t50\tPASS\tDP=20;AF=1.0\n",
    ]

    assert output_lines == expected_lines

    # Clean up temporary files
    os.unlink(input_file_path)
    os.unlink(output_file_path)

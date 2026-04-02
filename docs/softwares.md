# Softwares used in the fada module

## [bedtools_intersect_cnvkit](https://bedtools.readthedocs.io/en/latest/index.html)
Exports CNVs that include the majority of the target gene from a VCF based on a design BED file, effectively filtering CNVs by genomic intervals of interest.

### ![Snakemake](includes/images/logo-snake.svg){ width=30 style="vertical-align: middle;" } Rule

#SNAKEMAKE_RULE_SOURCE__bedtools__bedtools_intersect_cnvkit#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__bedtools__bedtools_intersect_cnvkit#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__bedtools_intersect_cnvkit#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__bedtools_intersect_cnvkit#

## [cnvkit_segment](https://cnvkit.readthedocs.io/en/stable/index.html)
Segments copy number ratio data (log2 bins) using CNVkit, incorporating SNP information for more accurate segmentation and germline HMM modeling.

### ![Snakemake](includes/images/logo-snake.svg){ width=30 style="vertical-align: middle;" } Rule

#SNAKEMAKE_RULE_SOURCE__cnvkit__cnvkit_segment#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__cnvkit__cnvkit_segment#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__cnvkit_segment#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__cnvkit_segment#

## [picard_bed_to_interval_list](https://broadinstitute.github.io/picard/command-line-overview.html)
Converts a genomic design BED file into a Picard-style interval list, using the reference FASTA and sequence dictionary for header information.

### ![Snakemake](includes/images/logo-snake.svg){ width=30 style="vertical-align: middle;" } Rule

#SNAKEMAKE_RULE_SOURCE__picard__picard_bed_to_interval_list#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__picard__picard_bed_to_interval_list#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__picard_bed_to_interval_list#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__picard_bed_to_interval_list#

## [picard_create_sequence_dictionary](https://broadinstitute.github.io/picard/command-line-overview.html)
Generates a sequence dictionary (SAM/BAM header format) from a reference FASTA file, required by various Picard and GATK tools.

### ![Snakemake](includes/images/logo-snake.svg){ width=30 style="vertical-align: middle;" } Rule

#SNAKEMAKE_RULE_SOURCE__picard__picard_create_sequence_dictionary#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__picard__picard_create_sequence_dictionary#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__picard_create_sequence_dictionary#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__picard_create_sequence_dictionary#


## [export_qc_bedtools_intersect](https://bedtools.readthedocs.io/en/latest/index.html)
Intersects mosdepth per-base coverage data with an exon BED file to identify and export low-coverage regions across targeted exons.

### ![Snakemake](includes/images/logo-snake.svg){ width=30 style="vertical-align: middle;" } Rule

#SNAKEMAKE_RULE_SOURCE__export_qc_twist_cancer__export_qc_bedtools_intersect#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__export_qc_twist_cancer__export_qc_bedtools_intersect#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__export_qc_bedtools_intersect#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__export_qc_bedtools_intersect#

## [export_qc_bedtools_intersect_pgrs](https://bedtools.readthedocs.io/en/latest/index.html)
Similar to the above, but specifically intersects per-base coverage with a PGRS (polyguanosine-rich sequences) BED file to assess coverage in complex regions.

### ![Snakemake](includes/images/logo-snake.svg){ width=30 style="vertical-align: middle;" } Rule

#SNAKEMAKE_RULE_SOURCE__export_qc_twist_cancer__export_qc_bedtools_intersect_pgrs#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__export_qc_twist_cancer__export_qc_bedtools_intersect_pgrs#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__export_qc_bedtools_intersect_pgrs#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__export_qc_bedtools_intersect_pgrs#

## [export_qc_xlsx_tc_report](https://github.com/clinical-genomics-uppsala/fada/blob/develop/workflow/scripts/export_qc_xlsx_tc_report.py)
A comprehensive Python script that aggregates various QC metrics—including mosdepth summaries, coverage thresholds, and read statistics—into a single Excel (XLSX) report for Twist Cancer designs.

### ![Snakemake](includes/images/logo-snake.svg){ width=30 style="vertical-align: middle;" } Rule

#SNAKEMAKE_RULE_SOURCE__export_qc_twist_cancer__export_qc_xlsx_tc_report#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__export_qc_twist_cancer__export_qc_xlsx_tc_report#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__export_qc_xlsx_tc_report#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__export_qc_xlsx_tc_report#

## [extract_read_metrics](https://github.com/clinical-genomics-uppsala/fada/blob/develop/workflow/scripts/calculate_read_metrics.py)
Calculates and extracts summary statistics from BAM files, including read lengths, qualities, and duplicate counts to assess library quality.

### ![Snakemake](includes/images/logo-snake.svg){ width=30 style="vertical-align: middle;" } Rule

#SNAKEMAKE_RULE_SOURCE__extract_read_metrics__extract_read_metrics#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__extract_read_metrics__extract_read_metrics#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__extract_read_metrics#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__extract_read_metrics#

## [strdust](https://github.com/wdecoster/STRdust/)
Calls Short Tandem Repeats (STRs) from BAM files using the STRdust tool, guided by a reference FASTA and a catalog of repeat loci.

### ![Snakemake](includes/images/logo-snake.svg){ width=30 style="vertical-align: middle;" } Rule

#SNAKEMAKE_RULE_SOURCE__strdust__strdust#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__strdust__strdust#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__strdust#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__strdust#

## [strkit_call](https://github.com/davidlougheed/strkit)
An alternative STR caller that performs locus-specific genotyping from long-read BAM files using the `strkit` tool.

### ![Snakemake](includes/images/logo-snake.svg){ width=30 style="vertical-align: middle;" } Rule

#SNAKEMAKE_RULE_SOURCE__strkit__strkit_call#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__strkit__strkit_call#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__strkit_call#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__strkit_call#

## [add_vcf_ref](https://github.com/clinical-genomics-uppsala/fada/blob/develop/workflow/scripts/add_ref.py)
A utility script that adds reference genome information to the header of a VCF file, ensuring compatibility with downstream tools that require the reference path.

### ![Snakemake](includes/images/logo-snake.svg){ width=30 style="vertical-align: middle;" } Rule

#SNAKEMAKE_RULE_SOURCE__add_vcf_ref__add_vcf_ref#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__add_vcf_ref__add_vcf_ref#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__add_vcf_ref#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__add_vcf_ref#


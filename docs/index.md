# Welcome to Fada 
This pipeline,  under development at [Clinical Genomics Uppsala](https://www.uu.se/en/research/clinical-genomics-uppsala), is used  to call variants from long-read data from rare disease patients. 
<br />
<br />
You can find the github repository at 
<a href="https://github.com/clinical-genomics-uppsala/fada/">https://github.com/clinical-genomics-uppsala/fada/</a>
<br />
<br />

Fada is a [snakemake](https://snakemake.readthedocs.io/en/stable/) pipeline that is built using modules from [Hydra Genetics](https://github.com/hydra-genetics/) to process long-read `.bam` files from Pacbio Revio and Oxford Nanopore Technologies (ONT) R10 data.

If Snakemake is new to you a good place to start is doing the [snakemake tutorial](https://snakemake.readthedocs.io/en/stable/tutorial/tutorial.html).



### Hydra-Genetics Modules
The current module versions (as configured in [`config/config.yaml`](https://github.com/clinical-genomics-uppsala/fada/blob/develop/config/config.yaml)) are:

{{ hydra_modules() }}

Each module is maintained as a separate repository within the [Hydra-Genetics organization](https://github.com/hydra-genetics) and can be updated independently. Version pinning ensures reproducible analyses.

## Supported Workflows

### PacBio Twist Cancer Panel
Targeted enrichment analysis for a hereditary cancer panel

    - Targeted SNV INDEL calling
    - CNV detection 
    - SV calling in target regions

### PacBio Whole Genome Sequencing *(under development)*
**This pipeline is currently used only for testing and development, we recommend the [GMS Nallo](https://github.com/genomic-medicine-sweden/nallo) pipeline for a comprehensive long-read WGS rare-disease pipeline**

WGS analysis including:

    - Genome-wide SNV and INDEL calling
    - Genome-wide SV and CNV detection
    - STR expansion detection

### ONT Targeted STR Analysis *(under development)*
Specialized workflow for short tandem repeat analysis with targeted ONT data:

    - STR expansion detection
    - STR expansion annotation
    - High-resolution repeat visualization








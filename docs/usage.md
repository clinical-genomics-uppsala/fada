# Usage Guide

This guide provides comprehensive instructions for running the fada pipeline using the commands demonstrated in the GitHub workflows.

## Prerequisites

### System Requirements
- Python 3.9 or higher (tested with python 3.11.13)
- Snakemake workflow management system (tested with version 7.32.4)
  - **Note**: This pipeline has not been tested with Snakemake 8.x or 9.x versions
- Container runtime (Docker or Singularity/Apptainer)

### Installation
1. Install Python dependencies:

```bash
python3.11 -m venv fada_env
source fada_env/bin/activate
pip install -r requirements.txt
```

2. For container-based execution, make sure that Singularity/Apptainer is installed.
   

## Workflow Types

Fada currently supports three main workflow configurations, each optimized for specific sequencing strategies and analysis goals.

### Input Data files

Each workflow requires specific samples and units input files:

This can be created using [hydra-genetics create-input-files](https://hydra-genetics.readthedocs.io/en/latest/run_pipeline/create_sample_files/#usage)


- **PacBio Twist Cancer**: 
```text
samples_pacbio_twist_cancer.tsv
units_pacbio_twist_cancer.tsv
```
- **PacBio WGS**: 
```text
samples_pacbio_wgs.tsv
units_pacbio_wgs.tsv
```
- **ONT STR**: 
```text
samples_ont_str.tsv
units_ont_str.tsv
```

### 1. PacBio Twist Cancer Panel 

#### Create the required samples and units input files

```bash
hydra-genetics create-input-files -d /path/to/pacbio/uBAM/-t N -p PACBIO --post-file-modifier pacbio_twist_cancer
```

Outputs:

```text
samples_pacbio_twist_cancer.tsv
units_pacbio_twist_cancer.tsv
```

#### Dry Run (Validation)
```bash
snakemake -n -s workflow/Snakefile \
  --configfiles config/config.yaml config/config_pacbio_twist_cancer.yaml \
  --config PIPELINE_REF_DATA=/path/to/reference/data/files sequenceid="test"
```

#### Running on a cluster

**Recommended:** Use a cluster profile for better resource management, the example uses the example profiles yaml file in the github repo

```bash

snakemake --profile profiles/marvin_cpu -s workflow/Snakefile \
  --configfiles config/config.yaml config/config_pacbio_twist_cancer.yaml \
  --config PIPELINE_REF_DATA=/path/to/reference/data/files sequenceid="your_run_id"  
```

### 2. PacBio Whole Genome Sequencing (WGS)

#### Create the required samples and units input files
    
```bash
hydra-genetics create-input-files -d /path/to/pacbio/uBAM/-t N -p PACBIO --post-file-modifier pacbio_wgs
```

Outputs:

```text
samples_pacbio_wgs.tsv
units_pacbio_wgs.tsv
```

#### Production Run (Recommended: Use Profile)
```bash
snakemake --profile profiles/marvin_cpu -s workflow/Snakefile \
  --configfiles config/config.yaml config/config_pacbio_wgs.yaml \
  --config PIPELINE_REF_DATA=/path/to/reference/data/files \
  --use-singularity
```

### 3. ONT Targeted STR Analysis

```bash
hydra-genetics create-input-files -p ONT -d /path/to/ONT/uBAM/ -t N -b 'NNNN'  --post-file-modifier "ont_str" 
```

Outputs:

```text
samples_ont_str.tsv
units_ont_str.tsv
```

```bash
snakemake --profile profiles/marvin_cpu -s workflow/Snakefile \
  --configfiles config/config.yaml config/config_ont_target_str.yaml \
  --config PIPELINE_REF_DATA=/path/to/reference/data/files \
  --use-singularity
```

## Command Parameters Explained

### Configuration Files
- `--configfiles config/config.yaml`: Main pipeline configuration
- Additional workflow-specific configs:
  - `config/config_pacbio_twist_cancer.yaml`: Cancer panel settings
  - `config/config_pacbio_wgs.yaml`: PacBio WGS settings
  - `config/config_ont_target_str.yaml`: ONT STR analysis settings

### Runtime Configuration
- `--config PIPELINE_REF_DATA=reference`: Specifies reference data location
- `--config sequenceid="test"`: Set sequence identifier (Twist cancer only, may remove this in future)
- `--config resources=resources.yaml`: Custom resource allocation

### Core Snakemake Parameters
- `-s workflow/Snakefile`: Specifies path to the main Snakefile to execute
- `-n`: Dry run mode - validates the workflow without execution
- `-p`: Print shell commands being executed
- `--show-failed-logs`: Display logs from failed jobs for debugging

### Container Execution
- `--use-singularity`: Enable Singularity container execution
- `--singularity-args`: Container-specific arguments
  - `--no-home`: Don't bind home directory
  - `--cleanenv`: Use clean environment
  - `--bind /path/to/your/data`: Bind data directories to container
- `--singularity-prefix singularity_files`: Directory for cached container images

### Profile Configuration

#### Example Profile in This Repository
This repository includes an example SLURM profile at [`profiles/marvin_cpu/`](https://github.com/clinical-genomics-uppsala/fada/tree/develop/profiles/marvin_cpu) that demonstrates:

- **SLURM-DRMAA integration**: Uses the DRMAA (Distributed Resource Management Application API) interface for job submission to SLURM
- **Singularity container execution**: Automatically enables Singularity with appropriate bind mounts and resource constraints
- **Optimized settings**: Configured for high-throughput execution with job parallelization and resource management

To use this profile as a template for your own cluster:
```bash
# Copy and modify the profile for your environment
cp -r profiles/marvin_cpu/ profiles/my_cluster/
# Edit profiles/my_cluster/config.yaml to match your cluster configuration
# Then run with your custom profile
snakemake --profile profiles/my_cluster/ -s workflow/Snakefile \
  --configfiles config/config.yaml config/config_pacbio_twist_cancer.yaml \
  --config PIPELINE_REF_DATA=reference sequenceid="your_sample_id"
```

For additional profile examples and documentation, see the [Snakemake profiles documentation](https://snakemake.readthedocs.io/en/stable/executing/cluster.html#profiles) and the [snakemake-profiles repository](https://github.com/snakemake-profiles) for ready-to-use cluster profiles.



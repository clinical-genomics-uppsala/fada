# <img src="images/hydragenetics.png" width=40 /> Fada


#### Pipeline for germline variant detection in longread sequence data

![Lint](https://github.com/clinical-genomics-uppsala/fada/actions/workflows/lint.yaml/badge.svg?branch=develop)
![Snakefmt](https://github.com/clinical-genomics-uppsala/fada/actions/workflows/snakefmt.yaml/badge.svg?branch=develop)
![snakemake dry run](https://github.com/clinical-genomics-uppsala/fada/actions/workflows/snakemake-dry-run.yaml/badge.svg?branch=develop)
![integration test](https://github.com/clinical-genomics-uppsala/fada/actions/workflows/integration.yaml/badge.svg?branch=develop)

![pycodestyle](https://github.com/clinical-genomics-uppsala/fada/actions/workflows/pycodestyle.yaml/badge.svg?branch=develop)
![pytest](https://github.com/clinical-genomics-uppsala/fada/actions/workflows/pytest.yaml/badge.svg?branch=develop)

[![License: GPL-3](https://img.shields.io/badge/License-GPL3-yellow.svg)](https://opensource.org/licenses/gpl-3.0.html)


## :heavy_exclamation_mark: Dependencies

In order to use this module, the following dependencies are required:

[![clinical-genomics-uppsala](https://img.shields.io/badge/hydragenetics-v3.0.0-blue)](https://github.com/hydra-genetics/)
[![pandas](https://img.shields.io/badge/pandas-1.3.1-blue)](https://pandas.pydata.org/)
[![python](https://img.shields.io/badge/python-3.9-blue)
[![snakemake](https://img.shields.io/badge/snakemake-7.26.0-blue)](https://snakemake.readthedocs.io/en/stable/)
[![singularity](https://img.shields.io/badge/singularity-3.11.0-blue)](https://sylabs.io/docs/)

## :school_satchel: Preparations

### Sample data

Input data should be added to [`samples.tsv`](https://github.com/hydra-genetics/fada/blob/develop/config/samples.tsv)
and [`units.tsv`](https://github.com/hydra-genetics/fada/blob/develop/config/units.tsv).
The following information need to be added to these files:



## :white_check_mark: Testing

The workflow repository contains a small test dataset `.tests/integration` which can be run like so:

```bash
$ cd .tests/integration
$ snakemake -s ../../Snakefile --configfiles ../../config/config.yaml config/config.yaml -j1 --use-singularity
```
`../../config/config.yaml` is the original config-file, while `config/config.yaml` is the test config. By defining two config-files the latter overwrites any overlapping variables in the first config-file.

## :judge: Rule Graph
![rule_graph_reference](images/rulegraph.svg)
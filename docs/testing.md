# Testing the Fada Pipeline

Fada uses a multi-layered testing approach to ensure the robustness and correctness of its genomic data processing workflows.

## Linting and Code Style

Maintaining a consistent and clean codebase is essential for readability and reducing bugs.

### Snakemake Linting
To check the Snakemake files for potential issues, usage of best practices, and inconsistencies:
```bash
snakemake --lint
```

### Formatting with snakefmt
All Snakemake files are formatted using `snakefmt`. You can check or apply formatting as follows:
```bash
# Check formatting
snakefmt -l 130 --check workflow

# Apply formatting
snakefmt -l 130 workflow
```

## Unit Testing (Python Scripts)

Python scripts located in `workflow/scripts` are tested using `pytest`. 

### Running Pytest
Ensure you have the test requirements installed:
```bash
pip install -r requirements.test.txt
```
Then run the tests from the root directory:
```bash
pytest workflow/scripts
```

## Integration Testing (Small Datasets)

Integration tests verify that the entire pipeline executes correctly from start to finish using small, dummy datasets. These tests are located in the `.tests/integration` directory. A small integration test dataset is included in the repository for this purpose.

### Running Integration Tests Manually

```bash
cd .tests/integration
snakemake -s ../../workflow/Snakefile -j 2 \
    --configfiles config/config.yaml config/config_pacbio_twist_cancer.yaml \
    --config resources=resources_test.yaml PIPELINE_REF_DATA=reference sequenceid="test" \
    --use-singularity
```


## Continuous Integration (GitHub Actions)

Every pull request and push to the `develop` or `main` branches triggers a suite of automated tests on GitHub Actions:

- **Linting**: Automated checks for Snakemake linting, `snakefmt`, and `pycodestyle`.
- **Dry-run**: Verifies that the Snakemake DAG can be successfully constructed for various configurations.
- **Unit Tests**: Runs `pytest` across all workflow scripts.
- **Integration Tests**: Executes a small dataset run using Singularity to ensure full-pipeline integrity.

Before submitting a pull request, ensure that all tests pass locally.

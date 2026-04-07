# Documentation Development

This guide explains how to build and contribute to the fada pipeline documentation.

## Building Documentation Locally

To generate the Read the Docs (RTD) HTML documentation locally:

### Prerequisites
1. Install the documentation dependencies:
```bash
pip install -r docs/requirements.txt
```

## Online Documentation

The fada pipeline documentation is hosted online and automatically updated with each release:

**Documentation URL**: [https://fada.readthedocs.io/en/latest/](https://fada.readthedocs.io/en/latest/)

The online documentation includes all the same content available locally and is the recommended way to access the most up-to-date information about the pipeline.

### Build
1. **Build the documentation**:
```bash
mkdocs build
```
This creates the HTML files in the `site/` directory.

### Documentation Structure
The documentation is configured via [`mkdocs.yaml`](https://github.com/clinical-genomics-uppsala/fada/blob/develop/mkdocs.yaml) and includes:
- Pipeline overview and setup instructions
- Rule documentation with automatic generation from Snakemake rules
- Schema validation for configuration files
- Custom styling and plugins for enhanced functionality

## Contributing to Documentation

### File Organization
- **`docs/`**: Main documentation directory
- **`mkdocs.yaml`**: MkDocs configuration file
- **`docs/requirements.txt`**: Documentation build dependencies
- **`docs/includes/`**: Reusable content snippets

### Markdown Extensions
The documentation uses several MkDocs extensions:
- **PyMdown Extensions**: Enhanced markdown features
- **Schema Reader**: Automatic schema documentation
- **Snakemake Rule Plugin**: Automatic rule documentation
- **Include Markdown**: For content reuse

### Live Development
For active documentation development:
```bash
# Start development server
mkdocs serve

# View at http://127.0.0.1:8000/
# Changes are automatically reflected
```

## Deployment

### Automated Documentation Building
Documentation is automatically built and deployed via GitHub Actions when changes are pushed to the main branches. The pipeline includes:

- **Continuous Integration**: The [`test-build-mkdocs.yaml`](https://github.com/clinical-genomics-uppsala/fada/blob/develop/.github/workflows/test-build-mkdocs.yaml) workflow automatically tests documentation builds on pull requests and pushes
- **Automatic Deployment**: Documentation is built and published to ReadTheDocs
- **Dependency Management**: The workflow automatically installs documentation dependencies from `docs/requirements.txt`
- **Build Validation**: Ensures all documentation builds successfully before merging changes

This automation ensures that the documentation is always up-to-date with the latest pipeline changes and that broken documentation builds are caught early in the development process.
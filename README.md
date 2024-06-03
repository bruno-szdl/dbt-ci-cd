# dbt-ci-cd

## Overview

This repository contains the dbt project for Jaffle Shop, configured with a CI/CD pipeline using GitHub Actions and Google Cloud Platform (GCP). This setup is designed to demonstrate and implement best practices for testing and deploying dbt models. It's adaptable for others platforms beyond GCP.

## CI/CD Pipeline Explanation

The GitHub Actions configuration is divided into two primary workflow files: `CI.yml` for Continuous Integration and `CD.yml` for Continuous Deployment.

### Continuous Integration (CI) Workflow

The `CI.yml` workflow triggers on every pull request to the `main` branch to ensure that changes are tested before merging. The workflow details are as follows:

1. **Dependencies Installation**
      - **Python Dependencies**: Install all required Python packages specified in `dbt-requirements.txt`.
      - **Google Cloud SDK Installation**: Install the Google Cloud SDK to interact with Google Cloud resources.

2. **Authentication**
      - **Service Account Authentication**: Utilize the Google Cloud SDK to authenticate using a service account key, crucial for accessing GCP services securely.

3. **Schema Management**
      - **Dynamic Schema Creation**: Generate a unique schema identifier based on the pull request ID and commit hash. This schema is used to isolate testing from the production environment.

4. **dbt Commands Execution**
      - **Debugging and Dependencies**: Run `dbt debug` and `dbt deps` to verify configurations and fetch dependencies.
      - **Conditional Build**: Attempt to download the `manifest.json` to compare with the local changes.
         - If present, dbt builds only modified and downstream resources (`state:modified+`) in the new schema. To be able to build only modified resources, it references the upstream resources from the production schema, using the  `--defer` flag.
         - This comparison ensures that only resources affected by the changes are tested.
         - If no manifest.json is found, it performs a full build.
      - **Schema Cleanup**: After testing, the temporary schema is dropped to clean up resources. This step actually is a on-run-end hook, and not a pipeline step.

### Continuous Deployment (CD) Workflow

The `CD.yml` workflow executes when changes are merged into the main branch. It builds modified dbt resources and downstream dependencies in the production schema, ensuring that production data remains up-to-date:

1. **Environment and Authentication Setup**
      - As in the CI workflow, prepare environment variables and authenticate using the Google Cloud SDK.

2. **Retrieve Production Manifest**
      - **Manifest Download**: Download the existing `manifest.json` from GCP to handle incremental builds by identifying changed models.

3. **Production dbt Execution**
      - **Production Build**: Execute dbt commands to update the production environment. It builds modified resources and their downstream dependencies (`state:modified+`), using the updated manifest to determine changes. If no manifest.json is found, it performs a full build (useful when running the project for the first time).
      - **Manifest Update**: After successful deployment, upload the current `manifest.json` back to GCP. This step updates the manifest to reflect the latest state, for subsequent CI runs.

## Platform Flexibility

This pipeline is designed with flexibility in mind, particularly in terms of platform dependency. The steps involving authentication and manifest handling are currently tailored for GCP but can be adapted for other platforms like AWS, Azure, or even on-premise solutions.

### Modifying for Other Platforms

- **Authentication**: Replace GCP authentication steps with corresponding steps for AWS (using AWS CLI and IAM roles) or Azure (using Azure CLI and service principals).
- **Manifest Storage**: Change commands related to `gsutil` (used for interacting with Google Cloud Storage) to equivalent commands for other services like Amazon S3 or Azure Blob Storage.

## Setup and Configuration

To implement this pipeline:
1. **Clone the Repository**: Get a copy of this repository.
2. **Configure Environment Variables**: Set all necessary variables in GitHub Secrets settings.

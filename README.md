# GAMS Engine Helm Chart

This repository hosts the official Helm chart for deploying **GAMS Engine**. GAMS Engine is a powerful system for managing and solving GAMS models in a scalable, cloud-native environment (see https://gams.com/engine for more information).

## 🚀 Deployment

The official Helm repository is hosted at **charts.gams.com**. To add the repository and install the chart:

```bash
helm repo add gams https://charts.gams.com
helm repo update
helm install my-gams-engine gams/gams-engine
```

---

## 🛠 Development & Contribution

We welcome contributions! To ensure high code quality and consistent documentation, this project uses specific tooling that must be configured locally before submitting a Merge Request.

### Prerequisites

1.  **pre-commit**: Manages hooks that lint and validate files.
2.  **helm-docs**: Automatically generates documentation for the chart.

### Getting Started

1.  **Install the tools**:
    ```bash
    # Install pre-commit
    pip install pre-commit

    # Install helm-docs
    brew install norwoodj/tap/helm-docs
    ```

2.  **Set up hooks**:
    Run the following command in the root of the repository to initialize the pre-commit hooks:
    ```bash
    pre-commit install
    ```

Once set up, `helm-docs` and other linters will run automatically every time you attempt a commit. If the documentation in `README.md` is out of sync with `values.yaml`, the commit will be blocked until the documentation is regenerated and staged.

### CI Validation
The GitLab CI pipeline also runs these **pre-commit hooks** on every push to ensure compliance. If the hooks fail locally, they will also fail in the pipeline, blocking the merge.

---

## 🏗 CI/CD & Release Workflow

The release process for this chart is fully automated:

* **Manual Contributions**: When a Merge Request is merged into the `main` branch, a GitLab CI job automatically packages and pushes a new release to **charts.gams.com**.
* **Engine Updates**: When a new version of GAMS Engine is published, the Engine pipeline automatically increases the **minor version** of this chart and pushes the change to `main`, which triggers a new chart release.
* **Version Enforcement**: Any Merge Request targeting `main` must include an incremented version number in `gams-engine/Chart.yaml` to pass the CI pipeline.

---

*For issues or feature requests, please open an issue in this project.*

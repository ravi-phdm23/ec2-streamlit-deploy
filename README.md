Here is your complete `README.md` content in Markdown format — ready to copy and paste:

```markdown
# 🔧 AWS EC2 Streamlit Deployment & Cleanup Automation

This repository automates the deployment of a Streamlit application on an AWS EC2 instance and provides a robust cleanup script to ensure **no residual AWS resources** are left behind — preventing unexpected billing.

---

## 📁 Repository Structure

```bash
aws-streamlit-automation/
├── deploy_streamlit_in_ec2.sh         # Provision EC2 & deploy Streamlit app
├── cleanup_all_aws.sh                 # Terminate EC2, delete security groups, volumes, AMIs, S3 buckets etc. from all regions
├── streamlit_app/
│   └── app.py                         # Your Streamlit app code
└── README.md                          # This documentation
```

---

## 🚀 Deployment Script: `deploy_streamlit_in_ec2.sh`

This script:

- Launches an EC2 instance
- Installs Python, pip, and Streamlit
- Uploads your local `streamlit_app` folder
- Launches the app on port `8501`
- Provides a public IP URL for access

### ✅ Usage

```bash
bash deploy_streamlit_in_ec2.sh
```

Make sure your Streamlit app is present in the `streamlit_app/` folder.

---

## 🧹 Cleanup Script: `cleanup_all_aws.sh`

This script ensures **full cleanup** across **all AWS regions**:

- Terminates all EC2 instances
- Deletes:
  - Non-default security groups
  - Elastic IPs
  - Unused volumes
  - Self-owned AMIs
  - Key pairs
  - S3 buckets with contents

### ✅ Usage

```bash
bash cleanup_all_aws.sh
```

> ⚠️ **Warning**: This script will permanently delete resources across your AWS account. Use only for test environments.

---

## 🔐 Security Considerations

- Your AWS credentials (`~/.aws/credentials`) must be pre-configured.
- Use IAM roles with least privilege for automation.
- Ensure `.pem` keys are permissioned (`chmod 400`) and not committed to the repository.

---

## 💰 Cost Control

This setup is designed for **Free Tier testing**. The cleanup script ensures:

- No EC2 is left running
- No S3 storage or reserved IPs remain
- Key pairs and volumes are removed

Still, always double-check your [AWS Billing Dashboard](https://console.aws.amazon.com/billing/home) after usage.

---

## 📜 License

MIT License © 2025

---

## 🛠️ Contribution

Feel free to open issues or pull requests to improve modularity, support for other cloud providers, or Docker-based deployments.
```

Let me know if you want a version that includes GitHub Actions or CI/CD integration for automated deployment checks.

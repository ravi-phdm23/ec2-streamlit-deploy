# AWS Streamlit Deployment & Cleanup Automation

This repository automates end-to-end deployment of a Streamlit app on AWS EC2 and provides a full cleanup script to ensure no resources incur billing after experimentation.

---

## 🔧 Prerequisites

- AWS CLI configured (`aws configure`)
- EC2 key pair ready or created during deployment
- IAM permissions for EC2, S3, and related services
- Streamlit app ready under `streamlit_app/`

---

## 🚀 Scripts

### 1. `deploy_streamlit_in_ec2.sh`

- Creates EC2 instance
- Installs Python, pip, Streamlit
- Deploys your app from `streamlit_app/`
- Prints access URL (`http://<EC2_PUBLIC_IP>:8501`)

**Run**:
```bash
bash deploy_streamlit_in_ec2.sh

# EC2 Streamlit Deploy

This repo automates deploying a Streamlit app on an AWS EC2 instance using shell scripts.

## Structure

- `create_ec2_instance.sh` – Launch EC2 instance
- `setup_key_permissions.sh` – Set SSH key permissions
- `deploy_streamlit_in_ec2.sh` – Install dependencies and launch Streamlit app
- `streamlit_app/` – Contains your `app.py` Streamlit code

## Deployment Instructions

1. Launch EC2:
   ```bash
   ./create_ec2_instance.sh
   ```

2. Set key permissions:
   ```bash
   ./setup_key_permissions.sh
   ```

3. Deploy the app:
   ```bash
   ./deploy_streamlit_in_ec2.sh
   ```

Then visit: `http://<your-ec2-public-ip>:8501`

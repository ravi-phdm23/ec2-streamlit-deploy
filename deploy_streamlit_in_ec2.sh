#!/bin/bash
sudo apt update
sudo apt install python3-pip -y
pip3 install streamlit pandas altair
cd ~/streamlit_app
nohup streamlit run app.py --server.port 8501 --server.enableCORS false &

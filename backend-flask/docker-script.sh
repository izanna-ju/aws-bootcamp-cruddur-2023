#!/usr/bin/bash

cd /workspace/aws-bootcamp-cruddur-2023/backend-flask

export FRONTEND_URL="*"
export BACKEND_URL="*"

python3 -m flask run --host=0.0.0.0 --port=4567

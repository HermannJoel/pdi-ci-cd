#!/usr/bin/env bash

echo "Initializing the Airflow database..."
airflow db init

echo "Creating admin user..."
airflow users create \
    --username admin \
    --firstname hermann \
    --lastname joel \
    --role Admin \
    --email hermannjoel.ngayap@gmail.com \
    --password admin

echo "Starting $1..."
exec airflow "$1"
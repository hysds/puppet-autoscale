#!/bin/bash
export HYSDS_HOME=$HOME
export DATA_DIR=/data
export HOST_UID=$(id -u)
export HOST_GID=$(id -g)
mkdir -p ${DATA_DIR}/work
chown -R ${HOST_UID}:${HOST_GID} $DATA_DIR

# First, need to read in the celeryconfig to get the podman commands
export PYTHONPATH=${HYSDS_HOME}/verdi/etc:${PYTHONPATH}

container_engine=$(python -c "from hysds.celery import app; import json; print(app.conf.get('CONTAINER_ENGINE'))")

# temporary print statement to make sure custom verdi AMI is using this script
echo "Using HC-522 version of the start-verdi.sh"

cd ${HYSDS_HOME}/verdi/ops/hysds-dockerfiles/verdi
if [[ "${container_engine}" == "docker" ]]; then
  /usr/local/bin/docker-compose up -d
elif [[ "${container_engine}" == "podman" ]]; then
  ./run_verdi_podman.sh
else
  echo "ERROR: ${container_engine} not supported. Cannot start verdi container."
fi

# docker-sdr
Docker container for running SDR packages

To build docker container
make

To initialise the docker volume for log persistence
make init

To run the docker container in the background
make start

To run a bash shell within the background container
make exec-bash

To archive logs (stops running container)
make volume-backup


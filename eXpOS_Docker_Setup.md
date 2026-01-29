# eXpOS Docker Setup

This guide explains how to set up eXpOS safely using Docker, without installing legacy libraries on your host system, while enabling a bidirectional sync between the host machine and the Docker container (useful for version control and backups).

## Folder Structure

```bash
OS_Lab/
├── Dockerfile
└── expos_container/      # MUST be empty initially
```

## Dockerfile

```Dockerfile
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    gcc make flex bison \
    libreadline-dev libc6-dev libfl-dev \
    wget curl unzip \
    git vim build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m expos
USER expos

# Set working directory to user's home
WORKDIR /home/expos
```

## Build Image

From inside `OS_Lab/` directory, run the following command

```bash
docker build -t expos:ubuntu20.04 .
```

## Run the Container

```bash
docker run -it \
  -v $PWD/expos_container:/home/expos \
  --name expos \
  expos:ubuntu20.04
```

- Mounts `expos_container` -> `/home/expos`
- Changes inside the container are reflected on the host system

## Download & Build eXpOS (INSIDE CONTAINER)

Once inside the container shell:

```bash
curl -sSf https://raw.githubusercontent.com/eXpOSNitc/expos-bootstrap/main/download.sh | sh
```

This will create `/home/expos/myexpos` inside your container. You will be able to view the changes in your local machine as well under `OS_Lab/expos_container/myexpos`.

Inside container shell, enter the following commands:

```bash
cd myexpos
make
```

If successful, you should see the following folders inside `myexpos` directory:

```bash
- spl/
- expl/
- xfs-interface/
- xsm/
```

**eXpOS installation is now complete. You may continue follownig everything from [eXpOS Roadmap](https://exposnitc.github.io/Roadmap.html$0) starting from Stage 2**.

## Restarting the Container Later

If you exit the container, restart it using:

```bash
docker container start expos
docker container exec -it expos /bin/bash
```

All your work remains preserved inside `expos_container/`.
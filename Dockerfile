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

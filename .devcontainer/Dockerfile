#FROM debian:stretch
FROM ubuntu:latest

RUN apt-get update && apt-get -y install git curl unzip



RUN apt-get update && \
    apt-get install -y cmake && \
    rm -rf /var/lib/apt/lists/* && \
    cd /tmp && \
    curl -sSL https://cmake.org/files/v3.21/cmake-3.21.3-linux-x86_64.sh -o cmake.sh && \
    sh cmake.sh -- --skip-license --prefix=/usr/local && \
    rm cmake.sh


RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /home/codespace
WORKDIR /home/codespace

ENV PUB_CACHE=/home/codespace/.pub_cache
ENV PATH="/home/codespace/flutter/bin:$PATH"

RUN git clone https://github.com/flutter/flutter && \
    /home/codespace/flutter/bin/flutter config --enable-web



FROM debian:buster-slim

WORKDIR /dump2obj

RUN apt-get update && apt-get install -y lsb-release wget libatomic1 libglib2.0-dev pigz jq && apt-get clean all && \
    wget https://github.com/maxbube/mydumper/releases/download/v0.10.1/mydumper_0.10.1-2.$(lsb_release -cs)_amd64.deb && \
    dpkg -i mydumper_0.10.1-2.$(lsb_release -cs)_amd64.deb && \
    wget https://dl.min.io/client/mc/release/linux-amd64/mc && chmod 700 mc

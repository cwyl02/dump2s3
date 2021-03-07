# FROM debian:buster-slim
FROM golang:1.13-buster

WORKDIR /dump2s3

RUN apt-get update && apt-get install -y lsb-release wget libatomic1 libglib2.0-dev mbuffer && apt-get clean all && \
    wget https://github.com/maxbube/mydumper/releases/download/v0.10.1/mydumper_0.10.1-2.$(lsb_release -cs)_amd64.deb && \
    dpkg -i mydumper_0.10.1-2.$(lsb_release -cs)_amd64.deb && \
    wget https://dl.min.io/client/mc/release/linux-amd64/mc && chmod +x mc

# /.mc/config.json

COPY ./cmd/main.go go.mod go.sum ./scripts/dump2s3.bash .
RUN go build -o dump2s3
# ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["./dump2s3"]
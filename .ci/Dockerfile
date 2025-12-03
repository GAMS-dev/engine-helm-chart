FROM alpine:latest

ARG HELM_VERSION=v3.19.0

RUN apk update && apk add --no-cache \
    wget \
    bash \
    aws-cli \
    ca-certificates \
    jq \
    yq \
    curl \
    tar \
    findutils \
    gnupg\
    git \
    unzip \
    py3-pip

RUN pip install --user --break-system-packages SQLAlchemy==1.3.24\
    Werkzeug==3.0.3

# Install helm
RUN curl -Lo helm.tar.gz "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" && \
    tar -zxvf helm.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm -rf helm.tar.gz linux-amd64

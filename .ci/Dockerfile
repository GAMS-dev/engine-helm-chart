FROM alpine:latest

ARG HELM_VERSION=v3.19.0
ARG HELM_DOCS_VERSION=1.14.2

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

# Install helm
RUN curl -Lo helm.tar.gz "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" && \
    tar -zxvf helm.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm -rf helm.tar.gz linux-amd64

RUN curl -L https://github.com/norwoodj/helm-docs/releases/download/v${HELM_DOCS_VERSION}/helm-docs_${HELM_DOCS_VERSION}_Linux_x86_64.tar.gz | tar -xz -C /usr/local/bin helm-docs && \
    chmod +x /usr/local/bin/helm-docs

RUN pip install --break-system-packages pre-commit

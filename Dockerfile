FROM alpine AS base
ARG KUBECTL_VERSION=v1.23.3
ARG KUSTOMIZE_VERSION=v3.8.7
ARG HELM_VERSION=3.7.1
ARG TARGETPLATFORM
RUN apk add curl openssl && \
    rm -rf /var/cache/apk/*
RUN curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${TARGETPLATFORM:-linux/amd64}/kubectl" && chmod +x kubectl && mv kubectl /usr/bin/kubectl
RUN curl https://api.github.com/repos/kubernetes-sigs/kustomize/releases/tags/kustomize/${KUSTOMIZE_VERSION} | grep "browser_.*$(echo ${TARGETPLATFORM:-linux/amd64} | sed -E 's/\//_/')" | cut -d '"' -f 4 > kustomize.txt
RUN curl -L $(cat kustomize.txt) -o kustomize.tar.gz && tar -zxf kustomize.tar.gz && chmod +x kustomize && mv kustomize /usr/bin/kustomize
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sh

FROM alpine
WORKDIR /srv
COPY --from=base /usr/bin/kustomize /usr/bin/kustomize
COPY --from=base /usr/local/bin/helm /usr/bin/helm
COPY --from=base /usr/bin/kubectl /usr/bin/kubectl
RUN apk add curl git openssl jq yq && \
    rm -rf /var/cache/apk/*
RUN mkdir -p /srv/.config/gcloud /srv/.config /srv/.kube /srv/data /srv/.skaffold && chown -R nobody:nogroup /srv

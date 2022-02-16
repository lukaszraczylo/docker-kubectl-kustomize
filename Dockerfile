ARG HELM_VERSION=3.7.1
ARG KUSTOMIZE_VERSION=v3.8.7

FROM alpine AS kubectl
ARG KUBECTL_VERSION=v1.23.3
ARG TARGETPLATFORM=linux/amd64
RUN apk add curl && \
    rm -rf /var/cache/apk/*
RUN echo https://dl.k8s.io/release/$KUBECTL_VERSION/bin/$TARGETPLATFORM/kubectl
RUN curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${TARGETPLATFORM}/kubectl" && chmod +x kubectl && mv kubectl /usr/bin/kubectl

FROM k8s.gcr.io/kustomize/kustomize:${KUSTOMIZE_VERSION} AS kustomize
FROM alpine/helm:${HELM_VERSION} AS helm

FROM alpine
WORKDIR /srv
COPY --from=kustomize /app/kustomize /usr/bin/kustomize
COPY --from=helm /usr/bin/helm /usr/bin/helm
COPY --from=kubectl /usr/bin/kubectl /usr/bin/kubectl
RUN apk add curl git openssl jq && \
    rm -rf /var/cache/apk/*
RUN mkdir -p /srv/.config/gcloud /srv/.config /srv/.kube /srv/data /srv/.skaffold && chown -R nobody:nogroup /srv

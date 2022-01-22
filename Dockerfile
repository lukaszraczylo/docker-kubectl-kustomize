ARG TARGETPLATFORM
ARG HELM_VERSION=3.7.1
ARG KUSTOMIZE_VERSION=v3.8.7
ARG KUBECTL_VERSION=1.23.2

FROM k8s.gcr.io/kustomize/kustomize:${KUSTOMIZE_VERSION} AS kustomize
FROM alpine/helm:${HELM_VERSION} AS helm

FROM alpine
WORKDIR /srv
COPY run.sh /srv/run.sh
RUN apk add curl git openssl jq && \
    rm -rf /var/cache/apk/* && \
    chmod +x /srv/run.sh

COPY --from=kustomize /app/kustomize /usr/bin/kustomize
COPY --from=helm /usr/bin/helm /usr/bin/helm
RUN curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${TARGETPLATFORM}/kubectl" && chmod +x kubectl && mv kubectl /usr/bin/kubectl
RUN mkdir -p /srv/.config/gcloud /srv/.config /srv/.kube /srv/data /srv/.skaffold && chown -R nobody:nogroup /srv
ENTRYPOINT ["/srv/run.sh"]
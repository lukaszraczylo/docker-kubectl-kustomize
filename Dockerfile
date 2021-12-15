FROM alpine
ARG TARGETPLATFORM
WORKDIR /srv
RUN apk add curl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${TARGETPLATFORM}/kubectl" && chmod +x kubectl && mv kubectl /usr/bin/kubectl
RUN echo "https://api.github.com/repos/kubernetes-sigs/kustomize/releases/tags/${KUSTOMIZE_RELEASE}/download/$(echo $KUSTOMIZE_RELEASE | sed -E 's/\//_/' )_$(echo ${TARGETPLATFORM} | sed -E 's/\//_/').tar.gz"
RUN KUSTOMIZE_RELEASE=$(curl --silent "https://api.github.com/repos/kubernetes-sigs/kustomize/releases" | grep '"tag_name": "kustomize/' | head -n 1 | sed -E 's/.*"([^"]+)".*/\1/') && \
    curl -LO "https://github.com/kubernetes-sigs/kustomize/releases/download/$( echo ${KUSTOMIZE_RELEASE} | sed -E 's/\//%2F/g' )/$(echo $KUSTOMIZE_RELEASE | sed -E 's/\//_/' )_$(echo ${TARGETPLATFORM} | sed -E 's/\//_/').tar.gz" && \
    tar -zxf $(echo $KUSTOMIZE_RELEASE | sed -E 's/\//_/' )_$(echo ${TARGETPLATFORM} | sed -E 's/\//_/').tar.gz && mv kustomize /usr/bin/kustomize && chmod +x /usr/bin/kustomize && rm -fr *.tar.gz
RUN mkdir -p /srv/.config/gcloud /srv/.config /srv/.kube /srv/data /srv/.skaffold && chown -R nobody:nogroup /srv
ENTRYPOINT ["/srv/run.sh"]
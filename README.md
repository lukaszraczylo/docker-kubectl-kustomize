## docker-kubectl-kustomize

Multiarch ( amd64, arm64 ) build of docker image with kubectl and kustomize baked in.
The builds run on schedule, always pulling the latest stable and released versions of the binaries.

Images are tagged with:
- `latest` as the ultimate bad practice
- `kustomize-v4.4.1` ( it's just an example, see below )
- `kubectl-v1.23.0` ( it's just an example, see below )

You can check for available tags in the [ghcr docker image](https://github.com/lukaszraczylo/docker-kubectl-kustomize/pkgs/container/docker-kubectl-kustomize) part of the repository.

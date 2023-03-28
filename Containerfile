FROM registry.fedoraproject.org/fedora-toolbox:37

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox command" \
      summary="A cloud-native terminal experience" \
      maintainer="peter.liveyns@gmail.com>"

COPY extra-packages /

RUN dnf upgrade -y && \
    dnf install -y $(cat extra-packages)

RUN rm /extra-packages


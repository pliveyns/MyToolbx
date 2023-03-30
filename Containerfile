FROM registry.fedoraproject.org/fedora-toolbox:37

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox command" \
      summary="A cloud-native terminal experience" \
      maintainer="peter.liveyns@gmail.com>"

COPY recipe.yml /etc/toolbx-recipe.yml

COPY --from=docker.io/mikefarah/yq /usr/bin/yq /usr/bin/yq

#RUN dnf upgrade -y && \
#    dnf install -y $(cat extra-packages)

RUN echo "--- Installing DNF packages defined in recipe.yml --" && \
    dnf_packages=$(yq '.dnf[]' < /etc/toolbx-recipe.yml) && \
    for pkg in $dnf_packages; do \
        echo "Installing: ${pkg}" && \
        dnf install -y $pkg; \
    done && \
    echo "---" && \
    echo "--- Installing RPM packages from url defined in recipe.yml --" && \
    rpm_urls=$(yq '.rpm[]' < /etc/toolbox-recipe.yml) && \
    for pkg in $rpm_urls; do \
        echo "Installing: ${pkg}" && \
        dnf install -y $pkg; \
    done && \
    echo "---"

RUN rm /etc/toolbx-recipe.yml


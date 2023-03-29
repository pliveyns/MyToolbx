FROM registry.fedoraproject.org/fedora-toolbox:37

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox command" \
      summary="A cloud-native terminal experience" \
      maintainer="peter.liveyns@gmail.com>"

COPY recipe.yml /etc/toolbx-recipe.yml

COPY --from=docker.io/mikefarah/yq /usr/bin/yq /usr/bin/yq

#RUN dnf upgrade -y && \
#    dnf install -y $(cat extra-packages)

RUN echo "--- Installing RPMs defined in recipe.yml --" && \
    rpm_pakages=$(yq '.rpms[]' < /etc/toolbx-recipe.yml) && \
    for pkg in $rpm_packages; do \
        echo "Installing: ${pkg}" && \
        dnf install -y $pkg; \
    done && \
    echo "---"

RUN rm /etc/toolbox-recipe.yml


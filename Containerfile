FROM registry.fedoraproject.org/fedora-toolbox:37

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox command" \
      summary="A cloud-native terminal experience; besed on Jorge Catro's boxkit" \
      maintainer="peter.liveyns@gmail.com>"

COPY recipe.yml /etc/toolbx-recipe.yml

COPY --from=docker.io/mikefarah/yq /usr/bin/yq /usr/bin/yq

RUN echo "--- Installing DNF packages defined in recipe.yml --" && \
    dnf_packages=$(yq '.dnf[]' < /etc/toolbx-recipe.yml) && \
    for pkg in $dnf_packages; do \
        echo "Installing: ${pkg}" && \
        dnf install -y $pkg; \
    done && \
    echo "---" && \
    \
    echo "--- Installing RPM packages from url defined in recipe.yml --" && \
    rpm_urls=$(yq '.rpm[]' < /etc/toolbx-recipe.yml | sed -e "s/: /\&/") && \
    for pkg in $rpm_urls; do \
        bin=$(echo $pkg | cut -d'&' -f1 -); \
        url=$(echo $pkg | cut -d'&' -f2 -); \
        echo "Installing: ${bin}" && \
        dnf install -y $url; \
    done && \
    echo "---" && \
    \
    echo "--- Installing binary packages from tar download in recipe.yml --" && \
    tar_packages=$(yq '.tar[]' < /etc/toolbx-recipe.yml | sed -e "s/: /\&/") && \
    for pkg in $tar_packages; do \
      bin=$(echo $pkg | cut -d'&' -f1 -); \
      url=$(echo $pkg | cut -d'&' -f2 -); \
      echo "Installing: ${bin}" && \
      cd /usr/local/bin/; \
      curl $url; \
      tar xvf /usr/local/bin/$bin*; \
      chmod +x /usr/local/bin/$bin; \
      cd /; \
    done && \
    echo "---" && \
    \
    echo "--- Installing binary packages from download link in recipe.yml --" && \
    binary_packages=$(yq '.binary[]' < /etc/toolbx-recipe.yml | sed -e "s/: /\&/") && \
    for pkg in $binary_packages; do \
      bin=$(echo $pkg | cut -d'&' -f1 -); \
      url=$(echo $pkg | cut -d'&' -f2 -); \
      echo "Installing: ${bin}" && \
      curl -L $url -o /usr/local/bin/$bin; \
      chmod +x /usr/local/bin/$bin; \
      #cd /; \
    done && \
    echo "---"

RUN rm /etc/toolbx-recipe.yml

RUN   ln -fs /bin/sh /usr/bin/sh && \
      ln -fs /usr/local/bin/host-spawn /usr/local/bin/toolbox && \
      ln -fs /usr/local/bin/host-spawn /usr/local/bin/flatpak && \ 
      ln -fs /usr/local/bin/host-spawn /usr/local/bin/podman && \
      ln -fs /usr/local/bin/host-spawn /usr/local/bin/rpm-ostree && \
      ln -fs /usr/local/bin/host-spawn /usr/local/bin/distrobox


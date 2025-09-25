# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
FROM ghcr.io/ublue-os/ucore-hci:stable

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.


COPY system_files /

WORKDIR /tmp

RUN git clone https://github.com/automorphism88/snapraid-btrfs.git && ls -la snapraid-btrfs/snapraid-btrfs && ls -la /usr/local && cp snapraid-btrfs/snapraid-btrfs /usr/bin/snapraid-btrfs

#RUN git clone https://github.com/45drives/cockpit-zfs-manager.git && cp -r cockpit-zfs-manager/zfs /usr/share/cockpit
#RUN sudo dnf5 install -y https://github.com/45Drives/cockpit-file-sharing/releases/download/v4.2.12/cockpit-file-sharing-4.2.12-1.el8.noarch.rpm \
#    && dnf5 clean all
#RUN sudo dnf5 install -y https://github.com/45Drives/cockpit-benchmark/releases/download/v2.1.1/cockpit-benchmark-2.1.1-1.el8.noarch.rpm \
#    && dnf5 clean all

ENV SOPS_VERSION="v3.10.2"
ARG SOPS_FILENAME="sops-${SOPS_VERSION}.linux.amd64"
RUN set -x && \
    curl --retry 5 --retry-connrefused -LO "https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/${SOPS_FILENAME}" && \
    chmod +x "${SOPS_FILENAME}" && \
    mv "${SOPS_FILENAME}" /usr/local/bin/sops && \
    sops --version --disable-version-check | grep -E "^sops ${SOPS_VERSION#v}"

ENV AGE_VERSION="v1.2.1"
ARG AGE_FILENAME="age-${AGE_VERSION}-linux-amd64.tar.gz"
RUN set -x && \
    curl --retry 5 --retry-connrefused -LO "https://github.com/FiloSottile/age/releases/download/${AGE_VERSION}/${AGE_FILENAME}" && \
    tar xvf "${AGE_FILENAME}" -C /usr/local/bin --strip-components 1 age/age age/age-keygen && \
    rm "${AGE_FILENAME}" && \
    [ "$(age --version)" = "${AGE_VERSION}" ] && \
    [ "$(age-keygen --version)" = "${AGE_VERSION}" ]

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    /ctx/cleanup.sh

#!/bin/bash

set -ouex pipefail

#systemctl enable podman.socket
# swap nfs-utils-coreos for full nfs-utils
dnf -y swap nfs-utils-coreos nfs-utils

# install packages
dnf -y install \
    tmux \
    ansible \
    snapper \
    powertop \
    yq \
    zip \
    unzip \
    htop \
    intel_gpu_top \
    cockpit-storaged \
    duperemove \
    hdparm \
    man-db \
    pciutils \
    pcp-zeroconf \
    rclone \
    samba \
    samba-usershares \
    sanoid \
    smartctl \
    snapraid \
    usbutils \
    xdg-dbus-proxy \
    xdg-user-dirs \
    cockpit-machines \
    libvirt-client \
    libvirt-daemon-kvm \
    ublue-os-libvirt-workarounds \
    virt-install

# install packages direct from github
#if [[ "${RELEASE}" -ge "43" ]]; then
#  /ctx/github-release-install.sh trapexit/mergerfs "fc${RELEASE}.${ARCH}"
  /ctx/github-release-install.sh trapexit/mergerfs "fc43.x86_64"


#elif [[ "${ARCH}" == "x86_64" ]]; then
#  # before F43, mergerfs only available for x86_64
#  /ctx/github-release-install.sh trapexit/mergerfs "fc${RELEASE}.x86_64"
#fi

# cockpit plugin for ZFS management
curl --fail --retry 15 --retry-all-errors -sSL -o /tmp/cockpit-zfs-manager-api.json \
    "https://api.github.com/repos/45Drives/cockpit-zfs-manager/releases/latest"
CZM_TGZ_URL=$(jq -r .tarball_url /tmp/cockpit-zfs-manager-api.json)
curl --fail --retry 15 --retry-all-errors -sSL -o /tmp/cockpit-zfs-manager.tar.gz "${CZM_TGZ_URL}"

mkdir -p /tmp/cockpit-zfs-manager
tar -zxvf /tmp/cockpit-zfs-manager.tar.gz -C /tmp/cockpit-zfs-manager --strip-components=1
mv /tmp/cockpit-zfs-manager/polkit-1/actions/* /usr/share/polkit-1/actions/
mv /tmp/cockpit-zfs-manager/polkit-1/rules.d/* /usr/share/polkit-1/rules.d/
mv /tmp/cockpit-zfs-manager/zfs /usr/share/cockpit

curl --fail --retry 15 --retry-all-errors -sSL -o /tmp/cockpit-zfs-manager-font-fix.sh \
    https://raw.githubusercontent.com/45Drives/scripts/refs/heads/main/cockpit_font_fix/fix-cockpit.sh
chmod +x /tmp/cockpit-zfs-manager-font-fix.sh
/tmp/cockpit-zfs-manager-font-fix.sh

rm -rf /tmp/cockpit-zfs-manager*

#systemctl enable ucore-root-ssh-fix.service

# tweak os-release
sed -i '/^PRETTY_NAME/s/(uCore.*$/(uCore MOD)"/' /usr/lib/os-release
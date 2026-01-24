#!/usr/bin/bash
set -euo pipefail

trap '[[ $BASH_COMMAND != echo* ]] && [[ $BASH_COMMAND != log* ]] && echo "+ $BASH_COMMAND"' DEBUG

log() {
  echo "=== $* ==="
}

log "Starting system cleanup"

# Remove Ignition and Cloud-Init Support
#dnf -y remove \
#    zincati \
#    ignition \
#    ignition-edge \
#    cloud-init \
#    coreos-installer

# Remove Ignition and Cloud-Init Support
dnf -y remove \
    docker-buildx \
    docker-compose \
    toolbox

# Clean package manager cache
dnf5 clean all


# Clean boot files
find /boot/ -maxdepth 1 -mindepth 1 -exec rm -fr {} \; || true

# Clean temporary files
find /tmp/* -maxdepth 0 -type d \! -name rpms -exec rm -fr {} \; || true

# Clean /var directory while preserving essential files
find /var/* -maxdepth 0 -type d \! -name cache -exec rm -fr {} \;
find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 \! -name rpm-ostree -exec rm -fr {} \;

# Commit and lint container
# this currently fails on /usr/etc and /var/cache
#bootc container lint
ostree container commit

# Restore and setup directories
mkdir -p /var/tmp \
&& chmod -R 1777 /var/tmp

log "Cleanup completed"


# Installing uCore on Bare Metal

This guide provides instructions to install uBlueOS uCore to bare metal. 

## Prerequisite

Before installing uCore, you must have an Ignition configuration file. 

To convert a Butane file to an Ignition file use:

`podman run --interactive --rm quay.io/coreos/butane:release --pretty --strict < ucore.butane > ucore_config.ign`

## Installation

uCore does not provide an installer; it extends Fedora CoreOS.

### Live Install

Download the latest ISO image from the [download page](https://fedoraproject.org/coreos/download/?stream=stable#baremetal) or with podman.

`podman run --security-opt label=disable --pull=always --rm -v .:/data -w /data quay.io/coreos/coreos-installer:release download -s stable -p metal -f iso`

Once booted into the live iso use:

`sudo coreos-installer install /dev/nvme0n1 --ignition-url https://example.com/ucore_config.ign`

or

`sudo coreos-installer install /dev/nvme0n1 --ignition-file /path/to/ucore_config.ign`

### Auto Deploy ISO
> [!WARNING]
> **Boot media will automatically install to drive without confirmation.**
> There are no prompts or user input! Use with caution.


Download the latest ISO image from the [download page](https://fedoraproject.org/coreos/download/?stream=stable#baremetal) or with podman.

`podman run --security-opt label=disable --pull=always --rm -v .:/data -w /data quay.io/coreos/coreos-installer:release download -s stable -p metal -f iso`

Then inject the ignition file into the iso

`podman run --security-opt label=disable --rm -v .:/data -w /data quay.io/coreos/coreos-installer:release iso customize --dest-device /dev/nvme0n1 --dest-ignition ucore_config.ign -o custom.iso downloaded.iso`

## Other

See coreOS [Docs](https://docs.fedoraproject.org/en-US/fedora-coreos/bare-metal/) for more options or [uCore github](https://github.com/ublue-os/ucore)
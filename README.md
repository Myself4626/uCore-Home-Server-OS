# uCore Home Server OS (uHS-OS)
[![uCore Base](https://img.shields.io/badge/Base-uCore-orange)](https://github.com/ublue-os/ucore)
[![Build Status](https://img.shields.io/badge/Build-bootc-green)](#)
[![Build Status](https://github.com/Myself4626/uCore-Home-Server-OS/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/Myself4626/uCore-Home-Server-OS/actions/workflows/build.yml)

> ⚠️ **Warning:** Early stage. Features may change or be missing. Backups recommended.

---

**uHS-OS** is an immutable uBlue-uCore home server OS. It follows a container-first model aligned with [PerfectMediaServer](https://perfectmediaserver.com/) principles. The goal is to keep the host minimal, updates atomic, and services reproducible.

---

## Key features:
- **Immutable base** — atomic updates and instant rollbacks via `bootc`.
- **Standard tooling** — Podman, systemd, and Ansible. No proprietary daemons or custom web frameworks.
- **Container-first** — services run as OCI containers via systemd quadlets.
- **Self-documenting configuration** — your configuration lives in an Ansible repo.
- **Flexible storage** — Mix and match to fit your data needs. Btrfs, MergerFS, SnapRAID, and ZFS.
- **Web & CLI management** — Cockpit for quick tasks, Ansible for full automation.
- **Hardware-friendly** — runs great on second-hand business desktops or servers.

---

## Example Uses:

- NAS with support for bulk, parity-protected storage for files and backups.
- A small compute node for self-hosted apps (Nextcloud, Immich, Paperless, etc.).
- Media servers (Plex, Jellyfin, or Emby).

---

## Getting Started:

1. Install **uCore** on your hardware.
2. Switch to this image
3. Clone the [uCore Home Server](https://github.com/Myself4626/uCore-Home-Server) repository.
4. Configure your server via Ansible.
5. Access Cockpit to monitor and manage.

> Detailed installation guides are available in the [Wiki](./wiki).

---

## Contribute:

Got an idea for a service, role, or improvement?  
Open an issue or submit a PR — contributions are welcome!

---

## Links:
- **uCore (base image):** https://github.com/ublue-os/ucore  
- **bootc switch / image mode:** Red Hat docs for `bootc` (RHEL 9/10)  
- **Podman Quadlet & systemd generator:** `podman-systemd.unit(5)`, `podman-quadlet(1)`  
- **PerfectMediaServer overview:** https://perfectmediaserver.com/

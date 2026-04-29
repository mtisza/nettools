# nettools

A Docker container image packed with common network diagnostic and utility tools. Runs as a non-root user (`ubuntu`) with passwordless sudo for tools that require elevated privileges (e.g. `tcpdump`, `iftop`, `nmap`).

## Included tools

| Category | Tools |
|---|---|
| Routing / interfaces | `iproute2`, `net-tools`, `bridge-utils`, `ethtool` |
| DNS | `dnsutils` (dig, nslookup), `whois` |
| Connectivity | `iputils-ping`, `traceroute`, `curl`, `wget`, `telnet` |
| Scanning | `nmap`, `netcat-openbsd` |
| SSH | `openssh-client`, `sshpass` |
| Bandwidth / perf | `iftop`, `iperf3` |
| Capture | `tcpdump` |
| Discovery | `lldpd` |
| RDMA / InfiniBand | `rdma-core`, `ibverbs-utils` (ibv_devinfo, ibv_rc_pingpong), `infiniband-diags` (ibstat, ibping, ibroute), `perftest` (ib_send_bw, ib_read_lat, …) |
| Shell / scripting | `tmux`, `vim`, `nano`, `jq`, `bc`, `python3`, `sqlite3`, `htop` |

## Quick start

```bash
# Pull and run interactively
docker run -it --rm mtisza/nettools:latest

# Run a one-off command
docker run --rm mtisza/nettools:latest ping -c 4 8.8.8.8

# Host networking (required for some tools like iftop, tcpdump)
docker run -it --rm --net=host --cap-add=NET_ADMIN --cap-add=NET_RAW mtisza/nettools:latest
```

The container starts a shell as the `ubuntu` user. Tools that need root (e.g. `tcpdump`, `iftop`) work via passwordless sudo:

```bash
sudo tcpdump -i eth0
sudo iftop
```

## Building

Requires Docker with [buildx](https://docs.docker.com/buildx/working-with-buildx/) enabled.

```bash
# Build and push multi-platform image (amd64 + arm64), tagged with git commit hash
make build

# Promote the current git hash tag to :latest
make release

# Build for local testing only (native platform, loaded into local Docker daemon)
make build-local
```

## License

[MIT](LICENSE)

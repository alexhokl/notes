- [Links](#links)
- [NAS](#nas)
  * [QNAP NAS](#qnap-nas)
- [CLI](#cli)
  * [To show routes of Tailscale](#to-show-routes-of-tailscale)
  * [To enable subnet routes on other nodes on Linux](#to-enable-subnet-routes-on-other-nodes-on-linux)
  * [To show login URL as QR code](#to-show-login-url-as-qr-code)
  * [To copy files to another device](#to-copy-files-to-another-device)
  * [To setup a server within Tailscale network](#to-setup-a-server-within-tailscale-network)
  * [To setup a server publicly (via Tailscale Funnel)](#to-setup-a-server-publicly-via-tailscale-funnel)
- [Taildrop (file)](#taildrop-file)
- [Google Cloud Platform (GCP)](#google-cloud-platform-gcp)
  * [To start and share DNS names between GCP and Tailnet](#to-start-and-share-dns-names-between-gcp-and-tailnet)
- [Windows](#windows)
- [Docker](#docker)
- [Funnel](#funnel)
- [Public DNS name for tailnet](#public-dns-name-for-tailnet)
____

## Links

- [The long wondrous life of a Tailscale packet](https://tailscale.com/blog/2021-05-life-of-a-packet/)
- [Using GitHub Actions and Tailscale to build and deploy applications
  securely](https://tailscale.com/blog/2021-05-github-actions-and-tailscale/?utm_source=Tailscale+Newsletter&utm_campaign=37cbc3fd5e-EMAIL_CAMPAIGN_2020_10_06_12_18_COPY_01&utm_medium=email&utm_term=0_0b42c45af3-37cbc3fd5e-434266695)
- [Subnet routes and relay nodes](https://tailscale.com/kb/1019/subnets/)
- [How do I enable IP
  forwarding?](https://tailscale.com/kb/1104/enable-ip-forwarding/)
- [Exit Nodes](https://tailscale.com/kb/1103/exit-nodes/)
- [Tailscale CLI](https://tailscale.com/kb/1080/cli/)
- [Provision TLS certificates for your internal Tailscale
  services](https://tailscale.com/blog/tls-certs/)
- [Remote reboots with encrypted
  disks](https://tavianator.com/2022/remote_reboots.html)
- [Quickly switch between Tailscale
  accounts](https://tailscale.com/blog/fast-user-switching/)
- [Virtual private services with
  tsnet](https://tailscale.com/blog/tsnet-virtual-private-services/)
- [Integrations](https://tailscale.com/integrations/)
- [Kubernetes Operator](https://tailscale.com/kb/1236/kubernetes-operator)
- [Easy Guide to Exposing a Kubernetes Service with
  Tailscale](https://www.youtube.com/watch?v=INdZOBnUBl4)

## NAS

### QNAP NAS

- [Access QNAP NAS from anywhere](https://tailscale.com/kb/1273/qnap/#supported-qnap-hardware)
- [ivokub/tailscale-qpkg](https://github.com/ivokub/tailscale-qpkg/blob/master/Makefile)
  - use `./tailscale -socket var/run/tailscale/tailscaled.sock` to learn about
    all possible commands
- path to executable `/share/CACHEDEV1_DATA/.qpkg/Tailscale/tailscale`

## CLI

### To show routes of Tailscale

```sh
ip route show table 52
```

or, on Windows,

```cmd
route print
```

### To enable subnet routes on other nodes on Linux

```sh
sudo tailscale up --accept-routes
```

### To show login URL as QR code

```sh
sudo tailscale up --qr
```

### To copy files to another device

```sh
tailscale file cp some_file 100.333.333.333:
```

### To setup a server within Tailscale network

```sh
tailscale serve 5000
```

where this will setup a server at port `5000` with HTTPS on.

### To setup a server publicly (via Tailscale Funnel)

```sh
tailscale funnel 5000
```

where this will setup a server at port `5000` with HTTPS on.

## Taildrop (file)

- it does not work with tagged devices as tagged devices are considered userless
  and are meant to be used for shared services

> Taildrop permits you to share files between devices that you are logged in to,
> even if ACLs are used to restrict access to the devices. You cannot use
> Taildrop to send files to and from nodes you have tagged.

## Google Cloud Platform (GCP)

### To start and share DNS names between GCP and Tailnet

```sh
tailscale up --advertise-routes=10.182.0.0/24,169.254.169.254/32 --accept-dns=false
```

where `10.182.0.0/24` is the subnet to be enabled with subnet routing,
`169.254.169.254/32` is the DNS service on GCP (and likely on AWS and Azure as
well), `--accept-dns=false` is to ensure the VM keep using GCP DNS names.

Reference: [Access Google Compute Engine VMs privately using Tailscale
](https://tailscale.com/kb/1147/cloud-gce/)

## Windows

The following options should be checked in `Preferences` menu.

- Allow incoming connection
- Use network DNS settings
- Use network subnets
- Run unattended

## Docker

The Docker extension does not assign an IP address to each container but it
exposes the public port to the host which has on tailnet already.

## Funnel

- use cases
  * a webhook invoked by a public service
  * briefly test a website a mobile device
  * to host your personal blog or a small Mastodon server on your own computer
- MagicDNS
  * Tailscale provides a DNS name and supports a Tailscale node getting its
    own Let’s Encrypt cert for that DNS name, but the Tailscale IP addresses
    are not publicly routable
- Tailscale Funnel is all off by default and double opt-in
  * enabled in the Tailscale admin console, and
  * enabled on the device
- how does it work
  * set up public DNS records for a `node.tailnet.ts.net` MagicDNS name to
    point to public IP addresses of new servers Tailscale is now running
  * add those Funnel ingress nodes to tailnet’s list of Tailscale peers
  * When somebody goes to `node.tailnet.ts.net` in their browser, a traditional
    DNS response then points to one of Tailscale's funnel VMs, ideally in
    a region near the node. The VM then proxy those encrypted TCP connections to
    the Tailscale node over Tailscale itself. SNI name is verified at the Funnel
    VM but TLS is not terminated there.

## Public DNS name for tailnet

Assuming the ownership of the following domains.

- `a-b.ts.net`
- `testing.com`

We can expose a service in tailnet with a public DNS name without exposing the
service to the public internet.

To do so, setup a DNS `CNAME` record maps `*.testing.com` to
`proxy.a-b.ts.net`. Setup a reverse proxy on `proxy.a-b.ts.net` to forward
requests to any services in tailnet. The following assumes `Caddy` is being used
as the reverse proxy.

```caddyfile
(clouddns) {
  tls {
    dns googleclouddns {
      gcp_project {$GCP_PROJECT_ID}
    }
  }
}

service1.testing.com {
  reverse_proxy http://10.42.0.42
  import clouddns
}

service2.testing.com {
  reverse_proxy http://internet-ts-name
  import clouddns
}
```

- [NAS](#nas)
  * [Installation of Tailscale on QNAP NAS](#installation-of-tailscale-on-qnap-nas)
- [CLI](#cli)
  * [To show routes of Tailscale](#to-show-routes-of-tailscale)
  * [To enable subnet routes on other nodes on Linux](#to-enable-subnet-routes-on-other-nodes-on-linux)
  * [To show login URL as QR code](#to-show-login-url-as-qr-code)
  * [To copy files to another device](#to-copy-files-to-another-device)
- [Google Cloud Platform (GCP)](#google-cloud-platform-gcp)
  * [To start and share DNS names between GCP and Tailnet](#to-start-and-share-dns-names-between-gcp-and-tailnet)
- [Windows](#windows)
- [Links](#links)
____

## NAS

### Installation of Tailscale on QNAP NAS

- [ivokub/tailscale-qpkg](https://github.com/ivokub/tailscale-qpkg/blob/master/Makefile)
  - use `./tailscale -socket var/run/tailscale/tailscaled.sock` to learn about
    all possible commands

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

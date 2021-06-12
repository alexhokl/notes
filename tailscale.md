  * [Installation of Tailescale on QNAP NAS](#installation-of-tailescale-on-qnap-nas)
  * [To show routes of Tailscale](#to-show-routes-of-tailscale)
- [Links](#links)
____
### Installation of Tailescale on QNAP NAS

- [ivokub/tailscale-qpkg](https://github.com/ivokub/tailscale-qpkg/blob/master/Makefile)
  - use `./tailscale -socket var/run/tailscale/tailscaled.sock` to learn about
    all possible commands

### To show routes of Tailscale

```sh
ip route show table 52
```

## Links

- [The long wondrous life of a Tailscale packet](https://tailscale.com/blog/2021-05-life-of-a-packet/)
- [Using GitHub Actions and Tailscale to build and deploy applications
  securely](https://tailscale.com/blog/2021-05-github-actions-and-tailscale/?utm_source=Tailscale+Newsletter&utm_campaign=37cbc3fd5e-EMAIL_CAMPAIGN_2020_10_06_12_18_COPY_01&utm_medium=email&utm_term=0_0b42c45af3-37cbc3fd5e-434266695)


- [Concepts](#concepts)
  * [Functionalities](#functionalities)
- [Types](#types)
  * [OpenVPN](#openvpn)
    + [Troubleshooting](#troubleshooting)
- [Services](#services)
  * [Countries can enforce data sharing with government agencies](#countries-can-enforce-data-sharing-with-government-agencies)
____

# Concepts

## Functionalities

- hiding IP address of client
  * this can be checked by
    + `curl -4 l2.io/ip`
- hidling IPv6 address
  * An IPv6 leak occurs when a VPN app successfully intercepts your IPv4
    connection and routes it through the VPN server but doesn’t account for
    potential IPv6 connections. It therefore allows connections over IPv6,
    exposing the real IPv6 addresses of anyone using an ISP that supports IPv6
    to IPv6-capable websites.
  * this can be checked by
    + `curl -4 icanhazip.com`
    + `curl -6 icanhazip.com`
- hiding DNS queries
  * this can be checked by [dnsleaktest.com](https://www.dnsleaktest.com/)
  * note that configuring DNS server to use `1.1.1.1` (Cloudflare) or similar
    does not hide DNS queries
  * if VPN is not being used, encrypted DNS service can be used to hide DNS
    queries
- hiding IP address in WebRTC traffic
  * this can be checked by [browserleaks.com](https://browserleaks.com/webrtc)

# Types

## OpenVPN

### Troubleshooting

##### OpenVPN Connect client on Windows cannot be started

- Press <kbd>Win</kbd><kbd>R</kbd> and enter in `%TEMP%`.
- Remove `.ovpn-connect-lockfile`.

# Services

## Countries can enforce data sharing with government agencies

- Australia
- Canada
- New Zealand
- United Kingdom
- United States

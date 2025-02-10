- [Links](#links)
- [Domain transfer](#domain-transfer)
____

# Links

- [ICANN Lookup](https://lookup.icann.org/lookup)
- [Transfer Domain Ownership: A Step-by-Step Guide](https://hover.blog/how-to-transfer-ownership-of-a-domain-name/)
- [Transfer my domain to GoDaddy](https://hk.godaddy.com/en/help/transfer-my-domain-to-godaddy-1592)
- [Add a DS Record
  GoDaddy](https://hk.godaddy.com/en/help/add-a-ds-record-23865) - To enable
  DNSSEC using 3rd party name server (such as Google Cloud DNS)
- [domain check from zeit](https://zeit.co/domains)
- [crt.sh](https://crt.sh/) - list of issued Let's Encrypt
  certificates
- [Free Monitor Certificate expiry via
  RSS](https://raphting.dev/posts/monitor-rss/)
- [mess with dns](https://messwithdns.net/) - a site for experimenting DNS setup
- [badssl.com](https://badssl.com/) - for manual testing of security UI in web
  clients. It provides links to check various possible errors.
- [hover](https://www.hover.com/) - domain registrar

# Domain transfer

The first step is to get an authorization code (EPP or transfer key) from the
original registrar. With the code, a transfer can be started by adding the
domain to the destination registrar. It usually takes a few days to complete and
the name server (`NS`) setting will be kept.

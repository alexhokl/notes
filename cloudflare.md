- [Basics](#basics)
  * [To verify API token](#to-verify-api-token)
  * [To list zones](#to-list-zones)
- [DNS](#dns)
  * [To list DNS records of a zone](#to-list-dns-records-of-a-zone)
  * [To show a DNS record](#to-show-a-dns-record)
  * [To create a DNS A record](#to-create-a-dns-a-record)
  * [To delete a DNS record](#to-delete-a-dns-record)
  * [To update IP address of a DNS A record](#to-update-ip-address-of-a-dns-a-record)
____

## Basics

### To verify API token

```sh
xh -b -A bearer -a $TOKEN https://api.cloudflare.com/client/v4/user/tokens/verify
```

### To list zones

```sh
xh -b -A bearer -a $TOKEN https://api.cloudflare.com/client/v4/zones
```

## DNS

### To list DNS records of a zone

```sh
ZONE_ID=$(xh -b -A bearer -a $TOKEN https://api.cloudflare.com/client/v4/zones | jq -r .result[0].id)
xh -b -A bearer -a $TOKEN https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records
```

### To show a DNS record

```sh
ZONE_ID=$(xh -b -A bearer -a $TOKEN https://api.cloudflare.com/client/v4/zones | jq -r .result[0].id)
xh -b -A bearer -a $TOKEN https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records | jq '.result[] | select(.name=="custom.testing.com")'
```

### To create a DNS A record

```sh
ZONE_ID=$(xh -b -A bearer -a $TOKEN https://api.cloudflare.com/client/v4/zones | jq -r .result[0].id)
xh -A bearer -a $TOKEN post https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records type=A name=custom.testing.com content=300.300.300.300 ttl:=3600 priority:=10 proxied:=false
```

### To delete a DNS record

```sh
ZONE_ID=$(xh -b -A bearer -a $TOKEN https://api.cloudflare.com/client/v4/zones | jq -r .result[0].id)
DNS_RECORD_ID=$(xh -b -A bearer -a $TOKEN https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records | jq -r '.result[] | select(.name=="custom.testing.com") | .id')
xh -A bearer -a $TOKEN delete https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_RECORD_ID
```

### To update IP address of a DNS A record

```sh
ZONE_ID=$(xh -b -A bearer -a $TOKEN https://api.cloudflare.com/client/v4/zones | jq -r .result[0].id)
DNS_RECORD_ID=$(xh -b -A bearer -a $TOKEN https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records | jq -r '.result[] | select(.name=="custom.testing.com") | .id')
xh -A bearer -a $TOKEN patch https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_RECORD_ID content=300.300.300.300
```


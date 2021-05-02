
____
#### To check the IP addresses of a domain

```sh
nslookup alexho.dev
```

or

```sh
nslookup -q=a alexho.dev
```

#### To check MX records of a domain

```sh
nslookup -q=mx alexho.dev
```

#### To check SOA records of a domain

```sh
nslookup -q=soa alexho.dev
```

#### To check NS records of a domain

```sh
nslookup -q=ns alexho.dev
```

#### To check TXT records of a domain

```sh
nslookup -q=txt alexho.dev
```

#### To check DMARC record of a domain

```sh
nslookup -q=txt _dmarc.alexho.dev
```

##### To lookup using a specific DNS server

```sh
nslookup -q=ns alexho.dev 8.8.8.8
```


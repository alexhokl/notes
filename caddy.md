- [Setup using Tailscale](#setup-using-tailscale)
- [Dynamic reverse proxy](#dynamic-reverse-proxy)
____

## Setup using Tailscale

Caddy automatically recognizes and uses certificates for your Tailscale network
(`*.ts.net`), and can use Tailscale’s HTTPS certificate provisioning when
spinning up a new service.

To serve files on a machine,

```Caddyfile
machine-name.domain-alias.ts.net

root * ./public
file_server
```

To proxy a port on a machine,

```Caddyfile
machine-name.domain-alias.ts.net

reverse_proxy :1313
```

## Dynamic reverse proxy

Reference: [Reverse proxy with dynamic backend
selection](https://www.artur-rodrigues.com/tech/2023/03/12/reverse-proxy-with-dynamic-backend-selection.html)
by Artur Rodrigues

This solution stores host-to-backend mapping in Redis.

Some of the code of [Caddy module](https://caddyserver.com/docs/extending-caddy)

```go
func (m JWTShardRouter) ServeHTTP(w http.ResponseWriter, r *http.Request, next caddyhttp.Handler) error {
    authHeader := r.Header.Get("Authorization")
    tokenStr := strings.TrimPrefix(authHeader, "Bearer ")

    claims := ParseJWT(tokenStr)
    customer, _ := claims["customer"].(string)
    r.Header.Set("X-Customer", customer)

    shard, _ := rdb.Get(ctx, customer).Result()
    caddyhttp.SetVar(r.Context(), "shard.upstream", shard)

    return next.ServeHTTP(w, r)
}
```

Caddyfile

```Caddyfile
{
    order jwt_shard_router before method
}

http://localhost:5000 {
    jwt_shard_router
    reverse_proxy {
        to {http.vars.shard.upstream}
    }
}
```

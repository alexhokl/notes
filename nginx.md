- [Links](#links)
- [Commands](#commands)
- [Contexts](#contexts)
____

### Links

- [Understanding the Nginx Configuration File Structure and Configuration Contexts](https://www.digitalocean.com/community/tutorials/understanding-the-nginx-configuration-file-structure-and-configuration-contexts)
- [digitalocean/nginxconfig.io](https://nginxconfig.io/) - an Nginx
  configuration generator
- [playground from Julia Evans](https://nginx-playground.wizardzines.com/)

### Commands

##### To reload configuration on-the-fly

```sh
nginx -s reload
```

### Contexts

The following contexts can be used in a Nginx configuration file.

- `stream` - describes TCP/UDP traffic
- `events` - describes general connection
- `http` - describes HTTP traffic
  - `server` - control requests of a virtual server
    - `location` - defines an endpoint

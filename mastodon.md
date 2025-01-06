- [Mastodon](#mastodon)
  * [Links](#links)
  * [madonctl](#madonctl)
  * [Features](#features)
___

# Mastodon

## Links

- [McKael/madonctl](https://github.com/McKael/madonctl) - a CLI tool to interact
  with Mastodon

## madonctl

##### To login

```sh
mkdir -p ~/.config/madonctl
madonctl -i hachyderm.io oauth2 > $HOME/.config/madonctl/madonctl.yaml
```

##### To show home timeline

```sh
madonctl timeline --limit 2
```

##### To create a new toot

```sh
madonctl toot "Hello, World!"
```

## Features

##### RSS fees

- URL pattern `https://instance/@username.rss`

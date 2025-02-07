# XRAY VLESS Websocket on Docker + Cloudflared

## Github Actions Secrets

![Github Repository Secrets List](https://i.imgur.com/gyOBD6X.png)

**Settings Path** : *Github Repository* > *Settings* > *Secrets and Variables* > *Actions*

`DOCKER_HUB_USERNAME` : Use this when you want to create private docker repos

`DOCKER_HUB_PASSWORD` : Use this when you want to create private docker repos

`PERSONAL_ACCESS_TOKEN` : Use this when you want a private github workflow

`PRIVATE_UUID` : Use this when you want a private UUID for VLESS authentication. [*optional*] | *default*: `730b6e0c-e463-11ef-a734-b36930036fe6`

`TUNNEL_TOKEN` : Put your Cloudflared Tunnel Token here to bind it. [*required*]

## Get Cloudflared Tunnel Token

![Cloudflared Tunnel Token](https://i.imgur.com/lKRX4jz.png)

Copy syntax and take the part of the text
```bash
>... run --token eyJhIjoiNDZkYTFhZTYwNDM1ZjFhODk2YjIwNjUwMjA0NGRlNmIiLCJ0IjoiMmQxZDFhODktNjc2Yy00MjQ4LTkwMmUtZjYxZmFjYTg2ZGUwIiwicyI6Ik5tVXdaRFF3TnpJdE5HTmlOaTAwTm1NM0xXRXpaR1F0xxxxxxxxxxxxxxxxxxxxxxxx
```

Your tunnel token is
```text
eyJhIjoiNDZkYTFhZTYwNDM1ZjFhODk2YjIwNjUwMjA0NGRlNmIiLCJ0IjoiMmQxZDFhODktNjc2Yy00MjQ4LTkwMmUtZjYxZmFjYTg2ZGUwIiwicyI6Ik5tVXdaRFF3TnpJdE5HTmlOaTAwTm1NM0xXRXpaR1F0xxxxxxxxxxxxxxxxxxxxxxxx
```


## Docker Compose

```bash
# .env
TUNNEL_TOKEN=<YOUR_TUNNEL_TOKEN> # required
PRIVATE_UUID=<YOUR_PRIVATE_UUID> # optional (default: 730b6e0c-e463-11ef-a734-b36930036fe6)
```

```yaml
# docker-compose.yaml
version: "3.2"

services:
  cfd:
    image: cloudflare/cloudflared:latest
    env_file:
      - .env
    command: tunnel --no-autoupdate run --token ${TUNNEL_TOKEN}
  vless:
    image: gegedesembri/xray-vless:latest
```

## VLESS Default Settings

```json
{
  "listen": "0.0.0.0",
  "port": "80",
  "protocol": "vless",
  "tag": "vless-ws",
  "settings": {
    "decryption": "none",
    "clients": [
      {
	    "id": "730b6e0c-e463-11ef-a734-b36930036fe6",
	    "level": 0,
	    "alterId": 0,
	    "email": "vless.ws@xray.docker"
      }
    ]
  },
  "streamSettings": {
    "network": "ws",
    "security": "none",
    "wsSettings": {
      "path": "/vless"
    }
  }
}
```

## Cloudflared Hostname Setting

Hostname : `subdomain.domain.com`

Redirect Service : `http://vless:80`

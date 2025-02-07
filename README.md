# XRAY VLESS Websocker on Docker + Cloudflared

## Docker Compose

```yaml
version: "3.2"

services:
  cfd:
    image: cloudflare/cloudflared:latest
    command: tunnel --no-autoupdate run --token TUNNEL_TOKEN
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

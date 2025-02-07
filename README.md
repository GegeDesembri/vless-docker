# XRAY VLESS Websocket on Docker + Cloudflared

## Docker Compose

```bash
# .env
TUNNEL_TOKEN=YOUR_TUNNEL_TOKEN #required
PRIVATE_UUID=YOUR_PRIVATE_UUID #optional (default: 730b6e0c-e463-11ef-a734-b36930036fe6)
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

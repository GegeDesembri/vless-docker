# XRAY VLESS Websocket on Docker + Cloudflared

## Required 

1. Domain parked on Cloudflare
2. Cloudflare One Account (**ZeroTrust**)
3. Github - Personal Access Token
4. Docker Hub Account [**optional**]

## Github Actions Secrets

![Github Repository Secrets List](https://i.imgur.com/gyOBD6X.png)

**Settings Path** : *Github Repository* > *Settings* > *Secrets and Variables* > *Actions*

`DOCKER_HUB_USERNAME` : Use this when you want to create private docker repos

`DOCKER_HUB_PASSWORD` : Use this when you want to create private docker repos

`PERSONAL_ACCESS_TOKEN` : Use this when you want a private github workflow

`PRIVATE_UUID` : Use this when you want a private UUID for VLESS authentication. [*optional*] | *default*: `730b6e0c-e463-11ef-a734-b36930036fe6`

`TUNNEL_TOKEN` : Put your Cloudflared Tunnel Token here to bind it. [*required*] - [GUIDE](https://github.com/GegeDesembri/xray-vless-docker#get-cloudflared-tunnel-token)

## Get Cloudflared Tunnel Token

![Cloudflared Tunnel Token](https://i.imgur.com/lKRX4jz.png)

1. Go to [Cloudflare One](https://one.dash.cloudflare.com/)

2. *Networks* > *Tunnels* > *Create Tunnel* > Select "*Cloudflared*" > *follow the instructions*

3. Copy syntax and take the part of the text
```bash
>... run --token eyJhIjoiNDZkYTFhZTYwNDM1ZjFhODk2YjIwNjUwMjA0NGRlNmIiLCJ0IjoiMmQxZDFhODktNjc2Yy00MjQ4LTkwMmUtZjYxZmFjYTg2ZGUwIiwicyI6Ik5tVXdaRFF3TnpJdE5HTmlOaTAwTm1NM0xXRXpaR1F0xxxxxxxxxxxxxxxxxxxxxxxx
```

4. Your tunnel token is
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
![Hostname Settings](https://i.imgur.com/JjHqzXW.png)

## HOW TO USE

1. Fork this Repository to your Github
2. Enter some required credentials according to the instructions and requirements listed [here](https://github.com/GegeDesembri/xray-vless-docker#github-actions-secrets).
3. Goto tab "*Actions*" on your repository > *VLESS Tunnel* > *Run workflow*
![Run workflow](https://i.imgur.com/fZCoYgO.png)
4. Your VLESS Tunnel is up and running
![VLESS Tunnel Running](https://i.imgur.com/o58YQWU.png)
5. VLESS Link example : `vless://730b6e0c-e463-11ef-a734-b36930036fe6@vless.docker.git:443?path=%2Fvless&security=tls&encryption=none&host=vless.docker.git&fp=randomized&type=ws&sni=vless.docker.git#VLESS+Docker`

## Limitations
1. VLESS Tunnel will restart every 6 hours due to Github Actions limitation on timeout for each job
2. Downtime occurs every time job session switches
3. Can only use Cloudflared as outbound traffic
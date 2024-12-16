docker compose --file min-vpn_single-nr/docker-compose-mediastack.yaml --env-file min-vpn_single-nr/docker-compose.env up -d  
docker network connect mediastack qbittorrent
docker network disconnect mediastack_default qbittorrent
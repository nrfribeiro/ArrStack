docker compose --file arr/docker-compose-mediastack.yaml --env-file arr/docker-compose.env up -d  
docker network connect mediastack qbittorrent
docker network disconnect mediastack_default qbittorrent
docker compose --file watchtower/docker-compose.yaml  up -d  
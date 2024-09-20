#!/bin/bash

# Set the timezone
timezone="Australia/Adelaide"  # Replace with your desired timezone

# Create the Docker Compose file for Watchtower
cat > /opt/docker/watchtower/build/docker-compose.yml <<EOL
version: "3"
services:
  watchtower:
    image: containrrr/watchtower
    restart: always
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /etc/timezone:/etc/timezone:ro
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=$timezone
      - UMASK_SET=022 #optional
      - WATCHTOWER_CLEANUP=true
      - WATCHTOWER_LABEL_ENABLE=true
      - WATCHTOWER_INCLUDE_RESTARTING=true
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
EOL

# Change directory to /opt/docker/watchtower/build/
cd /opt/docker/watchtower/build/

# Run docker-compose up -d for Watchtower
docker compose up -d

# Create the Docker Compose file for Portainer Agent
cat > /opt/docker/portainer_agent/build/docker-compose.yml <<EOL
version: "3"
services:
  portainer_agent:
    image: portainer/agent
    restart: always
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=$timezone
      - UMASK_SET=022 #optional
    ports:
      - '9001:9001'
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
EOL

# Change directory to /opt/docker/portainer_agent/build/
cd /opt/docker/portainer_agent/build/

# Run docker-compose up -d for Portainer Agent
docker compose up -d


# Create the Docker Compose file for Watchtower
cat > /opt/docker/node_exporter/build/docker-compose.yml <<EOL
version: '3'
services:
  node-exporter:
    image: prom/node-exporter
    ports:
      - 9100:9100
    restart: always
    labels:
      - com.centurylinklabs.watchtower.enable=true
EOL


cd /opt/docker/node_exporter/build/

# Run docker-compose up -d for Portainer Agent
docker compose up -d

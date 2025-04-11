#!/bin/bash

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Create mattermost user and group
useradd --system --user-group mattermost

# Create necessary directories
mkdir -p /opt/mattermost/{config,data,plugins,client/plugins,logs}

# Set proper permissions
chown -R mattermost:mattermost /opt/mattermost

# Create docker network
docker network create mattermost-network

# Set up docker-compose.yml
cat > /opt/mattermost/docker-compose.yml << 'EOF'
version: "3.8"
services:
  mattermost-db:
    image: postgres:13-alpine
    container_name: mattermost-db
    restart: unless-stopped
    environment:
      - POSTGRES_USER=mmuser
      - POSTGRES_PASSWORD=mmuser_password
      - POSTGRES_DB=mattermost
    volumes:
      - /opt/mattermost/data/db:/var/lib/postgresql/data
    networks:
      - mattermost-network

  mattermost:
    image: mattermost/mattermost-enterprise-edition:latest
    container_name: mattermost
    restart: unless-stopped
    depends_on:
      - mattermost-db
    environment:
      - MM_USERNAME=mmuser
      - MM_PASSWORD=mmuser_password
      - MM_DBNAME=mattermost
      - MM_SQLSETTINGS_DRIVERNAME=postgres
      - MM_SQLSETTINGS_DATASOURCE=postgres://mmuser:mmuser_password@mattermost-db:5432/mattermost?sslmode=disable
      - MM_SERVICESETTINGS_SITEURL=http://138.68.249.92
    volumes:
      - /opt/mattermost/config:/mattermost/config
      - /opt/mattermost/data:/mattermost/data
      - /opt/mattermost/logs:/mattermost/logs
      - /opt/mattermost/plugins:/mattermost/plugins
      - /opt/mattermost/client/plugins:/mattermost/client/plugins
    ports:
      - "8065:8065"
    networks:
      - mattermost-network

networks:
  mattermost-network:
    driver: bridge
EOF

# Start services
cd /opt/mattermost && docker-compose up -d

echo "Setup complete! Please wait a few minutes for the services to start."
echo "You can access Mattermost at http://138.68.249.92:8065" 
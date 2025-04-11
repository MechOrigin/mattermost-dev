#!/bin/bash

# Update system
apt-get update && apt-get upgrade -y

# Create mattermost user and group
useradd --system --user-group mattermost

# Create necessary directories
mkdir -p /opt/mattermost/config
mkdir -p /opt/mattermost/data
mkdir -p /opt/mattermost/plugins
mkdir -p /opt/mattermost/client/plugins
mkdir -p /opt/mattermost/logs

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
      - MM_SERVICESETTINGS_SITEURL=https://138.68.249.92
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

# Install and configure UFW firewall
apt-get install -y ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 8065/tcp
echo "y" | ufw enable

# Security recommendations
echo "Please complete these manual security steps:"
echo "1. Change root password"
echo "2. Set up SSH key authentication"
echo "3. Disable password authentication"
echo "4. Create non-root user with sudo privileges"
echo "5. Configure SSL/TLS certificates" 
# Mattermost Self-Hosted Platform

Hey there! 👋 This is your very own Mattermost chat server that you can run on your computer. Think of it like having your own private Discord or Slack!

## What You Need First
- Docker Desktop (like a special container for running apps)
- Git (to download and save your work)
- A computer with:
  - At least 4GB of memory (RAM)
  - At least 10GB of free space

## Super Easy Setup Guide! 🚀

### Step 1: Get Everything Ready
1. Open your Terminal (it's like a command center for your computer)
2. Copy this project to your computer:
```bash
git clone https://github.com/yourusername/mattermost-dev.git
cd mattermost-dev
```

### Step 2: Set Up Your Server
1. Make a copy of the example settings file:
```bash
cp .env.example .env
```

2. Start your Mattermost server:
```bash
docker-compose up -d
```

3. Check if it works by opening: `http://localhost:8065` in your web browser

## Need Help? 🆘
If something's not working, try these steps:
1. Make sure Docker Desktop is running
2. Check if all the steps above are completed
3. Try restarting your computer
4. Ask for help from a grown-up or tech-savvy friend

## Project Structure

```
mattermost-dev/
├── docker/                 # Docker configuration files
├── config/                 # Mattermost configuration files
├── data/                   # Persistent data storage
├── .env.example           # Example environment variables
├── docker-compose.yml     # Docker Compose configuration
├── README.md              # This file
└── CHECKLIST.md           # Setup and maintenance checklist
```

## Configuration

The main configuration files are located in the `config/` directory. The default configuration is provided in `config/config.json`. You can modify these settings according to your needs.

## Data Persistence

All persistent data is stored in the `data/` directory:
- Database files
- File uploads
- Logs
- Configuration backups

## Security Considerations

- Change default admin credentials immediately after first login
- Configure SSL/TLS for production deployments
- Regularly update the Mattermost server and dependencies
- Follow security best practices for Docker deployments

## Maintenance

Refer to `CHECKLIST.md` for detailed maintenance procedures and best practices.

## Troubleshooting

Common issues and their solutions:
1. Database connection issues
2. File permission problems
3. Memory constraints
4. Network configuration

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and feature requests, please use the GitHub issue tracker.

## Development URLs 🔗

### Mattermost Channel
- AlertManager Dev Channel: http://138.68.249.92:8065/solheim-tech/channels/alertmanager-dev

### Webhooks
- AlertManager Webhook: http://138.68.249.92:8065/hooks/ou4n5jny43fp5mttzmdokpuh1a

### Monitoring Integration 🔔

#### AlertManager Configuration
The Mattermost server is configured with AlertManager integration:
- AlertManager URL: http://138.68.249.92:9093
- Notification Channel: alertmanager-dev
- Team: solheim-tech
- Webhook Token: ou4n5jny43fp5mttzmdokpuh1a

All Prometheus alerts will be automatically forwarded to the AlertManager dev channel.

### Cool Technical Stuff (For the Grown-ups) 🔧

Our development environment is set up with:
- Server running on port: 8065
- Database: PostgreSQL
- Docker containers for easy setup 
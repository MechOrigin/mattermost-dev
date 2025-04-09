# Mattermost Self-Hosted Platform

This repository contains the configuration and setup for a self-hosted Mattermost instance using Docker. Mattermost is an open-source, self-hostable team collaboration platform that provides secure, flexible messaging and collaboration solutions.

## Prerequisites

- Docker Engine (version 20.10.0 or later)
- Docker Compose (version 2.0.0 or later)
- Git
- At least 4GB of RAM
- At least 10GB of free disk space
- Ngrok account (for public access)

## Quick Start

1. Clone this repository:
```bash
git clone https://github.com/yourusername/mattermost-dev.git
cd mattermost-dev
```

2. Configure your environment:
```bash
cp .env.example .env
```

3. Start the Mattermost platform:
```bash
docker-compose up -d
```

4. Access Mattermost locally at `http://localhost:8065`

## Public Access Setup with Ngrok

1. Sign up for a free Ngrok account at https://ngrok.com/signup
2. Install Ngrok:
   ```bash
   # macOS (using Homebrew)
   brew install ngrok
   
   # Other platforms: Download from https://ngrok.com/download
   ```

3. Add your Ngrok auth token to `.env`:
   ```bash
   NGROK_AUTH_TOKEN=your_auth_token_here
   ```

4. Start Ngrok tunnel:
   ```bash
   ngrok start --config ngrok.yml mattermost
   ```

5. Access your Mattermost instance using the Ngrok URL provided in the output

Note: The Ngrok URL will change each time you restart the tunnel unless you have a paid Ngrok account with a reserved domain.

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
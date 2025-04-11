# AlertManager to Mattermost Bridge

This service acts as a bridge between AlertManager and Mattermost, receiving alerts from AlertManager and forwarding them to Mattermost in a properly formatted way.

## Setup

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Make the script executable:
```bash
chmod +x alert_bridge.py
```

3. Run the service:
```bash
./alert_bridge.py
```

Or using gunicorn (recommended for production):
```bash
gunicorn --bind 0.0.0.0:9094 alert_bridge:app
```

## AlertManager Configuration

Update your AlertManager configuration to send alerts to this bridge:

```yaml
receivers:
- name: 'mattermost'
  webhook_configs:
  - url: 'http://your-bridge-host:9094/alert'
    send_resolved: true
```

## Endpoints

- `POST /alert`: Receives alerts from AlertManager
- `GET /health`: Health check endpoint

## Environment Variables (Optional)

You can customize the following environment variables:
- `MATTERMOST_WEBHOOK_URL`: The Mattermost webhook URL
- `LISTEN_PORT`: The port to listen on (default: 9094)

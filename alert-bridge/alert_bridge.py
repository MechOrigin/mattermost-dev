#!/usr/bin/env python3
import os
from flask import Flask, request, jsonify
import requests
import logging
from datetime import datetime

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Configuration
MATTERMOST_WEBHOOK_URL = "http://138.68.249.92:8065/hooks/ou4n5jny43fp5mttzmdokpuh1a"
LISTEN_PORT = 9094

def format_alert_message(alert_data):
    """Format the alert data into a Mattermost message."""
    alerts = alert_data.get('alerts', [])
    if not alerts:
        return None
    
    message_parts = []
    for alert in alerts:
        labels = alert.get('labels', {})
        annotations = alert.get('annotations', {})
        status = alert.get('status', 'unknown')
        
        # Format each alert
        alert_text = (
            f"🚨 **Alert: {labels.get('alertname', 'Unknown Alert')}**\n"
            f"- Status: {status}\n"
            f"- Severity: {labels.get('severity', 'unknown')}\n"
        )
        
        if 'description' in annotations:
            alert_text += f"- Description: {annotations['description']}\n"
            
        if 'summary' in annotations:
            alert_text += f"- Summary: {annotations['summary']}\n"
            
        message_parts.append(alert_text)
    
    return {
        "text": "\n".join(message_parts),
        "username": "AlertManager Bridge",
        "icon_emoji": ":warning:"
    }

@app.route('/alert', methods=['POST'])
def receive_alert():
    """Receive alerts from AlertManager and forward to Mattermost."""
    try:
        alert_data = request.json
        logger.info(f"Received alert: {alert_data}")
        
        message = format_alert_message(alert_data)
        if not message:
            return jsonify({"status": "error", "message": "No alerts in payload"}), 400
        
        # Send to Mattermost
        response = requests.post(
            MATTERMOST_WEBHOOK_URL,
            json=message,
            headers={"Content-Type": "application/json"}
        )
        
        if response.status_code == 200:
            logger.info("Successfully forwarded alert to Mattermost")
            return jsonify({"status": "success"}), 200
        else:
            logger.error(f"Failed to send to Mattermost. Status: {response.status_code}, Response: {response.text}")
            return jsonify({"status": "error", "message": f"Mattermost webhook error: {response.text}"}), 500
            
    except Exception as e:
        logger.error(f"Error processing alert: {str(e)}", exc_info=True)
        return jsonify({"status": "error", "message": str(e)}), 500

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint."""
    return jsonify({"status": "healthy", "timestamp": datetime.utcnow().isoformat()}), 200

if __name__ == '__main__':
    logger.info(f"Starting AlertManager to Mattermost bridge on port {LISTEN_PORT}")
    app.run(host='0.0.0.0', port=LISTEN_PORT)

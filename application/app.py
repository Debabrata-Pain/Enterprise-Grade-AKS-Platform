from flask import Flask, jsonify
import os
import socket
from datetime import datetime

app = Flask(__name__)

VERSION = "1.0.0"

@app.route("/")
def home():
    return jsonify({
        "application": "Enterprise AKS Platform Demo",
        "status": "Running",
        "version": VERSION
    })

@app.route("/health")
def health():
    return jsonify({
        "status": "Healthy",
        "timestamp": datetime.utcnow().isoformat()
    })

@app.route("/version")
def version():
    return jsonify({
        "version": VERSION
    })

@app.route("/info")
def info():
    return jsonify({
        "hostname": socket.gethostname(),
        "environment": os.getenv("ENVIRONMENT", "development"),
        "python": os.sys.version
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
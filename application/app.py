from flask import Flask, jsonify, render_template_string
import os
import socket
from datetime import datetime, timezone

from kubernetes import client, config
from kubernetes.client.rest import ApiException

app = Flask(__name__)

VERSION = "1.0.0"

# ============================================================
# Kubernetes client
# ============================================================

def get_kubernetes_clients():
    """
    Load Kubernetes configuration.

    When running inside AKS, use the pod's ServiceAccount.
    When running locally, fall back to the user's kubeconfig.
    """

    try:
        config.load_incluster_config()
    except config.ConfigException:
        config.load_kube_config()

    return (
        client.CoreV1Api(),
        client.AppsV1Api(),
        client.AutoscalingV2Api()
    )


# ============================================================
# Existing application endpoints
# ============================================================

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

# ============================================================
# Kubernetes dashboard API
# ============================================================

@app.route("/api/cluster")
def cluster():

    try:
        core_api, apps_api, autoscaling_api = get_kubernetes_clients()

        nodes = core_api.list_node().items
        pods = core_api.list_pod_for_all_namespaces().items
        services = core_api.list_service_for_all_namespaces().items
        deployments = apps_api.list_deployment_for_all_namespaces().items
        hpas = autoscaling_api.list_horizontal_pod_autoscaler_for_all_namespaces().items

        ready_nodes = 0

        node_data = []

        for node in nodes:

            ready = False

            if node.status.conditions:
                for condition in node.status.conditions:
                    if condition.type == "Ready":
                        ready = condition.status == "True"

            if ready:
                ready_nodes += 1

            node_data.append({
                "name": node.metadata.name,
                "status": "Ready" if ready else "NotReady",
                "kubelet_version": node.status.node_info.kubelet_version
                if node.status.node_info else "Unknown"
            })

        pod_data = []

        for pod in pods:

            container_statuses = pod.status.container_statuses or []

            ready_containers = sum(
                1 for container in container_statuses
                if container.ready
            )

            total_containers = len(container_statuses)

            pod_data.append({
                "name": pod.metadata.name,
                "namespace": pod.metadata.namespace,
                "status": pod.status.phase,
                "ready": f"{ready_containers}/{total_containers}",
                "node": pod.spec.node_name or "Pending"
            })

        deployment_data = []

        for deployment in deployments:

            desired = deployment.spec.replicas or 0
            ready = deployment.status.ready_replicas or 0

            deployment_data.append({
                "name": deployment.metadata.name,
                "namespace": deployment.metadata.namespace,
                "desired": desired,
                "ready": ready,
                "healthy": ready == desired
            })

        service_data = []

        for service in services:

            service_data.append({
                "name": service.metadata.name,
                "namespace": service.metadata.namespace,
                "type": service.spec.type,
                "cluster_ip": service.spec.cluster_ip
            })

        return jsonify({
            "cluster": {
                "status": "Healthy"
                if ready_nodes == len(nodes) and len(nodes) > 0
                else "Degraded",
                "nodes": len(nodes),
                "ready_nodes": ready_nodes,
                "pods": len(pods),
                "deployments": len(deployments),
                "services": len(services),
                "hpas": len(hpas)
            },
            "node_details": node_data,
            "pod_details": pod_data,
            "deployment_details": deployment_data,
            "service_details": service_data
        })

    except ApiException as exc:

        return jsonify({
            "error": "Kubernetes API error",
            "details": str(exc)
        }), 500

    except Exception as exc:

        return jsonify({
            "error": "Dashboard error",
            "details": str(exc)
        }), 500

# ============================================================
# Dashboard UI
# ============================================================

DASHBOARD_HTML = """
<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Enterprise AKS Dashboard</title>

<style>

* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, Helvetica, sans-serif;
    background: #f4f7fb;
    color: #1f2937;
}

.header {
    background: #111827;
    color: white;
    padding: 24px 40px;
}

.header h1 {
    margin: 0;
    font-size: 26px;
}

.header p {
    margin: 7px 0 0;
    color: #cbd5e1;
}

.container {
    padding: 30px 40px;
    max-width: 1500px;
    margin: auto;
}

.status {
    background: #dcfce7;
    border: 1px solid #86efac;
    color: #166534;
    border-radius: 10px;
    padding: 18px;
    margin-bottom: 25px;
}

.cards {
    display: grid;
    grid-template-columns:
        repeat(auto-fit, minmax(180px, 1fr));

    gap: 20px;

    margin-bottom: 30px;
}

.card {
    background: white;
    padding: 22px;
    border-radius: 12px;

    box-shadow:
        0 2px 8px rgba(0,0,0,0.08);
}

.card-title {
    color: #64748b;
    font-size: 14px;
}

.card-value {
    font-size: 32px;
    font-weight: bold;
    margin-top: 8px;
}

.card-status {
    margin-top: 5px;
    color: #16a34a;
    font-weight: bold;
}

.section {
    background: white;
    border-radius: 12px;
    padding: 25px;
    margin-bottom: 25px;

    box-shadow:
        0 2px 8px rgba(0,0,0,0.08);
}

.section h2 {
    margin-top: 0;
}

table {
    width: 100%;
    border-collapse: collapse;
}

th,
td {
    padding: 12px;
    border-bottom: 1px solid #e5e7eb;
    text-align: left;
}

th {
    color: #64748b;
    font-size: 13px;
}

.badge {
    padding: 5px 10px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: bold;
}

.ready {
    background: #dcfce7;
    color: #166534;
}

.notready {
    background: #fee2e2;
    color: #991b1b;
}

.running {
    background: #dcfce7;
    color: #166534;
}

.pending {
    background: #fef3c7;
    color: #92400e;
}

.refresh {
    float: right;
    padding: 9px 15px;
    border: none;
    border-radius: 7px;
    background: #2563eb;
    color: white;
    cursor: pointer;
}

</style>

</head>

<body>

<div class="header">

    <h1>🚀 Enterprise AKS Platform</h1>

    <p>
        Cloud & Kubernetes Health Dashboard
    </p>

</div>

<div class="container">

    <div id="status" class="status">
        🔄 Loading cluster status...
    </div>

    <div class="cards">

        <div class="card">
            <div class="card-title">AKS Nodes</div>
            <div id="nodes" class="card-value">-</div>
            <div class="card-status">Ready</div>
        </div>

        <div class="card">
            <div class="card-title">Kubernetes Pods</div>
            <div id="pods" class="card-value">-</div>
            <div class="card-status">Running / Active</div>
        </div>

        <div class="card">
            <div class="card-title">Deployments</div>
            <div id="deployments" class="card-value">-</div>
            <div class="card-status">Configured</div>
        </div>

        <div class="card">
            <div class="card-title">Services</div>
            <div id="services" class="card-value">-</div>
            <div class="card-status">Active</div>
        </div>

    </div>


    <div class="section">

        <h2>
            🖥️ AKS Nodes

            <button class="refresh"
                    onclick="loadDashboard()">
                Refresh
            </button>
        </h2>

        <table>

            <thead>

                <tr>
                    <th>Node</th>
                    <th>Status</th>
                    <th>Kubelet Version</th>
                </tr>

            </thead>

            <tbody id="nodes-table"></tbody>

        </table>

    </div>


    <div class="section">

        <h2>📦 Kubernetes Pods</h2>

        <table>

            <thead>

                <tr>
                    <th>Name</th>
                    <th>Namespace</th>
                    <th>Status</th>
                    <th>Ready</th>
                    <th>Node</th>
                </tr>

            </thead>

            <tbody id="pods-table"></tbody>

        </table>

    </div>


    <div class="section">

        <h2>🚀 Deployments</h2>

        <table>

            <thead>

                <tr>
                    <th>Name</th>
                    <th>Namespace</th>
                    <th>Ready</th>
                    <th>Desired</th>
                    <th>Status</th>
                </tr>

            </thead>

            <tbody id="deployments-table"></tbody>

        </table>

    </div>

</div>


<script>

async function loadDashboard() {

    try {

        const response =
            await fetch("/api/cluster");

        const data =
            await response.json();

        if (data.error) {

            document.getElementById("status").innerHTML =
                "🔴 Dashboard Error: " + data.details;

            return;
        }


        const cluster = data.cluster;


        document.getElementById("nodes").innerText =
            cluster.ready_nodes + "/" + cluster.nodes;

        document.getElementById("pods").innerText =
            cluster.pods;

        document.getElementById("deployments").innerText =
            cluster.deployments;

        document.getElementById("services").innerText =
            cluster.services;


        document.getElementById("status").innerHTML =
            cluster.status === "Healthy"
            ? "🟢 All Systems Operational"
            : "🟠 Cluster Health Degraded";


        document.getElementById("nodes-table").innerHTML =
            data.node_details.map(node => `

                <tr>

                    <td>${node.name}</td>

                    <td>
                        <span class="badge ${
                            node.status === "Ready"
                            ? "ready"
                            : "notready"
                        }">
                            ${node.status}
                        </span>
                    </td>

                    <td>${node.kubelet_version}</td>

                </tr>

            `).join("");


        document.getElementById("pods-table").innerHTML =
            data.pod_details.map(pod => `

                <tr>

                    <td>${pod.name}</td>

                    <td>${pod.namespace}</td>

                    <td>
                        <span class="badge ${
                            pod.status === "Running"
                            ? "running"
                            : "pending"
                        }">
                            ${pod.status}
                        </span>
                    </td>

                    <td>${pod.ready}</td>

                    <td>${pod.node}</td>

                </tr>

            `).join("");


        document.getElementById("deployments-table").innerHTML =
            data.deployment_details.map(deployment => `

                <tr>

                    <td>${deployment.name}</td>

                    <td>${deployment.namespace}</td>

                    <td>
                        ${deployment.ready}
                    </td>

                    <td>
                        ${deployment.desired}
                    </td>

                    <td>

                        <span class="badge ${
                            deployment.healthy
                            ? "ready"
                            : "notready"
                        }">

                            ${
                                deployment.healthy
                                ? "Healthy"
                                : "Degraded"
                            }

                        </span>

                    </td>

                </tr>

            `).join("");

    }

    catch (error) {

        document.getElementById("status").innerHTML =
            "🔴 Unable to connect to Kubernetes dashboard";

    }

}


loadDashboard();

setInterval(loadDashboard, 30000);

</script>

</body>

</html>
"""


@app.route("/dashboard")
def dashboard():

    return render_template_string(DASHBOARD_HTML)


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000
    )
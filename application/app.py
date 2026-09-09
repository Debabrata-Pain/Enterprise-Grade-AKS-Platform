from flask import Flask, jsonify, render_template
import os
import socket
from datetime import datetime, time

from kubernetes import client, config


app = Flask(__name__)

VERSION = "1.0.0"

# ============================================================
# Existing Application Endpoints
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
# Kubernetes Client
# ============================================================

def get_kubernetes_clients():

    try:
        # Running inside AKS
        config.load_incluster_config()

    except Exception:

        # Allows local development outside Kubernetes
        config.load_kube_config()

    core_v1 = client.CoreV1Api()
    apps_v1 = client.AppsV1Api()
    networking_v1 = client.NetworkingV1Api()

    return core_v1, apps_v1, networking_v1


# ============================================================
# Dashboard
# ============================================================

@app.route("/dashboard")
def dashboard():

    try:

        core_v1, apps_v1, networking_v1 = get_kubernetes_clients()

        # ----------------------------------------------------
        # Nodes
        # ----------------------------------------------------

        nodes = core_v1.list_node().items

        node_data = []

        for node in nodes:

            status = "Unknown"

            for condition in node.status.conditions or []:

                if condition.type == "Ready":
                    status = "Ready" if condition.status == "True" else "NotReady"

            node_data.append({
                "name": node.metadata.name,
                "status": status,
                "version": node.status.node_info.kubelet_version
                if node.status.node_info else "Unknown"
            })


        # ----------------------------------------------------
        # Pods
        # ----------------------------------------------------

        pods = core_v1.list_pod_for_all_namespaces().items

        pod_data = []

        for pod in pods:

            pod_data.append({
                "name": pod.metadata.name,
                "namespace": pod.metadata.namespace,
                "status": pod.status.phase or "Unknown"
            })


        # ----------------------------------------------------
        # Deployments
        # ----------------------------------------------------

        deployments = apps_v1.list_deployment_for_all_namespaces().items

        deployment_data = []

        for deployment in deployments:

            deployment_data.append({
                "name": deployment.metadata.name,
                "namespace": deployment.metadata.namespace,
                "desired": deployment.spec.replicas or 0,
                "ready": deployment.status.ready_replicas or 0
            })


        # ----------------------------------------------------
        # Services
        # ----------------------------------------------------

        services = core_v1.list_service_for_all_namespaces().items

        service_data = []

        for service in services:

            service_data.append({
                "name": service.metadata.name,
                "namespace": service.metadata.namespace,
                "type": service.spec.type,
                "cluster_ip": service.spec.cluster_ip or "-"
            })


        # ----------------------------------------------------
        # Ingress
        # ----------------------------------------------------

        ingresses = networking_v1.list_ingress_for_all_namespaces().items

        ingress_data = []

        for ingress in ingresses:

            address = "-"

            if ingress.status and ingress.status.load_balancer:
                ingress_points = ingress.status.load_balancer.ingress or []

                if ingress_points:

                    first = ingress_points[0]

                    address = first.ip or first.hostname or "-"

            ingress_data.append({
                "name": ingress.metadata.name,
                "namespace": ingress.metadata.namespace,
                "address": address
            })


        # ----------------------------------------------------
        # Summary
        # ----------------------------------------------------

        ready_nodes = len([
            node for node in node_data
            if node["status"] == "Ready"
        ])

        running_pods = len([
            pod for pod in pod_data
            if pod["status"] == "Running"
        ])

        healthy_deployments = len([
            deployment for deployment in deployment_data
            if deployment["desired"] == deployment["ready"]
        ])

        # ----------------------------------------------------
        # Platform Availability
        # ----------------------------------------------------

        if node_data and deployment_data:

            node_availability = ready_nodes / len(node_data)
            deployment_availability = (
                healthy_deployments / len(deployment_data)
            )

            availability_percentage = (
                (node_availability + deployment_availability) / 2
            ) * 100

        else:

            availability_percentage = 0.0

        availability_percentage = round(availability_percentage, 2)


        overall_status = "Healthy"

        if ready_nodes != len(node_data):
            overall_status = "Degraded"

        if healthy_deployments != len(deployment_data):
            overall_status = "Degraded"


        return render_template(
            "dashboard.html",

            version=VERSION,
            timestamp=datetime.utcnow().isoformat(),

            overall_status=overall_status,

            node_count=len(node_data),
            ready_node_count=ready_nodes,

            pod_count=len(pod_data),
            running_pod_count=running_pods,

            deployment_count=len(deployment_data),
            healthy_deployment_count=healthy_deployments,

            service_count=len(service_data),
            ingress_count=len(ingress_data),

            nodes=node_data,
            pods=pod_data,
            deployments=deployment_data,
            services=service_data,
            ingresses=ingress_data,

            availability=f"{availability_percentage:.2f}%"
        )


    except Exception as error:

        return render_template(
            "dashboard.html",

            version=VERSION,
            timestamp=datetime.utcnow().isoformat(),

            overall_status="Unavailable",

            node_count=0,
            ready_node_count=0,

            pod_count=0,
            running_pod_count=0,

            deployment_count=0,
            healthy_deployment_count=0,

            service_count=0,
            ingress_count=0,

            nodes=[],
            pods=[],
            deployments=[],
            services=[],
            ingresses=[],

            availability="0.00%",

            error=str(error)
        )


# ============================================================
# Application Startup
# ============================================================

if __name__ == "__main__":

    app.run(
        host="0.0.0.0",
        port=5000
    )
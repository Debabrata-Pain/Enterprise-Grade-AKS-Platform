<div align="center">

# Enterprise-Grade AKS Platform on Azure

### Production-Ready Azure Kubernetes Service (AKS) Platform built using Terraform, Azure DevOps, Docker and Kubernetes

[![Terraform](https://img.shields.io/badge/Terraform-1.13+-623CE4?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/Microsoft_Azure-Cloud-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com/)
[![AKS](https://img.shields.io/badge/Azure_Kubernetes_Service-AKS-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://learn.microsoft.com/azure/aks/)
[![Docker](https://img.shields.io/badge/Docker-Containers-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-Orchestration-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Azure DevOps](https://img.shields.io/badge/Azure_DevOps-CI/CD-0078D7?style=for-the-badge&logo=azuredevops&logoColor=white)](https://azure.microsoft.com/services/devops/)
[![Python](https://img.shields.io/badge/Python-Flask-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)

</div>

---

# Project Overview

This project demonstrates the design and implementation of a **production-ready Azure Kubernetes Service (AKS) platform** using Infrastructure as Code (Terraform).

Instead of deploying a standalone Kubernetes cluster, this repository provisions an enterprise platform consisting of secure networking, identity management, monitoring, container registry, secrets management, Kubernetes workloads, and CI/CD integration following Microsoft Azure Well-Architected Framework principles.

The project focuses on modularity, scalability, security, automation, and production best practices.

---

# Architecture

> Enterprise AKS Platform Architecture

![Architecture](images/Enterprise-AKS-Platform-LLD.png)

The platform consists of:

- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- Azure Key Vault
- User Assigned Managed Identity
- Azure Monitor
- Log Analytics Workspace
- Azure Workload Identity
- Key Vault CSI Driver
- NGINX Ingress Controller
- Horizontal Pod Autoscaler
- Pod Disruption Budget
- Azure DevOps CI/CD
- Terraform Remote State

---

# Key Features

## Infrastructure

- Modular Terraform architecture
- Remote Terraform State (Azure Storage)
- Environment-based deployment
- Reusable Terraform modules
- User Assigned Managed Identity
- Azure RBAC

---

## Networking

- Virtual Network
- Multiple Subnets
- Network Security Groups
- Route Tables
- VNet Peering
- Azure Firewall (Optional)
- Private Endpoint support (Premium SKU)
- Private DNS integration

---

## Kubernetes

- Azure Kubernetes Service
- System & User Node Pools
- Azure CNI Overlay Networking
- Azure Policy Enabled
- OIDC Issuer
- Workload Identity
- Metrics Server
- NGINX Ingress Controller
- Horizontal Pod Autoscaler
- Pod Disruption Budget

---

## Container Platform

- Azure Container Registry
- Docker Image Build
- Image Versioning
- Secure Image Pull using Managed Identity

---

## Secrets Management

- Azure Key Vault
- Secrets Store CSI Driver
- Workload Identity Federation
- Zero secrets stored inside Kubernetes

---

## Monitoring

- Azure Monitor
- Log Analytics Workspace
- Container Insights
- Metrics Server
- Kubernetes Metrics

---

## DevOps

- GitHub Repository
- Azure DevOps Pipeline
- Infrastructure as Code
- CI/CD Ready
- Git Version Control

---

# Folder Structure

```text
Enterprise-Grade-AKS-Platform/

├── application/
│   ├── k8s/
│   ├── Dockerfile
│   ├── app.py
│   └── requirements.txt
│
├── terraform/
│   ├── environments/
│   │   ├── dev/
│   │   ├── test/
│   │   └── prod/
│   │
│   ├── modules/
│   │   ├── aks/
│   │   ├── acr/
│   │   ├── keyvault/
│   │   ├── managed-identity/
│   │   ├── monitoring/
│   │   ├── firewall/
│   │   ├── vnet/
│   │   ├── subnet/
│   │   ├── nsg/
│   │   ├── route-table/
│   │   └── ...
│   │
│   └── versions.tf
│
├── azure-devops/
│   └── CI-CD.yaml
│
├── README.md
└── .gitignore
```

---

# Technology Stack

| Category | Technologies |
|-----------|--------------|
| Cloud | Microsoft Azure |
| IaC | Terraform |
| Containers | Docker |
| Orchestration | Kubernetes |
| Container Platform | Azure Kubernetes Service |
| Registry | Azure Container Registry |
| Secrets | Azure Key Vault |
| Identity | Managed Identity + Workload Identity |
| Monitoring | Azure Monitor + Log Analytics |
| CI/CD | Azure DevOps |
| Language | Python (Flask) |

---

# Deployment Workflow

```text
Developer
      │
      ▼
GitHub Repository
      │
      ▼
Azure DevOps Pipeline
      │
      ▼
Terraform
      │
      ▼
Azure Infrastructure
      │
      ▼
Azure Container Registry
      │
      ▼
AKS Cluster
      │
      ▼
NGINX Ingress
      │
      ▼
Flask Application
```

---

# Security

The platform implements multiple enterprise security controls:

- Azure RBAC
- User Assigned Managed Identity
- Azure Workload Identity
- OIDC Federation
- Azure Key Vault
- Secrets Store CSI Driver
- Network Security Groups
- Private Endpoints (Supported)
- Private DNS (Supported)
- Secure image pull using ACR permissions
- Kubernetes Service Accounts

---

# Monitoring & Observability

The platform includes:

- Azure Monitor
- Log Analytics Workspace
- Container Insights
- Metrics Server
- Horizontal Pod Autoscaler metrics
- Kubernetes Events
- Pod Health Monitoring

---

# Screenshots

Add screenshots here.

Example:

- Azure Portal Resources
- AKS Cluster
- ACR
- Key Vault
- Azure Monitor
- Terraform Apply
- Kubernetes Pods
- HPA
- Workload Identity
- GitHub Repository

---

# Future Enhancements

- Azure Application Gateway Ingress Controller (AGIC)
- GitOps using FluxCD
- ArgoCD Deployment
- Helm Charts
- Private AKS Cluster
- Azure Firewall Premium
- Azure Policy as Code
- Defender for Cloud
- Velero Backup & Restore
- Multi-region Disaster Recovery
- Azure Front Door
- Prometheus + Grafana
- OpenTelemetry
- KEDA Event-driven Autoscaling

---

# Learning Outcomes

This project demonstrates practical experience with:

- Terraform Module Design
- Azure Infrastructure Automation
- Kubernetes Administration
- AKS Networking
- Azure Identity
- Secrets Management
- Containerization
- CI/CD
- Monitoring
- Production Deployment

---

# Author

**Debabrata Pain**

Azure | Terraform | Kubernetes | Docker | Azure DevOps

- AZ-104: Microsoft Azure Administrator
- AZ-900: Microsoft Azure Fundamentals
- AI-900: Microsoft Azure AI Fundamentals
- AWS Certified Cloud Practitioner

---

## Star this repository if you found it useful!

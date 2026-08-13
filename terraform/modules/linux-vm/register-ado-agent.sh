#!/bin/bash
set -euo pipefail

AZDO_ORG_URL="https://dev.azure.com/debabratapain"
AZDO_POOL="Enterprise-AKS-Agents"
AZDO_AGENT_NAME="prod-ado-agent"

KEYVAULT_NAME="prodkvdeb2026"
PAT_SECRET_NAME="ado-agent-pat"

AGENT_DIR="/home/azureuser/azagent"
AGENT_USER="azureuser"

MARKER_FILE="/var/lib/azure-devops-agent-registered"
AGENT_VERSION="4.269.0"

AGENT_PACKAGE="vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz"
AGENT_URL="https://download.agent.dev.azure.com/agent/${AGENT_VERSION}/${AGENT_PACKAGE}"

echo "============================================"
echo " Azure DevOps Agent Bootstrap"
echo "============================================"

# --------------------------------------------------
# Idempotency
# --------------------------------------------------

if [ -f "$MARKER_FILE" ]; then
    echo "Azure DevOps agent is already registered."
    exit 0
fi

# --------------------------------------------------
# Prepare agent directory
# --------------------------------------------------

mkdir -p "$AGENT_DIR"
chown -R "$AGENT_USER:$AGENT_USER" "$AGENT_DIR"

cd "$AGENT_DIR"

# --------------------------------------------------
# Download Azure DevOps agent
# --------------------------------------------------

echo "Downloading Azure DevOps Agent ${AGENT_VERSION}..."

curl -fsSL "$AGENT_URL" -o "$AGENT_PACKAGE"

tar -xzf "$AGENT_PACKAGE"

rm -f "$AGENT_PACKAGE"

chown -R "$AGENT_USER:$AGENT_USER" "$AGENT_DIR"

# --------------------------------------------------
# Authenticate Azure using Managed Identity
# --------------------------------------------------

echo "Authenticating Azure using Managed Identity..."

az login --identity --allow-no-subscriptions >/dev/null

# --------------------------------------------------
# Retrieve PAT from Key Vault
# --------------------------------------------------

echo "Retrieving Azure DevOps PAT from Key Vault..."

AZDO_PAT="$(az keyvault secret show \
    --vault-name "$KEYVAULT_NAME" \
    --name "$PAT_SECRET_NAME" \
    --query value \
    --output tsv)"

if [ -z "$AZDO_PAT" ]; then
    echo "ERROR: Azure DevOps PAT could not be retrieved."
    exit 1
fi

# --------------------------------------------------
# Register Azure DevOps agent
# --------------------------------------------------

echo "Registering Azure DevOps agent..."

sudo -u "$AGENT_USER" env AZDO_PAT="$AZDO_PAT" bash -c "
    cd '$AGENT_DIR'

    ./config.sh \
        --unattended \
        --url '$AZDO_ORG_URL' \
        --auth pat \
        --token \"\$AZDO_PAT\" \
        --pool '$AZDO_POOL' \
        --agent '$AZDO_AGENT_NAME' \
        --work '_work' \
        --replace
"

# Remove PAT from current shell
unset AZDO_PAT

# --------------------------------------------------
# Install agent as system service
# --------------------------------------------------

echo "Installing Azure DevOps Agent service..."

cd "$AGENT_DIR"

./svc.sh install "$AGENT_USER"
./svc.sh start

# --------------------------------------------------
# Mark successful completion
# --------------------------------------------------

touch "$MARKER_FILE"

echo "============================================"
echo " Azure DevOps Agent setup completed"
echo "============================================"
#!/bin/bash

set -e

# Step 1: Add Argo CD Helm Repository
echo "👉 Adding ArgoCD Helm repository..."
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# Step 2: Install Argo CD with Helm
echo "👉 Installing ArgoCD into 'argocd' namespace..."
helm install argocd argo/argo-cd --namespace argocd --create-namespace

# Step 3: Verify installation
echo "👉 Waiting for ArgoCD pods to be ready..."
kubectl wait --for=condition=available --timeout=600s deployment -n argocd --all

# Step 4: Patch ArgoCD server service to LoadBalancer
echo "👉 Updating ArgoCD server service to LoadBalancer..."
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Step 5: Retrieve LoadBalancer URL
echo "👉 Waiting for LoadBalancer external address..."
EXTERNAL_URL=""
for i in {1..30}; do
  EXTERNAL_URL=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || true)
  if [ -z "$EXTERNAL_URL" ]; then
    EXTERNAL_URL=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || true)
  fi
  if [ -n "$EXTERNAL_URL" ]; then
    break
  fi
  echo "⏳ Waiting for LoadBalancer IP/Hostname..."
  sleep 20
done

if [ -z "$EXTERNAL_URL" ]; then
  echo "❌ Failed to retrieve LoadBalancer address. Please check your Kubernetes provider."
  exit 1
fi

echo "✅ ArgoCD LoadBalancer Address: http://$EXTERNAL_URL"

# Step 6: Get ArgoCD Initial Admin Password
echo "👉 Retrieving ArgoCD admin password..."
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d)

echo "======================================"
echo "🎉 ArgoCD Installation Completed!"
echo "ArgoCD URL: http://$EXTERNAL_URL"
echo "Username: admin"
echo "Password: $ARGOCD_PASSWORD"
echo "======================================"
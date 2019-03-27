#
group=mtakubelab
region=WestUS2

az group create -n $group -l $region


az aks get-versions -l $region -o table

az aks create -g $group -n aks-cluster -l $region \
--node-count 3 --node-vm-size Standard_DS2_v2 \
--kubernetes-version 1.11.8 --verbose  

kubectl cluster-info
kubectl get nodes
kubectl get all -n kube-system

kubectl create clusterrolebinding kubernetes-dashboard \
--clusterrole=cluster-admin \
--serviceaccount=kube-system:kubernetes-dashboard
az aks browse -g $group -n aks-cluster

# Lab 2
ACR_NAME="lncmta032719"
az acr create -n $ACR_NAME -g $group -l $region --sku Standard --admin-enabled true

# lncmta032719.azurecr.io
ACR_PWD=`az acr credential show -n $ACR_NAME -g $group --query "passwords[0].value" -o tsv`

kubectl create secret docker-registry acr-auth --docker-server $ACR_NAME.azurecr.io \
  --docker-username $ACR_NAME --docker-password $ACR_PWD --docker-email ignore@dummy.com

az acr build --registry $ACR_NAME -g $group --file node/data-api/Dockerfile \
    --image smilr/data-api https://github.com/benc-uk/smilr.git
az acr build --registry $ACR_NAME -g $group --file node/frontend/Dockerfile \
    --image smilr/frontend https://github.com/benc-uk/smilr.git
az acr repository list -g $group --name $ACR_NAME -o table




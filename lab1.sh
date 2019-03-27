#
group=mtakubelab
region=WestUS2

az group create -n $group -l $region


az aks get-versions -l $region -o table

az aks create -g $group -n aks-cluster -l $region \
--node-count 3 --node-vm-size Standard_DS2_v2 \
--kubernetes-version 1.11.8 --verbose  

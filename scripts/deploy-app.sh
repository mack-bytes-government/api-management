RESOURCE_GROUP_NAME=$1
APP_SERVICE_NAME=$2

az webapp up --resource-group $RESOURCE_GROUP_NAME --name $APP_SERVICE_NAME --runtime PYTHON:3.9 --sku B1 --logs
az webapp up --name api11-dev-app --resource-group api11-dev-rg --runtime "PYTHON|3.11"
az webapp config set --resource-group $RESOURCE_GROUP_NAME --name $APP_SERVICE_NAME --startup-file ./app/startup.txt
#overview:
#https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-function-linux-custom-image?pivots=programming-language-other&tabs=bash%2Cportal
#
#install:
#Azure CLI/https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)
#Azure Functions Core Tools (https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=windows%2Ccsharp%2Cbash#v2)
#R for Windows (e.g. https://ftp.fau.de/cran/)
#Docker Windows CE (https://hub.docker.com/editions/community/docker-ce-desktop-windows/)
#
#build:
#docker build --build-arg proxy_url=<PROXYURL> -t rhuettl/square:v1.0.0 .
#
#run:
#docker run -p 8080:80 -it rhuettl/square:v1.0.0
#
#parallel execution tests - copy post json to working directory
#https://www.cedric-dumont.com/2017/02/01/install-apache-benchmarking-tool-ab-on-windows/
#100 requests, 10 concurrent
#ab -p triangle.json -c 10 -n 100 -v 4 <URL>
#
#docker hub
#docker login
#docker push rhuettl/square:v1.0.0
#
#Azure setup
#az login --tenant <TENANTNAME>.onmicrosoft.com
#az account list --output table
#az account set --subscription "<RGNAME>"
#
#az storage account create --name <STORAGENAME> --location westeurope --resource-group <RGNAME> --sku Standard_LRS
#
#az functionapp plan create --resource-group <RGNAME> --name <PLANNAME> --location westeurope --number-of-workers 1 --sku EP1 --is-linux
#az functionapp create --functions-version 3 --name <FUNCNAME> --storage-account <STORAGENAME> --resource-group <RGNAME> --plan <PLANNAME> --runtime custom --deployment-container-image-name rhuettl/square:v1.0.0
#
#az storage account show-connection-string --resource-group <RGNAME> --name <STORAGENAME> --query connectionString --output tsv
#az functionapp config appsettings set --name <FUNCNAME> --resource-group <RGNAME> --settings AzureWebJobsStorage=<STORAGECONNECTIONSTRING>
#
#TODO
#- HTTPS certificate
#- AD APP authentication
#- VNet integration
#- Scaling and pricing (plan, storage, app insights)
#- Configure monitoring and alerts
#- Integrate in Artifactory SaaS
#- CI/CD pipeline integration
#- Documentation and sexurity discussion / approval

FROM mcr.microsoft.com/azure-functions/dotnet:3.0-appservice 

ARG proxy_url

ENV AzureWebJobsScriptRoot=/home/site/wwwroot
ENV AzureFunctionsJobHost__Logging__Console__IsEnabled=true

#Set http proxy if required (e.g. within MR clients)
#ENV http_proxy http:$proxy_url:3128/    
#ENV https_proxy http:$proxy_url:3128/

RUN apt-get update -qq && apt-get install -y libcurl4-openssl-dev git-core libssl-dev libsodium-dev
RUN apt-get install -y r-base

RUN R -e "install.packages(c('plumber'), repos='http://cloud.r-project.org')"
RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/nloptr/nloptr_1.2.1.tar.gz', repos=NULL, type='source')"
RUN R -e "install.packages('ChainLadder', dependencies=TRUE, Ncpus=4, repos='http://cloud.r-project.org')"

#only for httpuv web server in R
#RUN apt update && apt install -y r-base && \
#RUN R -e "install.packages('httpuv', repos='http://cran.rstudio.com/')"

COPY . /home/site/wwwroot

ENV http_proxy=
ENV https_proxy=

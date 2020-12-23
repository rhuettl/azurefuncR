FROM mcr.microsoft.com/azure-functions/dotnet:3.0-appservice 

ENV AzureWebJobsScriptRoot=/home/site/wwwroot
ENV AzureFunctionsJobHost__Logging__Console__IsEnabled=true
   

RUN apt-get update -qq && apt-get install -y libcurl4-openssl-dev git-core libssl-dev libsodium-dev

RUN apt-get install -y r-base

RUN R -e "install.packages(c('plumber'), repos='http://cloud.r-project.org')"

RUN  R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/nloptr/nloptr_1.2.1.tar.gz', repos=NULL, type='source')"

RUN  R -e "install.packages('ChainLadder', dependencies=TRUE, Ncpus=4, repos='http://cloud.r-project.org')"

#RUN apt update && apt install -y r-base && \
#RUN R -e "install.packages('httpuv', repos='http://cran.rstudio.com/')"

COPY . /home/site/wwwroot
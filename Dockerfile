FROM ubuntu:22.04

WORKDIR /cloud_report

RUN apt-get update

RUN apt-get -y install ca-certificates curl apt-transport-https lsb-release gnupg python3-pip python3-venv jq unzip

RUN apt-get -y install hcloud-cli=1.13.0-2build2

# AWS
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.11.26.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip && rm awscliv2.zip && ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

# Azure
RUN mkdir -p /etc/apt/keyrings

RUN curl -sLS https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg

RUN chmod go+r /etc/apt/keyrings/microsoft.gpg

RUN echo "deb [arch=$(dpkg --print-architecture), signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/azure-cli.list

RUN apt-get update && apt-get install azure-cli=2.59.0-1~$(lsb_release -cs)

# GCP
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

RUN apt-get update && apt-get -y install google-cloud-cli=470.0.0-0

# OCI
RUN bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/v3.39.1/scripts/install/install.sh)" \
    -- --accept-all-defaults --oci-cli-version 3.39.1

RUN pip install hdns_cli==1.0.0

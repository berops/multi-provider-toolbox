FROM ubuntu:22.04

WORKDIR /cloud_report

RUN apt-get update

RUN apt-get -y install ca-certificates curl apt-transport-https lsb-release gnupg python3-pip python3-venv jq

RUN apt-get -y install hcloud-cli=1.13.0-2build2

# first answer https://unix.stackexchange.com/questions/433942/how-to-specify-extra-tz-info-for-apt-get-install-y-awscli
RUN export TZ=Europe/Paris && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get -y install awscli=1.22.34-1

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

RUN bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/v3.39.1/scripts/install/install.sh)" -- --accept-all-defaults

RUN pip install hdns_cli==1.0.0

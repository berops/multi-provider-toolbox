FROM ubuntu:22.04

WORKDIR /cloud_report

RUN apt-get update

RUN apt-get -y install ca-certificates curl apt-transport-https lsb-release gnupg python3-pip python3-venv

RUN apt-get -y install hcloud-cli

# first answer https://unix.stackexchange.com/questions/433942/how-to-specify-extra-tz-info-for-apt-get-install-y-awscli
RUN export TZ=Europe/Paris && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get -y install awscli

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# GCP
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

RUN apt-get update && apt-get -y install google-cloud-cli

# OCI

RUN bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)" -- --accept-all-defaults

RUN pip install hdns_cli
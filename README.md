# multi-provider-toolbox
The Dockerfile in this repository creates image, which has installed CLI for GCP, Hetzner, AWS, Azure and OCI.

You can pull the created image by running the command below.

`docker pull ghcr.io/berops/multi-provider-toolbox/multi-provider-toolbox:latest`

This image is also used in our cloud usage report cronjob.

### Cloud providers' CLI versions:

* GCP - 470.0.0
* Hetzner - 1.42.0
* Hetzner DNS - 1.0.0
* AWS - 2.11.26
* Azure - 2.59.0
* OCI - 3.39.1

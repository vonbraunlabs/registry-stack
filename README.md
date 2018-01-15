# VBL-Registry

VBL-Registry is a Docker Swarm stack that deploys a working Registry2 private
repository with self-signed certificates.

Run the following command to generate the `htpasswd`, replacing `testuser` and
`testpassword` with the proper values:

```
docker run --entrypoint htpasswd registry:2 -Bbn testuser testpassword > htpasswd
```

Copy the `.env.template` file to `.env` and edit it to add the domain to be
used.

```
cp .env.template .env
```

Run `deploy.sh` to create the registry stack. Certificates will be automatically
generated on the first time you run the script:

```
./deploy.sh
```

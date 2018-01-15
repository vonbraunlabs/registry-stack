# Registry-Stack


VBL-Registry is a Docker Swarm stack that deploys a working Registry2 private
repository with self-signed certificates.

## Setup Registry-Stack

Run the following command to generate the `htpasswd`, replacing `testuser` and
`testpassword` with the proper values:

```
docker run --entrypoint htpasswd registry:2 -Bbn testuser testpassword > htpasswd
```

Copy the `.env.template` file to `.env` and edit it to add the domain to be
used. From now on, the Registry domain will be referred to as REGISTRY-DOMAIN.

```
cp .env.template .env
```

Run `deploy.sh` to create the registry stack. Certificates will be automatically
generated on the first time you run the script:

```
./deploy.sh
```

After that, all nodes in the swarm will be able to access Registry2 on port
5000.

The file .secrets/site.crt is the SSL certificate that must be imported by the
clients who will connect to the Registry.

## Setup Docker Client

This steps should be repeated on each docker client that must access the
registry.

Make sure the registry is accessible:

```
curl -k https://REGISTRY-DOMAIN:5000/v2/
```

The expected response is:

```
{"errors":[{"code":"UNAUTHORIZED","message":"authentication required","detail":null}]}
```

It means it was able to connect but couldn't get authorization, as expected. The
`-k` is to make `curl` ignore the invalid SSL certifiacte.

Copy the SSL certificate to the path
`/etc/docker/certs.d/REGISTRY-DOMAIN:5000/ca.crt`. If this is the first
certificate being imported, the `certs.d` path might not exists, create it.
Replace `REGISTRY-DOMAIN` by the proper domain name. It is importante to keep
the port on the directory name. You don't need to restart Docker after that
step. Now login with Docker:

```
docker login REGISTRY-DOMAIN:5000
```

Use the username and password defined on the beginning of `Setup
Registry-Stack`.

Done.

Note that, if your Docker is using proxy, the login might not work. Disable the
proxy to be sure, Commend the `HTTP_PROXY` variable on
`/etc/systemd/system/docker.service.d/http-proxy.conf`, reload systemd and
restart Docker:

```
systemctl daemon-reload
systemctl restart docker
```

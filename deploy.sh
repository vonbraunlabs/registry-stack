#!/bin/bash

BASEDIR=$(dirname $0)
source $BASEDIR/.env
DIR_KEY=$BASEDIR/.secrets
UNDEPLOY=0

if [ ! -d $DIR_KEY ]
then
    mkdir $DIR_KEY
    UNDEPLOY=1
fi

if [ ! -e $DIR_KEY/site.crt ] || [ ! -e $DIR_KEY/site.key ]
then
    openssl req -x509 -newkey rsa:4096 -nodes -subj "/CN=$DOMAIN" -keyout $DIR_KEY/site.key -out $DIR_KEY/site.crt -days 365
    UNDEPLOY=1
fi

if [ 1 == $UNDEPLOY ]
then
    docker stack rm vbl-registry
fi

docker stack deploy --compose-file=docker-compose.yml --with-registry-auth --prune vbl-registry

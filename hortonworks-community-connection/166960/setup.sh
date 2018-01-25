#!/bin/sh -e

export network_name='ca-net'
export tls_token=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

echo -n ${tls_token} > .tls_token

echo "Created one time TLS token of ${tls_token}"

if [ ! "$(docker network ls | grep -w ${network_name})" ]; then
    # Create the network
    network_id="$(docker network create ${network_name})"
    echo Created Docker network ${network_name} with id ${network_id}
fi

echo Starting NiFi CA from the TLS Toolkit
$(docker-compose up -d)

#!/bin/sh -ex

docker build -t minifi-431 .
docker run -it -v $(greadlink -f .)/mvn_repo:/root/.m2 minifi-431 /bin/bash

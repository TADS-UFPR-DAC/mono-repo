#!/bin/sh
docker container rm -f gerente-service api-gateway gerente-bd postgres-build-test conta-bd conta-service auth-bd auth-service cliente-service cliente-bd  #DELETE CONTAINERS
docker container ls
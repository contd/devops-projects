#!/usr/bin/env bash

# To change the pvc to point to an already existing one see
# https://github.com/bitnami/charts/tree/master/upstreamed/postgresql

# Generated Passwords CHANGE THESE!!!
ROOT_PASSWORD="Fi7a9wuAJC"
REPLICATION_PASSWORD="aZYL2h2uj48ufCX9oj5Med7Y5NMiRA"

# Install Postgres cluster
helm install \
    --name pg-rel \
    -f prod-postgres.yaml \
    --set postgresqlPassword=${ROOT_PASSWORD} \
    --set postgresqlDatabase=${ROOT_PASSWORD} \
    --set replication.password=${REPLICATION_PASSWORD} \
    bitnami/postgresql

'''
#################################################################################################
# NOTES:

# To connect to your database run the following command:
kubectl run pg-rel-postgresql-client --rm --tty -i \
    --restart='Never' --namespace default \
    --image bitnami/postgresql \
    --env="PGPASSWORD=$POSTGRES_PASSWORD" \
    --command -- psql \
    --host pg-rel-postgresql -U postgres

# To connect to your database from outside the cluster execute the following commands:
kubectl port-forward --namespace default svc/pg-rel-postgresql 5432:5432 & \
    PGPASSWORD="Fi7a9wuAJC" psql --host 127.0.0.1 -U postgres

'''

exit 0

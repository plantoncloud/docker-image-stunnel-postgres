# stunnel-postgres

This project is an interim solution until support for StartTLS lands in istio which is being tracked in [add postgres StartTLS proxying](https://github.com/istio/istio/issues/29761) github issue. 

Any postgres client trying to connect to postgres servers running on planton cloud managed hosting environments fails to connect for the reason explained in this [github issue](https://github.com/traefik/traefik/pull/8935). So, clients should use stunnel to be able to successfully connect to the postgres server. The server would also run stunnel alongside postgres to terminate the ssl requests from stunnel clients.

## client

This docker image is to be used for running as a sidecar container for microservices that require connectivity to postgres clusters which are running in planton cloud hosting environments to avoid StartTLS problem.

## server

The docker image also includes a startup script that is required to setup the stunnel configuration file. The startup requires the following environment variables to be set to successfully generate the configuration file.

## environment variables

### STUNNEL_MODE

The value should be either `server` or `client`.

### STUNNEL_ACCEPT_PORT

The port on which stunnel to accept postgresql connections.

### STUNNEL_FORWARD_HOST

The ip or hostname of the host to proxy the incoming connections. This value is onoy re

### STUNNEL_FORWARD_PORT

The port on the destination server to proxy the incoming connections.

### STUNNEL_LOG_LEVEL

The log level mode can be set to `warn` or `debug`

## config file

A config file is required to start stunnel process. This config file is passed as a command-line argument to stunnel command to start the process. The config file contains the information required for proxying the requests between postgres client and postgres server.

### server config file

This config file is used inside the sidecar container for the postgres cluster created by the postgres-operator. The sidecar container requires the CA certificate pem file to be mounted to `/server/ca.pem` path.

```
; log level. warn=4, debug=7
debug = 7
foreground = yes
[proxy]
accept = 0.0.0.0:15432
connect = localhost:5432
; the server-ca.pem contains the private key, server certificate, and the CA root certificate
cert = /server/ca.pem
```

### client config file

The client stunnel config file is used by the sidecar container in grpc microservices that connect to a postgres cluster running on on a planton cloud managed hosting environment.

```
; log level. warn=4, debug=7
debug = 7
foreground = yes
[proxy]
client = yes
accept = 0.0.0.0:5432
connect = <postgres-cluster-internal-or-external-endpoint>:5432
```

## gomplate

The [stunnel.config.gomplate](stunnel.conf.gomplate) is rendered by using [gomplate](https://docs.gomplate.ca/).

## testing

The template can be tested by sourcing the [env](test/env) file and running `gomplate` tool.

```shell
source test/env
gomplate --file stunnel.conf.gomplate
```

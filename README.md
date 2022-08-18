# stunnel

This docker image is to be used for runing sidecar container for microservices that require connectivity to postgres clusters which are running in planton cloud hosting environments to avoid StartTLS problem.

The docker image also includes a startup script that is required to setup the stunnel configuration file. The startup requires the following environment variables to be set to successfully generate the configuration file.

# environment variables

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

## client config file

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

## server config file

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

## gomplate

The [stunnel.config.gomplate](stunnel.conf.gomplate) is rendered by using [gomplate](https://docs.gomplate.ca/).

## testing

The template can be tested by sourcing the [env](test/env) file and running `gomplate` tool.

```shell
source test/env
gomplate --file stunnel.conf.gomplate
```

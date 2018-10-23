# Description

This container is based on the official Apache Nifi container.<br/>
Therefore this container is compliant with the [official container parameters](https://hub.docker.com/r/apache/nifi).

# Additional parameters

## Java heap size setting

You can define the Nifi java heap size with the environment variable: 

```
JAVA_HEAP_SIZE
```

## Container starting command

```shell
docker run --name nifi \
  -p 8080:8080 \
  -e JAVA_HEAP_SIZE=1g \
  -d \
  energiency/docker-nifi:1.7.1
```

# Example with ssl certificates and custom java heap size

## Certificate generation

The [Nifi toolkit](https://www.apache.org/dyn/closer.lua?path=/nifi/1.7.1/nifi-toolkit-1.7.1-bin.tar.gz) can be used in order to generate the certificates:

### Example

```shell
./bin/tls-toolkit.sh standalone \ 
    -n "localhost" \ 
    -C "CN=sys_admin, OU=NIFI" \ 
    -C "CN=check_user, OU=NIFI" \ 
    -o target
```

This command generates a `target` directory:

```shell
.
├── CN=check_user_OU=NIFI.p12
├── CN=check_user_OU=NIFI.password
├── CN=sys_admin_OU=NIFI.p12
├── CN=sys_admin_OU=NIFI.password
├── localhost
│   ├── keystore.jks
│   ├── nifi.properties
│   └── truststore.jks
├── nifi-cert.pem
└── nifi-key.key
```

You can find the certificates for the two users in the `p12` files:
- `CN=sys_admin, OU=NIFI`: CN=sys_admin_OU=NIFI.p12
- `CN=check_user, OU=NIFI`: CN=check_user_OU=NIFI.p12 

The `nifi.properties` file contains the ssl informations needed by the container to be run in ssl mode.

```properties
# security properties #
nifi.sensitive.props.key=
nifi.sensitive.props.key.protected=
nifi.sensitive.props.algorithm=PBEWITHMD5AND256BITAES-CBC-OPENSSL
nifi.sensitive.props.provider=BC
nifi.sensitive.props.additional.keys=

nifi.security.keystore=./conf/keystore.jks
nifi.security.keystoreType=jks
nifi.security.keystorePasswd=yCHw4aybJGSS8yeRE0mFP4YiKFes+RAgGwXYUm3Mr8s
nifi.security.keyPasswd=yCHw4aybJGSS8yeRE0mFP4YiKFes+RAgGwXYUm3Mr8s
nifi.security.truststore=./conf/truststore.jks
nifi.security.truststoreType=jks
nifi.security.truststorePasswd=BbyLAwMZo/BEugGO4MduokrGOreRA8qQpXWY+LLieE8
nifi.security.needClientAuth=
nifi.security.user.authorizer=managed-authorizer
nifi.security.user.login.identity.provider=
nifi.security.ocsp.responder.url=
nifi.security.ocsp.responder.certificate=
```

You must adapt the server name in order to be able to connect to nifi.

For more information, check you can check the [documentation](https://docs.hortonworks.com/HDPDocuments/HDF3/HDF-3.2.0/nifi-toolkit/hdf-nifi-toolkit.pdf)

## Container starting command

```shell
docker run --name secured-nifi \
  -v /certificate/location/target/localhost:/opt/certs \
  -p 8443:8443 \
  -e AUTH=tls \
  -e KEYSTORE_PATH=/opt/certs/keystore.jks \
  -e KEYSTORE_TYPE=JKS \
  -e KEYSTORE_PASSWORD=yCHw4aybJGSS8yeRE0mFP4YiKFes+RAgGwXYUm3Mr8s \
  -e TRUSTSTORE_PATH=/opt/certs/truststore.jks \
  -e TRUSTSTORE_PASSWORD=BbyLAwMZo/BEugGO4MduokrGOreRA8qQpXWY+LLieE8 \
  -e TRUSTSTORE_TYPE=JKS \
  -e INITIAL_ADMIN_IDENTITY='CN=sys_admin, OU=NIFI' \
  -e JAVA_HEAP_SIZE=1g \
  -d \
  energiency/docker-nifi:1.7.1
```


 
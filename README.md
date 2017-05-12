# Deepstream Docker and Marathon

for detailed information visit [Deepstream's Website](https://deepstream.io) and [Deepstream's Github Repo](https://github.com/deepstreamIO/deepstream.io-docker)

## Docker Information
<hr/>
CentOS v7<br/>
Deepstream v2.1.3-1

#### Installed and configured deepstream plugins
1. Redis for Message
2. Redis for Cache
3. MongoDB for Storage

## Run Deepstream on DC/OS
minimum configuration
```json
{
    "volumes": null,
    "id": "/deepstream-io",
    "cmd": null,
    "args": null,
    "user": null,
    "env": {
        "DEEPSTREAM_PORT": "6025",
        "MONGODB_CONNECTION_STRING": "mongodb://user:pass@mongo.mydomain.com:27017",
        "DEEPSTREAM_PASSWORD": "RGZG5Sz1Vs++MsNfGaWULaPboKTvTNdqxKFPlAnoSOQ=2dj6ms28tuAzVTbUaFhsNg==",
        "REDIS_CACHE_HOST": "redis1.mydomain.com",
        "REDIS_MSG_HOST": "redis2.mydomain.com"
    },
    "instances": 1,
    "cpus": 0.2,
    "mem": 256,
    "disk": 0,
    "gpus": 0,
    "backoffSeconds": 1,
    "backoffFactor": 1.15,
    "maxLaunchDelaySeconds": 3600,
    "container": {
        "docker": {
            "image": "rohithzr/deepstream.io:v5",
            "forcePullImage": true,
            "privileged": false,
            "portMappings": [{
                "containerPort": 6025,
                "protocol": "tcp"
            }],
            "network": "BRIDGE"
        }
    },
    "healthChecks": [{
        "protocol": "HTTP",
        "path": "/health-check",
        "gracePeriodSeconds": 300,
        "intervalSeconds": 60,
        "timeoutSeconds": 20,
        "maxConsecutiveFailures": 3,
        "ignoreHttp1xx": false
    }],
    "upgradeStrategy": {
        "minimumHealthCapacity": 1,
        "maximumOverCapacity": 1
    },
    "labels": {
        "HAPROXY_GROUP": "external,internal",
        "HAPROXY_0_VHOST": "deepstream.mydomain.com",
        "HAPROXY_0_REDIRECT_TO_HTTPS": "true"
    }
}
```


#### Use Dockerfile Directly
```sh
docker pull rohithzr/deepstream.io:v5
```
OR
```sh
FROM rohithzr/deepstream.io:v5
```

## Changing the Password

To generate the password hash you can use any deepstream installation with following config in `/etc/deepstream/config.yml`

```yaml
auth:
  type: file
  options:
    path: ./users.yml
    hash: 'sha256'
    iterations: 65536
    keyLength: 32
```
use this command to generate the hash
```sh
deepstream hash youPlainTextPassword@123
```

Default password is __p@123__

## Environment Variables Supported

Environment variables currently supported (self explanatory<br/>
Look at the Dockerfile for default values

```sh
DEEPSTREAM_PORT
DEEPSTREAM_HOST
REDIS_MSG_HOST
REDIS_MSG_PORT
REDIS_CACHE_HOST
REDIS_CACHE_PORT
MONGODB_CONNECTION_STRING
MONGODB_DATABASE
MONGODB_COLLECTION
MONGODB_SPLIT_CHAR
DEEPSTREAM_PASSWORD
```

## TODO

1. Dynamic Password Generation
2. Script to install more plugins
3. More control over plugins
Mulesoft Kernel 4 Community Edition - by Vertigo
=====

Esta imagem define um runtime mínimo do Mule Kernel, já contendo um endpoint "hello" publicado em `/opt/mule/apps`.

Este endpoint será considerado um healthcheck do container/pod.

## Como usar

1. Executar "as-is":

```sh
docker run --rm -ti -p 8081:8081 vertigo/mule
```

Testar com:

```sh
curl localhost:8081/hello
```

2. Montar volumes com deployments binários (JARs de apps)

```sh
docker run --rm -ti -p 8081:8081 \
  -v ./apps:/opt/mule/apps \
  vertigo/mule
```

## Volumes

Os volumes definidos nesta imagem são:

| Volume            | Description                           |
| ----------------- | ------------------------------------- |
| /opt/mule/apps    | Mule Application deployment directory |
| /opt/mule/domains | Mule Domains deployment directory     |
| /opt/mule/conf    | Configuration directory               |
| /opt/mule/logs    | Logs directory                        |


## Créditos

Algumas ideias deste container foram obtidas de projeto semelhante em https://github.com/javastreets/mule-docker-image.

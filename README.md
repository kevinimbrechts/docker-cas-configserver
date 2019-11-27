# Docker image for Apereo CAS ConfigServer in Alpine Linux
## Configuration
### Using CAS behind a proxy
#### Config files
If you want to use CAS ConfigServer behind a proxy, you have to create your own Docker Image based on this one, and create a `/cas-configserver-overlay/gradle.properties` file.

I have put an example in `samples` directory.

#### Dockerfile
Here is a sample of a `Dockerfile` including proxy config:
```Dockerfile
FROM kimbrechts/docker-cas-configserver:6.0.x

ARG http_proxy="http://your-user:changeit@your.proxy.net:9999"
ARG https_proxy="http://your-user:changeit@your.proxy.net:9999"
ARG no_proxy="localhost, 127.0.0.0/8, ::1, *.mydomain.com"

ENV http_proxy=${http_proxy} \
    HTTP_PROXY=${http_proxy} \
    https_proxy=${https_proxy} \
    HTTPS_PROXY=${https_proxy} \
    no_proxy=${no_proxy} \
    NO_PROXY=${no_proxy} \
...

COPY cas-configserver-overlay/gradle.properties /cas-configserver-overlay/gradle.properties
...
ENTRYPOINT ["./build.sh"]
CMD ["run"]
```

### Override config
Create `src/main/resources/application.properties` and `src/main/resources/bootstrap.properties` files to override default settings. I have put examples in `samples` directory.
You have to create your own `Dockerfile` and add these files with COPY command :
```Dockerfile
FROM kimbrechts/docker-cas-configserver:6.0.x
...
COPY cas-configserver-overlay/src /cas-configserver-overlay/src
...
ENTRYPOINT ["./build.sh"]
CMD ["run"]
```

### Setting the timezone
Create your own `Dockerfile` and put these lines :
```Dockerfile
FROM kimbrechts/docker-cas-configserver:6.0.x
...
RUN apk add --no-cache --virtual tz tzdata && \
    cp /usr/share/zoneinfo/Europe/Paris /etc/localtime && \
    echo "Europe/Paris" >  /etc/timezone && \
    apk del openssl tzdata
...
ENTRYPOINT ["./build.sh"]
CMD ["run"]
```
############################################
###     APEREO CAS Config Server 6.0     ###
############################################

FROM kimbrechts/docker-jdk-alpine:11.0.5

LABEL maintainer="imbrechts.kevin+cas@protonmail.com"

ENV LASTREFRESH="20191127" \
    PATH=$PATH:$JAVA_HOME/bin \
    GIT_BRANCH="master"

RUN apk update && \
    apk add --no-cache --virtual utils \
            git=2.22.0-r0 \
            bash=5.0.0-r0

# Download CAS configserver overlay project
WORKDIR /
RUN git clone --depth 1 --single-branch -b ${GIT_BRANCH} https://github.com/apereo/cas-configserver-overlay.git cas-configserver-overlay && \
    mkdir -p /etc/cas/config

# Permissions
RUN chmod 750 /cas-configserver-overlay/gradle/wrapper/gradle-wrapper.jar && \
    chmod 750 /cas-configserver-overlay/*.sh && \
    chmod 750 /opt/java-home/bin/java

# Cleaning
RUN apk del git && \
    rm -rf /cas-configserver-overlay/.git*

EXPOSE 8888

WORKDIR /cas-configserver-overlay

ENTRYPOINT ["./build.sh"]
CMD ["run"]

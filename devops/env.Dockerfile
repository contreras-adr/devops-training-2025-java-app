#
# Build stage
#
FROM maven:3.8.6-openjdk-11-slim
ARG VERSION=0.0.1-SNAPSHOT

COPY ./src /home/app/src
COPY ./pom.xml /home/app
COPY ./settings.xml /home/app

WORKDIR /home/app


RUN mvn versions:set -DnewVersion=${VERSION}



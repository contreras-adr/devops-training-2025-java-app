#
# Build stage
#
FROM maven:3.8.6-openjdk-11-slim as build
ARG SONAR_PROJECT_KEY
ARG SONAR_HOST
ARG SONAR_LOGIN_KEY

COPY ./src /home/app/src
COPY ./pom.xml /home/app

WORKDIR /home/app

RUN mvn test

RUN mvn sonar:sonar \
  -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
  -Dsonar.host.url=${SONAR_HOST} \
  -Dsonar.login=${SONAR_LOGIN_KEY}

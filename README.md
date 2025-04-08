# CI / CD Strategy with Docker

## Create Java APP Docker image
```bash
$ docker build -t scalian_training-java-hello-world-env:0.0.2-SNAPSHOT --build-arg VERSION=0.0.2-SNAPSHOT  -f devops/env.Dockerfile .
$ docker build -t scalian_training-java-hello-world:0.0.2  --build-arg VERSION=0.0.2-SNAPSHOT -f devops/Dockerfile .

$ docker run -d --rm -p 8085:8080  --name java-app   scalian_training-java-hello-world:0.0.2
$ curl localhost:8084/hello
$ docker stop java-app
$ 
```

## Verify sonarqube project
```bash
## Prevent next issue
#https://stackoverflow.com/questions/57998092/docker-compose-error-bootstrap-checks-failed-max-virtual-memory-areas-vm-ma
sudo sysctl -w vm.max_map_count=262144
docker-compose up -d sonarqube
docker-compose logs sonarqube

#Create project in sonarqube by accessing with the browser "localhost:9009"
# Project name: "devops-training-2025-java-app" 
docker networks ls
docker run \
    --rm  -w /app \
    -v "c:/Users/a.contreras/Documents/workspaces/training/scalian-devops-2024/2025/java-project-base:/app" \
    --network java-project-base_java-project-net \
    maven:3.8.6-openjdk-11-slim \
    mvn verify sonar:sonar \
    -Dsonar.projectKey=devops-training-2025-java-app \
    -Dsonar.host.url=http://172.16.234.10:9000 \
    -Dsonar.login=sqp_01291ee195139732bf0509b512c5f8dd4ccc8bf9

docker-compose down
```

## Deploy to nexus
```bash
# Check IAC network
docker network ls
docker build -t scalian_training-java-hello-world-env:0.0.2-SNAPSHOT --build-arg VERSION=0.0.2-SNAPSHOT  -f devops/env.Dockerfile .
docker run --rm \
    --network iac-devops-project-base_devops_training_net \
    scalian_training-java-hello-world-env:0.0.2-SNAPSHOT \
    mvn clean deploy -Dmaven.test.skip=true


docker-compose down
```

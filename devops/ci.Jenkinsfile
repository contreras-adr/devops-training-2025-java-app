#!groovy

//@Library('functions')_

pipeline {
	agent any // Default Agent

  parameters {
    string(name: 'version', defaultValue: getLastGitTag(), description: 'Docker Image Version')
  }

  environment {
      DOCKERHUB_CREDENTIALS=credentials('dockerhub-auth')
      DOCKERHUB_HOST="contrerasadr"
      IMAGE_VERSION="${params.version}"
      SONARQUBE_HOST_LOCAL="${env.SONARQUBE_HOST}"
      SONARQUBE_LOGIN="${env.SONARQUBE_HOST}"
      SONARQUBE_PROJECT="devops-training-2025-java-app"
    }

  
  stages {

    if (env.BRANCH_NAME == 'master') {
      stage('List env vars') {
        steps{
          sh "printenv | sort"
        }
      } 
     
    }
    
    stage('Unit Test && Sonnar') {
      // Specifies where the entire Pipeline, or a specific stage, will execute in the Jenkins environment depending on where the agent section is placed
    	agent {
          dockerfile {
              filename 'devops/env.Dockerfile'
              args '--build-arg VERSION=${IMAGE_VERSION}'
              reuseNode true
          }
      }
      steps {
      	sh 'mvn test'
        sh 'mvn verify sonar:sonar -Dsonar.projectKey="${SONARQUBE_JAVA_APP}" -Dsonar.host.url="${SONARQUBE_HOST_LOCAL}" -Dsonar.login="${SONARQUBE_LOGIN}"'
        
      }
      // post {
      //     failure {
      //         mail to: 'example@example.com',
      //             subject: 'Test failed',
      //             body: 'Test failed'
      //     }
      // }
    }

    stage('Maven Publish') {
      // Specifies where the entire Pipeline, or a specific stage, will execute in the Jenkins environment depending on where the agent section is placed
    	agent {
          dockerfile {
              filename 'devops/env.Dockerfile'
              args '--build-arg VERSION=${IMAGE_VERSION}'
              reuseNode true
          }
      }
      steps {
      	sh ' mvn clean deploy -Dmaven.test.skip=true'
        
      }
      // post {
      //     failure {
      //         mail to: 'example@example.com',
      //             subject: 'Test failed',
      //             body: 'Test failed'
      //     }
      // }
    }

    stage('Docker CI') {
        steps {
            sh 'docker build -t devops-training-2025-java-app --build-arg VERSION=$IMAGE_VERSION -f devops/local.Dockerfile .'
            sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            sh 'docker tag devops-training-2025-java-app $DOCKERHUB_HOST/devops-training-2025-java-app:$IMAGE_VERSION'
            sh 'docker push $DOCKERHUB_HOST/devops-training-2025-java-app:$IMAGE_VERSION'
        }
    }


    stage('Deploy DEV') {
      when {
        branch 'develop'
      }
      steps {
        build job: 'java-app-cd', parameters: [
          string(name: 'version', value: "${IMAGE_VERSION}"),
          string(name: 'environment', value: "DEV")
        ]
      }
      
    }

    stage('Deploy PRO') {
      when {
        branch 'master'
      }
      steps {
        echo 'Ready to deploy version "${IMAGE_VERSION}" in PRO'
          // mail to: 'example@example.com',
        //             subject: 'Ready to deploy version "${IMAGE_VERSION}" in PRO',
        //             body:  'Ready to deploy version "${IMAGE_VERSION}" in PRO. Press the next Link <LINK TO RUN CD JOB>'
      }
    }
  }

  post {
    always  {
      sh 'docker logout'
    }
    success {
      echo "SUCCESS"
    }
  }
  
}

def getLastGitTag() {
    sh "git tag --sort version:refname | head -n 1 > version.tmp"
    String tag = readFile 'version.tmp'
    echo "Branch: ${scm.branches[0].name}"
    echo "Tag, ${tag}." 
    return tag
}



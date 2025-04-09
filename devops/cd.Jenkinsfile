#!groovy

//@Library('functions')_

pipeline {
	agent any // Default Agent

  parameters {
    string(name: 'version', defaultValue: getLastGitTag(), description: 'Docker Image Version'),
    choice(name: 'environment', description: 'Environment', choices: ['DEV','PROD'])
  }

  environment {
      DOCKERHUB_CREDENTIALS=credentials('dockerhub-auth')
      DOCKERHUB_HOST="contrerasadr"
      IMAGE_VERSION="${params.version}"
      ENVIRONMENT="${params.environment}"
    }

  
  stages {

  
    stage('Docker PULL') {
        steps {
            sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            sh 'docker pull $DOCKERHUB_HOST/devops-training-2025-java-app:$IMAGE_VERSION'
        }
    }


    stage('Deploy DEV') {
      when {
          environment name: 'ENVIRONMENT', value: 'DEV'
      }
      steps {
        echo 'Deploying to DEV'
      }
    }

    stage('Deploy PRO') {
      when {
          environment name: 'ENVIRONMENT', value: 'PROD'
      }
      steps {
        echo 'Deploying to PRO'
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
    def result = tag ?: "0.0.1-Snapshot"
    echo "Tag, ${result}." 
    return result
}
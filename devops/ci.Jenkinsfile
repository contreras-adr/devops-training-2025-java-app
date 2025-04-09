#!groovy

//@Library('utils') _
//def utils = new org.scalian.Utils()

pipeline {
	agent any // Default Agent

  parameters {
    //function in iac-devops project "jenkins/functions.groovy"
    string(name: 'version', defaultValue: "0.0.1-SNAPSHOT"/*utils.getLastGitTag()*/, description: 'Docker Image Version')
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

    
    stage('Maven test & Install') {
      // Specifies where the entire Pipeline, or a specific stage, will execute in the Jenkins environment depending on where the agent section is placed
    	agent {
          dockerfile {
              filename 'devops/env.Dockerfile'
              additionalBuildArgs '--build-arg VERSION=${IMAGE_VERSION}'
              reuseNode true
          }
      }
      steps {
      	sh 'mvn test'
        // sh 'mvn verify sonar:sonar -Dsonar.projectKey="${SONARQUBE_JAVA_APP}" -Dsonar.host.url="${SONARQUBE_HOST_LOCAL}" -Dsonar.login="${SONARQUBE_LOGIN}"'
        // mvn clean deploy -Dmaven.test.skip=true
        sh 'mvn install'
        stash includes: './target/*.jar', name: 'app'
        
      }
      
      post {
          // failure {
          //     mail to: 'example@example.com',
          //         subject: 'Test failed',
          //         body: 'Test failed'
          // }
          always {
            archiveArtifacts artifacts: './target/*.jar', onlyIfSuccessful: true
           
        }
      }
    }

    

    stage('Docker CI') {
        steps {
            unstash 'app'
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
    def result = tag ?: "0.0.1-Snapshot"
    echo "Tag, ${result}." 
    return result
}


pipeline {
  agent any
  tools {
    maven 'Maven 3.8.3'
    jdk 'jdk8'
    dockerTool 'Docker'
  } 
  environment {
    dockerImage = ''
  }
  stages {
    stage('CHECKOUT') {
      steps {
        git branch: 'main', changelog: false, poll: false, url: 'https://github.com/qeqoos/spring-petclinic.git'
      }
    }
    stage('COMPILE') {
       steps {
          sh 'mvn compile' 
       }
    }
    stage('BUILD') {
      steps {
        sh 'mvn clean install'
          script {
            dockerImage = docker.build "qeqoos/spring-petclinic:latest"
           }
      }
    }
    stage('PUSH') {
        steps {
            script {
                docker.withRegistry( '', 'dockerHubCreds' ) {
                  dockerImage.push()
                }
            }
        }
    }
  }
}

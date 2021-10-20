pipeline {
  agent {
  label '!master'
  }
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
          def DOCKER_TAG = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
          dockerImage = docker.build "qeqoos/spring-petclinic:${DOCKER_TAG}"
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
    stage('REMOVE DANGLING IMAGES') {
       steps {
          sh 'docker system prune -f'
       }
    }
  }
}
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
  //   stage('CHECKOUT') {
  //     steps {
  //       git branch: 'main', changelog: false, poll: false, url: 'https://github.com/qeqoos/spring-petclinic.git'
  //     }
  //   }
    stage('COMPILE') {
       steps {
          sh 'mvn compile' 
       }
    }
    stage('BUILD AND PUSH') {
      steps {
        sh 'mvn clean install'
        script {
          env.DOCKER_TAG = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
          dockerImage = docker.build "qeqoos/spring-petclinic:${DOCKER_TAG}"
          docker.withRegistry( '', 'dockerHubCreds' ) {
              dockerImage.push()
          }
        }  
      }  
    }


    stage('CI deploy') {
        when {
            branch pattern: "dev|main", comparator: "REGEXP"
        }
        steps {
            ansiblePlaybook(
              playbook: 'ansible/deploy-ci-qa.yml',
              inventory: 'ansible/inv_aws_ec2.yml',
              disableHostKeyChecking: true,
              extras:  "-e passed_in_hosts=localhost -e tag=${DOCKER_TAG} -e needed_port=80 -e env=ci")
        }
    }

    stage('REMOVE DANGLING IMAGES') {
       steps {
          sh 'docker system prune -f'
       }
    }
  }
}
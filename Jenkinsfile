pipeline {
  agent any

  environment {
    DOCKER_IMAGE = "rajitha390/node-k8s-app:${BUILD_NUMBER}"
    DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
    KUBECONFIG_CREDENTIALS_ID = 'KUBECONFIG'
  }

  stages {
    stage('Checkout') {
      steps {
        git credentialsId: 'github-creds', url: 'https://github.com/rajitha690/k8s.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          docker.build(DOCKER_IMAGE)
        }
      }
    }

    stage('Push Docker Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          script {
            docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
              docker.image(DOCKER_IMAGE).push()
            }
          }
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        withCredentials([file(credentialsId: KUBECONFIG_CREDENTIALS_ID, variable: 'KUBECONFIG')]) {
          sh 'kubectl apply -f deployment.yaml'
          sh 'kubectl apply -f service.yaml'
        }
      }
    }
  }

  post {
    failure {
      echo 'Deployment failed. Consider checking the logs for more details.'
    }
  }
}

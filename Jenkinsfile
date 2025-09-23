pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        AWS_CREDS = credentials('aws-creds')
        IMAGE_NAME = "toufikj/dotnet-hello"
        BRANCH_NAME = "${env.BRANCH_NAME}"
    }
    parameters {
        choice(name: 'ENV', choices: ['UAT', 'PROD'], description: 'Choose deployment environment')
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: "https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git"
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $IMAGE_NAME:$BUILD_NUMBER .'
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push $IMAGE_NAME:$BUILD_NUMBER'
                }
            }
        }
        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@${ENV}_EC2_IP "docker pull $IMAGE_NAME:$BUILD_NUMBER && docker run -d -p 80:80 $IMAGE_NAME:$BUILD_NUMBER"
                    '''
                }
            }
        }
    }
}

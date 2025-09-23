pipeline {
    agent any
    environment {
        IMAGE_NAME = "toufikj/dotnet-hello"
        IMAGE_TAG  = "${BUILD_NUMBER}"
    }
    parameters {
        choice(name: 'ENV', choices: ['UAT', 'PROD'], description: 'Choose deployment environment')
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/toufikj/dotnet-hello-world.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
            }
        }
        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push $IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }
        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh '''
                        TARGET_IP=$([ "$ENV" = "UAT" ] && echo $UAT_EC2_IP || echo $PROD_EC2_IP)
                        ssh -o StrictHostKeyChecking=no ubuntu@$TARGET_IP "
                          docker pull $IMAGE_NAME:$IMAGE_TAG &&
                          docker stop dotnet || true &&
                          docker rm dotnet || true &&
                          docker run -d --name dotnet -p 80:80 $IMAGE_NAME:$IMAGE_TAG
                        "
                    '''
                }
            }
        }
    }
}

pipeline {
    agent any
    environment {
        IMAGE_NAME = "toufikj/dotnet-hello"
        IMAGE_TAG  = "${BUILD_NUMBER}"
        CONTAINER_NAME = "dotnet"
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
        stage('Deploy on Jenkins Master') {
            steps {
                sh '''
                    echo "Stopping old container (if running)..."
                    docker stop $CONTAINER_NAME || true
                    docker rm $CONTAINER_NAME || true

                    echo "Running new container..."
                    docker run -d --name $CONTAINER_NAME -p 5000:5000 $IMAGE_NAME:$IMAGE_TAG
                '''
            }
        }
        stage('Health Check') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh '''
                        TARGET_IP=$([ "$ENV" = "UAT" ] && echo $UAT_EC2_IP || echo $PROD_EC2_IP)
                        echo "Checking health on $TARGET_IP:5000/hello ..."
                        for i in {1..5}; do
                          if curl -s http://$TARGET_IP:5000/hello | grep -q "Hello"; then
                            echo "Health check passed!"
                            exit 0
                          fi
                          echo "Waiting for app... attempt $i"
                          sleep 5
                        done
                        echo "Health check failed!"
                        exit 1
                    '''
                }
            }
        }
    }
}


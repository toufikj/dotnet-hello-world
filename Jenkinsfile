pipeline {
    agent any
    environment {
        IMAGE = "${IMAGE_NAME}:${BUILD_NUMBER}"
    }
    parameters {
        choice(name: 'ENV', choices: ['UAT', 'PROD'], description: 'Choose deployment environment')
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: "https://github.com/<your-github-username>/dotnet-hello-world-fork.git"
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE .'
            }
        }
        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push $IMAGE
                    '''
                }
            }
        }
        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh '''
                        if [ "$ENV" = "UAT" ]; then
                          TARGET=$UAT_EC2_IP
                        else
                          TARGET=$PROD_EC2_IP
                        fi
                        ssh -o StrictHostKeyChecking=no ubuntu@$TARGET "docker pull $IMAGE && docker stop dotnet || true && docker rm dotnet || true && docker run -d --name dotnet -p 80:80 $IMAGE"
                    '''
                }
            }
        }
    }
}

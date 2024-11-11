pipeline {
    agent any   
    environment {
        DOCKER_IMAGE = "parthitk/d2k:${BUILD_NUMBER}"
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub')
    }   
    stages {
        stage('Clone Code') {
            steps {
                echo "scm checkout"
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "docker-hub") {
                        docker.image("${DOCKER_IMAGE}").push()
                    }
                }
            }
        }
        stage ('pull the code'){
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "docker-hub") {
                        def image = docker.image("${DOCKER_IMAGE}")
                        image.pull()
                    }
                }
            }
        }
        stage ('deploy') {
            steps {
                sh 'docker run -itd --name cont1 -p 1010:5000 ${DOCKER_IMAGE}'
            }
        }
       
    }
}


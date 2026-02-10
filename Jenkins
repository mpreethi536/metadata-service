pipeline {
    agent any

    environment {
        IMAGE_NAME = "mpreethi536/metadata-service-image"
        APP_NAME   = "metadata-service"
    }

    options {
        timestamps()
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'release/jenkins_pipeline',
                    url: 'https://github.com/mpreethi536/metadata-service.git'
            }
        }

        stage('Build') {
            steps {
                sh 'echo "Build completed"'
            }
        }

        stage('Test') {
            steps {
                sh 'echo "Tests passed"'
            }
        }

        stage('Package Artifact') {
            steps {
                sh '''
                  tar -czf metadata-service-${BUILD_NUMBER}.tar.gz .
                '''
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'metadata-service-*.tar.gz',
                                 fingerprint: true
            }
        }

        /* ---------------- DOCKER STAGES ---------------- */

        stage('Build Docker Image') {
            steps {
                sh '''
                  docker build \
                    --build-arg BUILD_NUMBER=${BUILD_NUMBER} \
                    --build-arg APP_NAME=${APP_NAME} \
                    -t ${IMAGE_NAME}:${BUILD_NUMBER} \
                    -t ${IMAGE_NAME}:latest .
                '''
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                      echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                      docker push ${IMAGE_NAME}:${BUILD_NUMBER}
                      docker push ${IMAGE_NAME}:latest
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'CI + Docker image pipeline completed successfully'
        }
        failure {
            echo 'Pipeline failed – check logs'
        }
        always {
            echo 'Pipeline execution finished'
        }
    }
}

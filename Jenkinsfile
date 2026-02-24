pipeline {
    agent any

    environment {
        IMAGE_NAME = "preethi536/metadata-service-image"
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
                sh 'mvn clean compile'
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Code Format Check') {
            steps {
                sh 'mvn checkstyle:check || true'
            }
        }

        stage('Static Code Analysis') {
            steps {
                sh 'mvn verify'
            }
        }

        stage('Secret Scan (Gitleaks)') {
            steps {
                sh 'gitleaks detect --source=. || true'
            }
        }

        stage('Package') {
            steps { 
                sh 'mvn package -DskipTests' 
            }
        }
        
        stage('Archive Jar') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar',
                                 fingerprint: true
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh '''
                  docker build \
                    --build-arg BUILD_NUMBER=${BUILD_NUMBER} \
                    -t ${IMAGE_NAME}:${BUILD_NUMBER} \
                    -t ${IMAGE_NAME}:latest .
                '''
            }
        }

        stage('Docker Image Scan (Trivy)') {
            steps {
                sh '''
                docker run --rm \
                  -v /var/run/docker.sock:/var/run/docker.sock \
                  aquasec/trivy image \
                  --exit-code 1 \
                  --severity HIGH,CRITICAL \
                  --format json \
                  --output trivy-report.json \
                  ${IMAGE_NAME}:${BUILD_NUMBER} || true
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
        stage('Deploy via Ansible') {
            steps {
                sh '''
                  ansible-playbook ansible/playbook.yml \
                    -i ansible/inventory.ini \
                    --extra-vars "build_number=${BUILD_NUMBER}"
                '''
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

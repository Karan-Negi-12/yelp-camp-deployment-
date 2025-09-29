pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-access-token')
        SCANNER_HOME= tool 'sonar-scanner'
    }
    tools {
        nodejs "node22"
        nodejs "node18"
    }

    stages {
        stage('Git Checkout') {
            steps {
                echo "Cloning the repository from GitHub"
                git url: 'https://github.com/Karan-Negi-12/3-Tier-Application-Deplyoment.git', branch: 'master'
            }
        }

        stage('Installing the Dependencies of The Application') {
            steps {
                echo 'Installing Dependencies....'
                sh 'npm install'
            }
        }

        stage('Running Test Cases') {
            steps {
                echo 'Running Test Cases....'
                sh 'npm test'
            }
        }

        stage('Docker Info Before Build') {
            steps{
                sh '''
                docker version
                docker info
                docker compose version
                curl --version
                jq --version
                '''
            }
        }

        stage('Running Trivy FS Scan') {
            steps {
                echo 'Generating Trivy FS Scan Report....'
                sh "trivy fs --format table -o trivy-fs-html . "
            }
        }
        stage('SonarQube Scan') {
            steps {
                echo 'Running SonarQube Scan....'
                withSonarQubeEnv('sonar'){
                    sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=3-Tier-Application-Deplyoment -Dsonar.projectName=3-Tier-Application-Deplyoment" 
                }
            }
        }
        stage('Docker Image Build') {
            steps {
                echo 'Building the Docker Image From Dockerfile'
                script {
                    env.IMAGE_TAG = "v0.${env.BUILD_NUMBER}"
                    sh "docker build -t devopskarannegi/3-tier-application:v0.${env.BUILD_NUMBER} . "
                }
            }
        }

        stage('Docker Image Scan with Trivy') {
            steps {
                echo 'Scanning Docker Image with Trivy'
                script{
                    sh "trivy image --format table -o trivy-image-html devopskarannegi/3-tier-application:${env.IMAGE_TAG}"
                }
            }
        }
        stage('Docker Image test') {
            steps{
                script {
                    sh "docker run -d -p 3000:80 --name test-container devopskarannegi/3-tier-application:${env.IMAGE_TAG}"
                    sh 'sleep 10'
                    sh "curl -f http://localhost:80 || exit 1"
                }
            }
        }

        stage('Docker Image Push to Docker Hub') {
            steps { 
                script {
                    echo 'Pushing the Docker Image to Docker Hub'
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin' 
                    sh "docker push devopskarannegi/3-tier-application:${IMAGE_TAG}"
                    sh 'docker logout'
                }
            }
        }
    }
    post {
        always {
            echo 'Cleaning up the workspace...'
            sh 'docker rm -f test-container || true'
            
        }
        success {
            echo 'The pipeline has completed successfully!'
        }
        failure {
            echo 'The pipeline has failed. Please check the logs for details.'
        }
    }
}

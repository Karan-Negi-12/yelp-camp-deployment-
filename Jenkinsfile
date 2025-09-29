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
                git url: 'https://github.com/Karan-Negi-12/yelp-camp-deployment-.git', branch: 'main'
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

        stage('Running Trivy File System Scan') {
            steps {
                echo 'Generating Trivy FS Scan Report....'
                sh "trivy fs --format table -o trivy-fs-html . "
            }
        }
        stage('SonarQube Scan') {
            steps {
                echo 'Running SonarQube Scan....'
                withSonarQubeEnv('sonar'){
                    sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=yelp-camp-deployment -Dsonar.projectName=yelp-camp-deployment" 
                }
            }
        }
        stage('Docker Image Build') {
            steps {
                echo 'Building the Docker Image From Dockerfile'
                script {
                    env.IMAGE_TAG = "v0.${env.BUILD_NUMBER}"
                    sh "docker build -t devopskarannegi/yelp-camp-deployment:v0.${env.BUILD_NUMBER} . "
                }
            }
        }

        stage('Docker Image Scan with Trivy') {
            steps {
                echo 'Scanning Docker Image with Trivy'
                script{
                    sh "trivy image --format table -o trivy-image-html devopskarannegi/yelp-camp-deployment:${env.IMAGE_TAG}"
                }
            }
        }
        stage('Docker Image test') {
            steps{
                script {
                    sh "docker run -d -p 3000:3000 --name test-container devopskarannegi/yelp-camp-deployment:${env.IMAGE_TAG}"
                    sh 'sleep 10'
                    sh "curl -f http://localhost:3000 || exit 1"
                }
            }
        }

        stage('Docker Image Push to Docker Hub') {
            steps { 
                script {
                    echo 'Pushing the Docker Image to Docker Hub'
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin' 
                    sh "docker push devopskarannegi/yelp-camp-deployment:${IMAGE_TAG}"
                    sh 'docker logout'
                }
            }
        }  
        stage('Deploy to Kubernetes Cluster') {
            steps {
                echo "Deploying the Application to Kubernetes Cluster"
                withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'k8-token', namespace: 'webapp', restrictKubeConfigAccess: false, serverUrl: 'https://10.0.0.5:6443') {
                sh "kubectl apply -f dss.yml"
                sleep 60 
            }
            }
        }
        stage('Verifying the deplyoment to Kubernetes Cluster') {
            steps {
                echo "checking the deployment to Kubernetes Cluster"
                withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'k8-token', namespace: 'webapp', restrictKubeConfigAccess: false, serverUrl: 'https://10.0.0.5:6443') {
                sh "kubectl get pods -n webapp"
                sh "kubectl get svc -n webapp"
            }
            }
        } 

    }
    post {
        always {
            echo 'Cleaning up the workspace...'
            sh 'docker rm -f test-container || true'
            script {
                def jobName = env.JOB_NAME
                def buildNumber = env.BUILD_NUMBER
                def pipelineStatus = currentBuild.result ?: 'UNKNOWN'
                def bannerColor = pipelineStatus.toUpperCase() == 'SUCCESS' ? 'green' : 'red'

                def body = """
                <html>
                <body>
                <div style="border: 4px solid ${bannerColor}; padding: 10px;">
                    <h2>${jobName} - Build ${buildNumber}</h2>
                    <div style="background-color: ${bannerColor}; padding: 10px;">
                        <h3 style="color: white;">Pipeline Status: ${pipelineStatus.toUpperCase()}</h3>
                    </div>
                    <p>Check the <a href="${BUILD_URL}">console output</a>.</p>
                </div>
                </body>
                </html>
                """

                emailext(
                    subject: "${jobName} - Build ${buildNumber} - ${pipelineStatus.toUpperCase()}",
                    body: body,
                    to: 'knegi2003@gmail.com',
                    from: 'jenkins@gmail.com',
                    replyTo: 'jenkins@gmail.com',
                    mimeType: 'text/html'
                )
            } 
        }
        success {
            echo 'The pipeline has completed successfully!'
        }
        failure {
            echo 'The pipeline has failed. Please check the logs for details.'
        }
    }
}


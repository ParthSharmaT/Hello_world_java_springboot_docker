pipeline {
    agent any
    parameters {
        choice(name: 'Environment', choices: ['Dev', 'Prod'], description: 'Select the environment to deploy')
    }
    tools {
    maven 'Maven3'
    }
    environment {
        SONAR_HOST_URL = 'https://sonarcloud.io'
        SONAR_TOKEN=credentials('sonarcloud-token')
        DOCKER_IMAGE = "hacktom007/hello-world-springboot-${params.Environment.toLowerCase()}:${env.BUILD_ID}"
        ARTIFACTORY_REPO = "java-project-repo"
        APP_PORT = "${params.Environment == 'Dev' ? '8083':'8084'}"
        ARTIFACTORY_SERVER_ID='Artifactory'
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: "${params.Environment}", url: 'https://github.com/ParthSharmaT/Hello_world_java_springboot_docker.git'
            }
        }
        stage('Build Application') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
         stage('Execute Sonar Analysis') {
            environment {
                scannerHome = tool 'Sonar'
            }
            steps {
                script {
                    withSonarQubeEnv('Sonar') {
                      sh "mvn clean verify sonar:sonar -Dsonar.projectKey=JenkinsProject -Dsonar.projectName='JenkinsProject'"
                    }
                }
            }
        }
        stage('Upload Artifacts to Artifactory') {
            steps {
                rtUpload serverId: env.ARTIFACTORY_SERVER_ID, spec: '''{
                    "files": [
                        {
                            "pattern": "target/*.jar",
                            "target": "${ARTIFACTORY_REPO}/"
                        }
                    ]
                }'''
                rtPublishBuildInfo serverId: env.ARTIFACTORY_SERVER_ID
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }
        stage('Push Docker Image') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: 'https://index.docker.io/v1/']) {
                    sh 'docker push $DOCKER_IMAGE'
                }
            }
        }
        stage('Deploy Application') {
            steps {
                script {
                    def containerName = "hello-world-${params.Environment.toLowerCase()}"
                    sh """
                    # Stop and remove the container if it already exists
                    docker ps -q --filter "name=${containerName}" | grep -q . && docker stop ${containerName} && docker rm ${containerName} || true
                    
                    # Run a new container with the appropriate port
                    docker run -d --name ${containerName} -p ${APP_PORT}:${APP_PORT} $DOCKER_IMAGE --server.port=${APP_PORT}
                    """
                }
            }
        }
    }
    post {
        success {
            mail to: 'parthsharmatanguriya@gmail.com',
                 subject: "Jenkins Pipeline: ${params.Environment} Deployment Successful",
                 body: "The ${params.Environment} environment has been successfully deployed.\\nURL: http://localhost:${APP_PORT}/testapp"
        }
        failure {
            mail to: 'parthsharmatanguriya@gmail.com',
                 subject: "Jenkins Pipeline: ${params.Environment} Deployment Failed",
                 body: "The ${params.Environment} deployment has failed. Please check the Jenkins logs for more details."
        }
    }
}

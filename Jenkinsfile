pipeline {
    agent any
    tools {
        maven 'Maven 3.x'
    }

    environment {
        SONARQUBE_URL = 'http://localhost:9000'
        SONARQUBE_TOKEN = credentials('sonarqube-api-token')
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOCKER_IMAGE = 'puranikhanjan307/springboot'
    }

    parameters {
        string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'Tag of the Docker image to fetch from Docker Hub')
        string(name: 'RUN_COMMAND', defaultValue: 'java -jar /app/app.jar', description: 'Command to run inside the Docker container')
    }

    stages {
        stage('SCM') {
            steps {
                git url: 'https://github.com/Khanjanpurani/CI-CD-pipeline-with-jenkins-maven-and-SonarQube.git', branch: 'main'
            }
        }

        stage('Build') {
            steps {
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    def app = docker.build("${env.DOCKER_IMAGE}:${env.BUILD_ID}")
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub') {
                        app.push("${env.BUILD_ID}")
                        app.push('latest')
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    bat "mvn clean verify sonar:sonar -Dsonar.projectKey=your-project-key -Dsonar.host.url=${env.SONARQUBE_URL} -Dsonar.login=${env.SONARQUBE_TOKEN}"
                }
            }
        }

        stage('Publish') {
            steps {
                archiveArtifacts artifacts: '**/target/*.jar', allowEmptyArchive: true
            }
        }

        stage('Run Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub') {
                        def app = docker.image("${env.DOCKER_IMAGE}:${params.IMAGE_TAG}")
                        app.pull()
                        app.inside {
                            bat "${params.RUN_COMMAND}"
                        }
                    }
                }
            }
        }
    }
}

pipeline {
    agent any
    
    tools {
        maven 'Maven 3.x'
    }
    
    environment {
        SONARQUBE_SERVER = 'SonarQube'
    }
    
    stages {
        stage('SCM') {
            steps {
                git url: 'https://github.com/Khanjanpurani/CI-CD-pipeline-with-jenkins-maven-and-SonarQube.git', branch: 'main'
            }
        }
        
        stage('Build') {
            steps {
                bat 'mvn clean package'
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    bat 'mvn sonar:sonar'
                }
            }
        }
        
        
        stage('Packaging') {
            steps {
                bat 'mvn package'
            }
        }
        
        stage('Publish') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', allowEmptyArchive: true
            }
        }
        
        stage('Deploy') {
            steps {
                 bat 'mvn spring-boot:run &'
                 bat 'sleep 10'
            }
        }
    }
}

pipeline {
    agent any

    tools {
        jdk 'jdk-11'
        maven 'maven'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git changelog: false, poll: false, url: 'https://github.com/kapilgurjarr/project_1.git'
            }
        }

        stage('Code Compile') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Check Artifact') {
            steps {
                sh 'test -f webapp/target/webapp.war || { echo "Error: webapp.war not found"; exit 1; }'
            }
        }

        stage('Unit-Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('OWASP Scan') {
            steps {
                script {
                    dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'DP'
                    dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
                }
            }
        }

        stage('Build Artifact') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'b67280b3-a67a-4690-8ca6-e700ba006754') {
                        sh 'docker build -t project_1:latest -f Dockerfile .'
                        sh 'docker tag project_1:latest kapilgurjar/techblog_p:latest'
                        sh 'docker push kapilgurjar/techblog_p:latest'
                    }
                }
            }
        }
        
        stage('Docker Deploy') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'b67280b3-a67a-4690-8ca6-e700ba006754') {
                        sh 'docker run -d --name project_1 -p 8080:80 kapilgurjar/techblog_p:latest'
                    }
                }
            }
        }
        
        stage('Deploy to tomcat') {
            steps {
                sh 'cp /var/lib/jenkins/workspace/project1/webapp/target/webapp.war /usr/local/tomcat/webapps'
            }
        }
    }
}

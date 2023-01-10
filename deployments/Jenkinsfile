pipeline {
    agent any
    tools {
        go '1.18.3'
    }
    stages {
        stage('build service') {
            steps {
                sh 'go build cmd/app/main.go'
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
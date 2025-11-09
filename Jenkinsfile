pipeline {
    agent any

    stages {
        stage('Git checkout') {
            steps {
                git branch: 'branch1', url: 'https://github.com/prasad5d/jenkins-project-3.git'
            }
        }
       }

        stage('teraform destroy') {
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }
    }
}

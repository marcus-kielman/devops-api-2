pipeline{
    agent any 
    stages{
        stage('Clean workspace') {
            deleteDir()
            sh 'ls -lah'
        }
        stage('Setting Up Testing Environment'){
            steps{
                sh '''ansible-playbook -u marcus /playbooks/env-playbook.yml -v'''
            }
        }
        stage('Run Linting and Connection Tests'){
            steps{
                sh "ansible-playbook -u marcus /playbooks/test-playbook.yml -v"
            }
        }
        stage('Push To DockerHub and Trigger Deployment'){
            steps{
                sh "ansible-playbook -u marcus /playbooks/kube-playbook.yml -v"
            }
        }
    }
}

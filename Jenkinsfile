pipeline{
    agent any 
    stages{
        stage('Setting Up Testing Environment'){
            steps{
                sh "pwd"
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

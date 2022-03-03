# DevOps Case Study 2 v0.0.1
## DevOps Provisioned and Monitored API

This repository is a continuation of the DevOps Case Study repository. In addition to API and MariaDB communication from the previous repository, Terraform and Elastic Cloud are used for provisioning and monitoring our Kubernetes cluster.

The overall goal of this project is to provide a more simplified way to alert an operator of when the previous architecture needed more replicas or was using too many replicas. Overall assisting to make continuous monitoring and provisioning more optimal.

## Features

- Send GET requests to retrieve the database table, payments table, customers table, and offices table
- Send POST requests to insert a new row into the customers table and payments table
- Allow Provisioning to scale up and down replicas in kubernetes cluster


## Requirements for compatibility

The API requires Python 3.9 for API functionality. The following libraries needed can be found in the requirements.txt file and npm 7.13.0+, along with Python 3.8 and pip 20.0.2, and the following libraries for both Node.js, and Python 3.8 in your virtual environment

| Python                  
| ------                  
| certifi==2021.10.8
| charset-normalizer==2.0.10
| click==8.0.3
| flake8==4.0.1
| Flask==2.0.2
| greenlet==1.1.2
| idna==3.3
| itsdangerous==2.0.1
| Jinja2==3.0.3
| mariadb==1.0.9
| MarkupSafe==2.0.1
| marshmallow==3.14.1
| mccabe==0.6.1
| pycodestyle==2.8.0
| pyflakes==2.4.0
| requests==2.27.1
| urllib3==1.26.8
| Werkzeug==2.0.2        

At the time of development, this API is compatible with any Linux distribution.
Python libraries can be installed using the command

```
pip install -r requirements.txt
```

## Architecture Components
![diagram](https://raw.githubusercontent.com/marcus-kielman/devops-api-2/master/screenshots/Blank%20diagram.png)
### pipenv
For Development, a Pipfile has been provided for utilizing pipenv. You can access
this environment using the command ```$ pipenv shell```

### Docker
Docker is used to containerize the API and MariaDB Database independently. MariaDB image has been modified to provide mysqlsampledatabase.sql file. For more information please see the [devops_api] (https://github.com/marcus-kielman/devops-api-2) repository.

### Jenkins and Ansible
![jenkins-build](https://raw.githubusercontent.com/marcus-kielman/devops-api-2/master/screenshots/Jenkins%20build.png)

A docker image marcuskielman/jenkans was created to run Jenkins and Ansible to remotely run CI/CD and IaC. For this reason much of testing is remotely done outside the container. To accomplish this a private key must be generated on your target machine and stored in ```~/.ssh/authorized keys```.

### Kubernetes
![kubernetes](https://raw.githubusercontent.com/marcus-kielman/devops-api-2/master/screenshots/kubectl%20monitor.png) 

The API and database were deployed to a Kubernetes cluster to assist with load balancing. It works in tandem with Terraform to increase the number of replicant API pods and horizontally scaling up and down our architecture.

### Terraform and ELK (Elastic Cloud)
![System-Monitor](https://raw.githubusercontent.com/marcus-kielman/devops-api-2/master/screenshots/Monitor%201.png)
Terraform was used to provision the Kubernetes cluster and provide different modules that assist to deploy the cluster. The default module creates 3 replicas of the API pod while scaling up and down increases and/or decreases the number of pods by 2. Elastic Cloud, the online version of the ELK stack was utilized to monitor the system's CPU, Memory, and Network Traffic

## Monitoring Process and Setup
![htop](https://raw.githubusercontent.com/marcus-kielman/devops-api-2/master/screenshots/htop.png)
The minikube dashboard gives insight of the amount of CPU, Memory, and Network traffic used by the Kubernetes Cluster, while the CPU and Memory Dashboard informs the overall CPU, Memory, and Network Traffic usage in the overall machine. Alerts have been set up to check when the outbound traffic exceeds a certain threshold for a certain period of time. This way when an operator receives an alert, they know to scale up the architecture
![minikube](https://raw.githubusercontent.com/marcus-kielman/devops-api-2/master/screenshots/minikube%20monitor.png)
![alert](https://raw.githubusercontent.com/marcus-kielman/devops-api-2/master/screenshots/Slack%20Alerts.png)
## Interface Controls
The main interface for the application is the ```curl``` command in Linux. This can be installed using ```sudo apt install curl```. 
The following urls are used to send GET and POST requests to the API Docker Containers:

        http://localhost:8081  ----------------------------------> GET main page to API
        http://localhost:8081/get_database_table ----------------> GET all database table rows
        http://localhost:8081/get_database_table/customers ------> GET all customers table rows and POST new row
        http://localhost:8081/get_database_table/payments -------> GET all payments table rows and POST new row
        http://localhost:8081/get_database_table/offices --------> GET all offices table rows

## Application Architecture
### Project Folder Structure

```bash
├── devops_api
│   ├── api
|   |   ├── model
|   |   |   ├── customers.py
|   |   |   ├── offices.py
|   |   |   ├── payments.py
|   |   |   └── tables.py
│   │   └── mxk_api.py
│   ├── kube_files
|   |   ├── api_kube.yml
|   |   ├── api_maria_kube.yml
│   ├── playbooks
|   |   ├── env-playbook.yml
|   |   ├── kube-playbook.yml
|   |   ├── test-playbook.yml
|   ├── terraform_modules
|   |   ├── default_api
|   |   ├── scale_down_api
|   |   ├── scale_up_api
│   ├── test_files
|   |   ├── api_test.py
|   |   ├── kube_test.py
|   |   ├── kube-run.sh
|   |   ├── del-docker-entries.sh
|   |   └── del-test-entries.sh
|   |
│   ├── Dockerfile
│   ├── Jenkinsfile
│   ├── mysqlsampledatabase.sql
│   ├── Pipfile
│   ├── requirements.txt
│   ├── env-playbook.yml
│   ├── kube-playbook.yml
│   └── README.md

```

## Testing
![testing](https://raw.githubusercontent.com/marcus-kielman/devops-api-2/master/screenshots/test_deployment.png)
The following Python files have been created as unit tests for Docker containers (```api_test.py```) and Kubernetes pods (```kube_test.py```). ```api_test.py``` can also be used as general unit testing during development. Both can be run using the command ```python3 kube_test.py``` or alternatively ```python3 api_test.py```

### Testing Cleanup
The following shell scripts ```del-docker-entries.sh``` and ```del-test-entries.sh``` are used to remove rows in the database added for testing the docker containers and kubernetes pods respectively. They can be run as executable files through the terminal.

## Ansible Environment Setup and Deployment
There are three playbooks used for creating the testing environment, and deploying to kubernetes. When running CI/CD testing in Jenkins, the ```env-playbook.yml``` playbook is used to install necessary packages and libraries for testing docker container functionality and Python linting testing along with building the docker image. On success, the ```kube-playbook.yml``` playbook is used to determine if pods are already created or not, and trigger the initial Terraform provisioning. An additional ```test-playbook.yml``` file was created to run testing during the staging phase.

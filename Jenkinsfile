pipeline {
    agent any

 environment {
        access = credentials('access')
        secret = credentials('secret')
    }


    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/munidop/copilot_cicd_code.git'
            }
        }

        stage('Terraform Init and Apply') {
            steps {
                dir('terraform') {
		#export AWS_ACCESS_KEY_ID=$access
                #export AWS_SECRET_ACCESS_KEY=$secret
			#export AWS_REGION="eu-west-1"
                    sh 'terraform init'
                    sh 'terraform apply --auto-approve'
                }
            }
        }
				
        stage('Ansible Deployment') {
            steps {
                dir('ansible') {
                    sh 'ansible-playbook playbook.yaml'
                }
            }
        }

        stage('Test Ansible Deployment') {
            steps {
                dir('ansible') {
                    sh 'ansible-playbook playtest.yaml'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t flask-app:latest .'
            }
        }

        stage('Deploy Flask App to EKS') {
            steps {
                dir('manifest') {
                    sh 'kubectl apply -f deploy.yaml'
                    sh 'kubectl get all'
                }
            }
        }
    }
}

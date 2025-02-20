pipeline {
    agent any
	environment{
     
      dockeruser = "${params.dockeruser}"
      dockerpass = "${params.dockerpass}"
  }



    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/jaya-narayana2205/copilot_cicd_code.git'
            }
        }

        stage('Terraform Init and Apply') {
            steps {
                dir('terraform') {
		
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
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
                sh 'docker build -t flask-app .'
		sh 'docker image list'
		sh 'docker tag flask-app ${dockeruser}/flask-app:latest'
            }
        }
	stage("Push Image to Docker Hub"){
      steps{
         withCredentials([string(credentialsId: 'DOCKER_HUB_CREDENTIALS', variable: 'PASSWORD')]){
            sh 'docker login -u ${dockeruser} -p ${dockerpass}'
           sh 'docker push ${dockeruser}/flask-app:latest	'
           
         }
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

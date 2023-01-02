pipeline {
  agent  any
  environment {
    accountid = "304051859177"
    module = "Terraform"
    }
  parameters {
    choice(
      choices: ['apply' , 'destroy'],
      description: '',
      name: 'REQUESTED_ACTION'
    )
  }
  stages {

   	stage ('Checkout SCM'){
      	steps {
        	git 'https://github.com/rsivaseshu/ansible-terraform.git'
      	}
    	}
  
    stage('Set Terraform path') {
     	steps {
       	script {
          def tfHome = tool name: 'terraform'
          env.PATH = "${tfHome}:${env.PATH}"
       	}
   		}
		}
  	stage('terraform init') {
 	    steps {
        dir (module) {
          sh 'terraform init -no-color'
        }
      }
    }
  	stage('terraform Plan') {
      steps {
        dir (module) {     
          sh 'terraform plan -no-color -out=plan.out'
          }
      }
    }
		stage('Waiting for Approvals') {
      when {
        // Only executed destroy is requested
        expression { params.REQUESTED_ACTION == 'apply' }
      }
    	steps{
      	input('Plan Validated? Please approve to create VPC Network in AWS?')
			}
    }    
		stage('terraform Apply') {
     	steps {
        dir (module) {
          sh 'terraform apply -no-color -auto-approve plan.out'
          sh "terraform output"
        }    
      }
    }
    stage('terraform Destroy') {
      when {
        // Only executed destroy is requested
        expression { params.REQUESTED_ACTION == 'destroy' }
      }
     	steps {
        dir (module) {
          sh 'terraform destroy -no-color -auto-approve '
          sh "terraform output"
        }    
      }
    }
    stage('sleep'){
      steps {
        sleep 120
      }
    }
    stage('ansible deployment'){
      when {
        // Only executed destroy is requested
        expression { params.REQUESTED_ACTION == 'apply' }
      }
      steps {
        dir('Ansible'){
          ansiblePlaybook become: true, credentialsId: 'ansible-key', disableHostKeyChecking: true, installation: 'ansible', inventory: '/etc/ansible/hosts', playbook: 'nginx.yaml'
        }
      }
    }
  }
}
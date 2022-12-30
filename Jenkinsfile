pipeline {
  agent  any
  environment {
    accountid = "304051859177"
    module = "Terraform"
    }
  parameters {
    choice(
      choices: ['destroy' , 'keep'],
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
    stage('ansible deployment'){
      steps {
        dir('Ansible'){
          sh 'ansible-playbook -i /opt/ansible/inventory/aws_ec2.yaml apache.yaml '
        }
      }
    }
  }
}
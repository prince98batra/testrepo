pipeline {
    agent any

    tools {
        terraform 'Terraform'
        ansible 'Ansible'
    }

    environment {
        TF_VAR_region = 'us-east-1'
        TF_VAR_key_name = 'mykey'
        TF_IN_AUTOMATION = 'true'
        ANSIBLE_HOST_KEY_CHECKING = 'False'
        ANSIBLE_REMOTE_USER = 'ubuntu'
    }

    stages {
        stage('Terraform Init') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    dir('prometheus-terraform') {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    dir('prometheus-terraform') {
                        sh 'terraform validate'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    dir('prometheus-terraform') {
                        sh 'terraform plan'
                    }
                }
            }
        }

        stage('User Input - Choose Action') {
            steps {
                script {
                    def userInput = input message: 'Choose the action to perform:', parameters: [
                        choice(name: 'ACTION', choices: ['Apply', 'Destroy'], description: 'Select whether to apply or destroy.')
                    ]

                    // Store user choice in environment variable
                    env.ACTION = userInput
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return env.ACTION == 'Apply' }
            }
            steps {
                echo "You have chosen to apply the Terraform changes."
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    dir('prometheus-terraform') {
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Run Ansible Playbook') {
            when {
                expression { return env.ACTION == 'Apply' }
            }
            steps {
        echo "Running Ansible Playbook after applying the changes."
        withAWS(credentials: 'aws-creds', region: 'us-east-1') {
            withCredentials([
                sshUserPrivateKey(credentialsId: 'ssh-key-prometheus', keyFileVariable: 'SSH_KEY'),
                string(credentialsId: 'SMTP_PASSWORD', variable: 'SMTP_PASS')
            ]) {
                dir('prometheus-roles') {
                   sh '''
echo "Waiting for EC2 instance to initialize..."
sleep 60

echo "Fetching Bastion Host IP..."
BASTION_IP=$(terraform output -raw bastion_ip)
echo "Bastion IP: $BASTION_IP"  # Debugging step to verify the fetched Bastion IP

echo "Fetching Private IP of Prometheus Instance..."
PRIVATE_IP=$(ansible-inventory -i aws_ec2.yml --list | jq -r '.["_meta"]["hostvars"] | to_entries[] | select(.value.ansible_host != null) | .value.ansible_host')
echo "Prometheus Private IP: $PRIVATE_IP"  # Debugging step to verify the private IP

echo "Running Ansible Playbook..."
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i aws_ec2.yml playbook.yml \
--private-key=$SSH_KEY -u ubuntu --extra-vars 'smtp_auth_password="${SMTP_PASS}"' \
-e "ansible_ssh_common_args='-o ProxyCommand=\"ssh -i $SSH_KEY -o StrictHostKeyChecking=no -W %h:%p ubuntu@$BASTION_IP\"'"

    '''
}
            }
        }
    }
}

        stage('Terraform Destroy') {
            when {
                expression { return env.ACTION == 'Destroy' }
            }
            steps {
                echo "You have chosen to destroy the Terraform infrastructure."
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    dir('prometheus-terraform') {
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    }

    post {  
        always {
            echo ':gear: Pipeline execution completed.'
        }
        success {
            echo ':white_check_mark: Pipeline executed successfully!'
            emailext(
                subject: "Jenkins Pipeline SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """<p>Pipeline <b>${env.JOB_NAME}</b> (Build #${env.BUILD_NUMBER}) completed successfully.</p>
                         <p><a href="${env.BUILD_URL}">Click here to view the build details</a>.</p>""",
                to: 'prince98batra@gmail.com',
                mimeType: 'text/html'  // Ensures proper HTML rendering
            )
        }
        failure {
            echo ':x: Pipeline failed. Check the logs for details.'
            emailext(
                subject: "Jenkins Pipeline FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """<p>Pipeline <b>${env.JOB_NAME}</b> (Build #${env.BUILD_NUMBER}) failed.</p>
                         <p><a href="${env.BUILD_URL}">Click here to view the build details</a>.</p>""",
                to: 'prince98batra@gmail.com',
                mimeType: 'text/html'  // Ensures proper HTML rendering
            )
        }
        aborted {
            echo ':no_entry_sign: Pipeline was manually aborted.'
            emailext(
                subject: "Jenkins Pipeline ABORTED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """<p>Pipeline <b>${env.JOB_NAME}</b> (Build #${env.BUILD_NUMBER}) was aborted.</p>
                         <p><a href="${env.BUILD_URL}">Click here to view the build details</a>.</p>""",
                to: 'prince98batra@gmail.com',
                mimeType: 'text/html'  // Ensures proper HTML rendering
            )
        }
    }
}

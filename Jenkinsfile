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
                dir('prometheus-terraform') {
                    script {
                        def bastionIp = sh(script: "terraform output -raw bastion_ip || echo ''", returnStdout: true).trim()
                        
                        if (!bastionIp) {
                            error("❌ Bastion Host IP could not be fetched. Check Terraform outputs.")
                        }
                        
                        echo "✅ Bastion Host IP: ${bastionIp}"

                        // Save SSH private key securely
                        sh '''
                        mkdir -p ~/.ssh
                        echo "$SSH_KEY" > ~/.ssh/jenkins_key.pem
                        chmod 600 ~/.ssh/jenkins_key.pem
                        '''

                        // Save bastion IP for later use
                        writeFile file: '../prometheus-roles/bastion_ip.txt', text: bastionIp
                    }
                }

                dir('prometheus-roles') {
                    script {
                        echo "🚀 Executing Ansible Playbook with Dynamic Inventory..."

                        // Verify the bastion_ip file exists before proceeding
                        def bastionIpFile = sh(script: "cat bastion_ip.txt 2>/dev/null || echo ''", returnStdout: true).trim()

                        if (!bastionIpFile) {
                            error("❌ Bastion Host IP file is empty or missing. Ensure Terraform output is correct.")
                        }

                        echo "🔗 Bastion IP: ${bastionIpFile}"

                        sh """
                        export ANSIBLE_HOST_KEY_CHECKING=False

                        ansible-playbook -i aws_ec2.yml playbook.yml \\
                        --private-key=~/.ssh/jenkins_key.pem -u ubuntu \\
                        --extra-vars "smtp_auth_password=${SMTP_PASS}" \\
                        -e "ansible_ssh_common_args='-o ProxyCommand=\\\"ssh -i ~/.ssh/jenkins_key.pem -W %h:%p ubuntu@${bastionIpFile}\\\"'"
                        """
                    }
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
                mimeType: 'text/html'
            )
        }
        failure {
            echo ':x: Pipeline failed. Check the logs for details.'
            emailext(
                subject: "Jenkins Pipeline FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """<p>Pipeline <b>${env.JOB_NAME}</b> (Build #${env.BUILD_NUMBER}) failed.</p>
                         <p><a href="${env.BUILD_URL}">Click here to view the build details</a>.</p>""",
                to: 'prince98batra@gmail.com',
                mimeType: 'text/html'
            )
        }
        aborted {
            echo ':no_entry_sign: Pipeline was manually aborted.'
            emailext(
                subject: "Jenkins Pipeline ABORTED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """<p>Pipeline <b>${env.JOB_NAME}</b> (Build #${env.BUILD_NUMBER}) was aborted.</p>
                         <p><a href="${env.BUILD_URL}">Click here to view the build details</a>.</p>""",
                to: 'prince98batra@gmail.com',
                mimeType: 'text/html'
            )
        }
    }
}

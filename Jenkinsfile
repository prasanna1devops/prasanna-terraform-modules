pipeline {
    agent any

    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('cred')
    }

    stages {
        stage('Non Prod Infra : Creation') {
            when {
                anyOf {
                    branch 'develop'
                    branch 'test'
                }
            }
            steps {
                script {
                    sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                    sh 'gcloud config set project prasanna1-410609'

                    if (env.BRANCH_NAME == 'develop') {
                        dir("infra/StorageBucket") {
                            sh 'terraform --version'
                            sh 'terraform init -backend-config=./environment/dev/backend_config.tfvars'
                            sh 'terraform refresh -var-file=./environment/dev/variables.tfvars -no-color'
                            env.TERRAFORM_PLAN_EXIT_CODE = sh(returnStatus: true, script:"terraform plan -var-file=./environment/dev/variables.tfvars -no-color -detailed-exitcode -out=output.tfplan")
                            sh 'terraform apply -var-file=./environment/dev/variables.tfvars -no-color -auto-approve'
                        }
                    } else if (env.BRANCH_NAME == 'test') {
                        dir("infra/StorageBucket") {
                            sh 'terraform --version'
                            sh 'terraform init -backend-config=./environment/uat/backend_config.tfvars'
                            sh 'terraform refresh -var-file=./environment/uat/variables.tfvars -no-color'
                            env.TERRAFORM_PLAN_EXIT_CODE = sh(returnStatus: true, script:"terraform plan -var-file=./uat/variables.tfvars -no-color -detailed-exitcode -out=output.tfplan")
                            sh 'terraform apply -var-file=./environment/uat/variables.tfvars -no-color -auto-approve'
                        }
                    }
                }
            }
        }

        stage('Production Infra : Creation') {
            when {
                branch 'master'
            }
            steps {
                script {
                    sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                    sh 'gcloud config set project prasanna1-410609'   #prasanna

                    if (env.BRANCH_NAME == 'master') {
                        dir("infra/StorageBucket") {
                            sh 'terraform --version'
                            sh 'terraform init -backend-config=./environment/prod/backend_config.tfvars'
                            sh 'terraform refresh -var-file=./environment/prod/variables.tfvars -no-color'
                            env.TERRAFORM_PLAN_EXIT_CODE = sh(returnStatus: true, script:"terraform plan -var-file=./environment/prod/variables.tfvars -no-color -detailed-exitcode -out=output.tfplan")
                            sh 'terraform apply -var-file=./environment/prod/variables.tfvars -no-color -auto-approve'
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

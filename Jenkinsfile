pipeline {
    agent any
    stages {
        stage('Clone GitHub Repository') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/main']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    submoduleCfg: [],
                    userRemoteConfigs: [[
                        url: 'https://github.com/logesh81098/Face-recognition-using-AWS-Rekognition'
                    ]]
                ])
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t logeshshanmugavel/face-rekognition-app .'
            }
        }
        stage('List Docker Images'){
            steps{
                sh 'docker images'
            }
        }
        stage('Login Jenkins'){
            steps{
                withCredentials([usernamePassword(
                credentialsId: 'docker-hub',
                usernameVariable: 'DOCKER_USERNAME',
                passwordVariable: 'DOCKER_PASSWORD'
        )]) {
            sh '''
            echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
            echo "Logged in Successfully :)"
          '''
            }
        }
        }
        stage('Push Docker Image'){
            steps{
                sh 'docker push logeshshanmugavel/face-rekognition-app'
            }
        }
        stage('Install kubectl'){
            steps{
                sh '''
                curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.33.0/2025-05-01/bin/linux/amd64/kubectl
                curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.33.0/2025-05-01/bin/linux/amd64/kubectl.sha256
                chmod +x ./kubectl
                mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
                '''
            }
        }
        stage('Check the Package Version'){
            steps{
                sh '''
                aws --version
                PATH=/var/lib/jenkins/bin:$PATH
                kubectl version --client
                '''
            }
        }
        stage('Login to AWS') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'jenkins-user',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    export AWS_DEFAULT_REGION=us-east-1
                    aws sts get-caller-identity || { echo "AWS login failed"; exit 1; }
                    echo "Logged in to AWS Successfully :)"
                    '''
                }
            }
        }
        stage('Update Kubeconfig'){
            steps{
                sh '''
                aws eks update-kubeconfig --name Face-Rekognition-Cluster --region us-east-1
                '''
            }
        }
        stage('Run Manifest files'){
            steps{
                sh '''
                cd k8s/manifests/
                ls
                PATH=/var/lib/jenkins/bin:$PATH
                kubectl apply -f serviceaccount.yaml
                kubectl apply -f deployment.yaml
                kubectl apply -f service.yaml
                '''
            }
        }
        stage('Get Manifest value'){
            steps{
                sh '''
                PATH=/var/lib/jenkins/bin:$PATH
                kubectl get deployment
                kubectl get svc
                kubectl get sa
                '''
            }
        }
        
    }
}

pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID="947502358539"
        AWS_DEFAULT_REGION="ap-south-1" 
	CLUSTER_NAME="tksdevopserp"
	SERVICE_NAME="tkserpcluster-service"
	TASK_DEFINITION_NAME="tks_erp_build_task"
	DESIRED_COUNT="1"
        IMAGE_REPO_NAME="tks_erp"
        IMAGE_TAG="${env.BUILD_ID}"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
	registryCredential = "947502358539"
    }
   
    stages {

    // Tests
    stage('ERP Sonar Tests') {
      steps{
        script {
          sh 'npm install'
	  sh 'npm test -- --watchAll=false'
        }
      }
    }

/* stages {
        stage('build && SonarQube analysis') {
            steps {
                withSonarQubeEnv('sonar.tools.devops.****') {
                    sh 'sonar-scanner -Dsonar.projectKey=myProject -Dsonar.sources=./src'
                }
            }
        }
        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
		}

*/

    // Building Docker images
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
        }
      }
    }
   
    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{  
         script {
			docker.withRegistry("https://" + REPOSITORY_URI, "ecr:${AWS_DEFAULT_REGION}:" + registryCredential) {
                    	dockerImage.push()
                	}
         }
        }
      }
      
    stage('Deploy') {
     steps{
            withAWS(credentials: registryCredential, region: "${AWS_DEFAULT_REGION}") {
                script {
			sh './script.sh'
                }
            } 
        }
      }      
      
    }
}


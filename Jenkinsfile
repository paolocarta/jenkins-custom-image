pipeline {

    agent any

    parameters {

        string(defaultValue: 'test@gmail.com', description: 'Notification recipients', name: 'EMAIL_RECIPIENT_LIST')
    }
    
    options {
        
        // use colors in Jenkins console output
        // ansiColor('xterm')
        
        // discard old builds
        buildDiscarder logRotator(daysToKeepStr: '30', numToKeepStr: '45')
        
        // disable concurrent builds and disable build resume
        disableConcurrentBuilds()
        // disableResume()

        // timeout on whole pipeline job
        timeout(time: 1, unit: 'HOURS')
    }
    
    triggers {
        pollSCM "*/1 * * * *"
    }

    environment {

        CI_CD_NAMESPACE   = 'jenkins'
    }
  
    stages {

        stage("Initialize") {

            options {
                skipDefaultCheckout true
            }

            steps {
                script {
                        echo "Build number: ${BUILD_NUMBER} - Build id: ${env.BUILD_ID} started from Jenkins instance: ${env.JENKINS_URL}"
                        sh "printenv | sort"

                }
            }
        }

        stage('Image Build and Push') {

            agent {
                kubernetes {
                    yamlFile 'pod-template-kaniko.yaml'
                    cloud 'kubernetes'
                }
            } 

            when {
                beforeAgent true
                branch 'master'
            }

            steps {
                container('kaniko') {
                    sh "pwd"
                    sh "ls -l"
                    sh "id"
                    sh "echo $HOME"
                    sh "echo $WORKSPACE"

                    script {
                        def jobName = env.JOB_NAME
                        def serviceName = jobName.split("/")[0]
                        env.SERVICE_NAME = serviceName
                    }
                                        
                    sh "/kaniko/executor \
                        --context=dir://$WORKSPACE --dockerfile=Dockerfile  \
                        --destination=gcr.io/paolos-playground-323415/${SERVICE_NAME}:${BUILD_NUMBER} \
                        --destination=gcr.io/paolos-playground-323415/${SERVICE_NAME}:${GIT_COMMIT} \
                        --cache"

                }            
            }
        }

    post {

        always {
            sh 'echo post-action-always'

            // node('maven') { 
            //     // sh 'ls -l /tmp/workspace'
            //     // sh 'rm -rf /tmp/workspace/${SERVICE_NAME}'
            // }

            // cleanWs()
        }        
        
    }

}
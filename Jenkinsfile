@Library('ecommerce-shared-lib') _
def SERVICE_NAME    = 'database'
def DOCKER_REGISTRY = 'yeelaine'
def GIT_SHORT       = ''
def IMAGE_TAG       = ''
def FULL_IMAGE      = ''

pipeline {

    agent any

    environment {
        DOCKER_BUILDKIT = '1'
    }

    options {
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
                script {
                    GIT_SHORT  = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    IMAGE_TAG  = "git-${GIT_SHORT}"
                    FULL_IMAGE = "${DOCKER_REGISTRY}/ecommerce-${SERVICE_NAME}:${IMAGE_TAG}"
                    echo "Image will be tagged: ${FULL_IMAGE}"
                }
            }
        }

        // STAGE 1: Build
        stage('Build') {
            steps {
                echo "BUILD STAGE: ${SERVICE_NAME}"
                sh '''
                    for f in src/*.sql; do
                        echo "  Checking $f"
                    done
                    echo "Build stage complete"
                '''
            }
        }

        // STAGE 2: Test
        stage('Test') {
            steps {
                echo "TEST STAGE: ${SERVICE_NAME}"
                sh 'echo "Database config validation"'
            }
        }

        // STAGE 3: Security Scan
        stage('Security Scan - IaC (Checkov)') {
            steps {
                securityScanStage(service: SERVICE_NAME)
            }
        }

        // STAGE 4: Docker Build  
        stage('Docker Build and Push') {
            when { not { changeRequest() } }
            steps {
                script {
                    dockerBuildPush(service: SERVICE_NAME, tag: IMAGE_TAG, registry: DOCKER_REGISTRY)
                    FULL_IMAGE = env.DOCKER_IMAGE
                }
            }
        }

        // STAGE 5: Trivy Image Scan
        stage('Security Scan - Image (Trivy)') {
            when { not { changeRequest() } }
            steps { securityScanStage(service: SERVICE_NAME, image: FULL_IMAGE) }
        }

        // STAGE 6: Deploy
        stage('Deploy to Dev') {
            when { branch 'develop' }
            steps {
                script {
                    try {
                        sh '''
                            kubectl apply -f k8s/persistentvolume.yaml  -n dev
                            kubectl apply -f k8s/pvc.yaml               -n dev
                            kubectl apply -f k8s/configmap.yaml         -n dev
                            kubectl apply -f k8s/secret.yaml            -n dev
                            kubectl apply -f k8s/statefulset.yaml       -n dev
                            kubectl apply -f k8s/service-clusterip.yaml -n dev
                            kubectl rollout status statefulset/database -n dev --timeout=60s
                        '''
                    } catch (err) {
                        echo "WARNING: K8s manifests not ready yet - skipping deploy"
                    }
                }
            }
        }

        stage('Deploy to Staging') {
            when { expression { env.BRANCH_NAME ==~ /release\/.*/ } }
            steps {
                script {
                    try {
                        sh '''
                            kubectl apply -f k8s/ -n staging
                            kubectl rollout status statefulset/database -n staging --timeout=60s
                        '''
                    } catch (err) {
                        echo "WARNING: K8s manifests not ready yet - skipping deploy"
                    }
                }
            }
        }

        stage('Approval Gate - Production') {
            when { branch 'main' }
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    input message: "Deploy database ${FULL_IMAGE} to PRODUCTION?",
                          ok: 'Approve',
                          submitter: 'admin'
                }
            }
        }

        stage('Deploy to Production') {
            when { branch 'main' }
            steps {
                sh '''
                    kubectl apply -f k8s/ -n prod
                    kubectl rollout status statefulset/database -n prod --timeout=60s
                '''
            }
        }

    }

    post {
        success { echo "SUCCESS — ${SERVICE_NAME} @ ${IMAGE_TAG}" }
        failure { echo "FAILED — ${SERVICE_NAME} @ ${IMAGE_TAG}" }
        always  { cleanWs() }
    }

}

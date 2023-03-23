podTemplate(yaml: '''
  apiVersion: v1
  kind: Pod
  spec:
    containers:
    - name: gradle
      image: gradle:jdk8
      command:
      - sleep
      args:
      - 99d
      volumeMounts:
      - name: shared-storage
        mountPath: /mnt     
    restartPolicy: Never
    volumes:
    - name: shared-storage
      persistentVolumeClaim:
        claimName: jenkins-pv-claim
''') {

  node(POD_LABEL) {
    stage('gradle') {
      git 'https://github.com/robertpeterson2/Continuous-Delivery-with-Docker-and-Jenkins-Second-Edition.git'
        container('gradle') {
          stage('Starting Calculator') {
            sh '''
            curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
            chmod +x ./kubectl
            ./kubectl apply -f Chapter08/sample1/calculator.yaml -n staging
            ./kubectl apply -f Chapter08/sample1/hazelcast.yaml -n staging
            sleep 30
            '''
          }
          stage('Test 1') {
            echo "Test 1 - Replica Count"
            sh '''
            ./kubectl get pods -n staging
            echo "Deploying new calculator.yaml with increased replica count"
            cp Chapter08/sample1/calculator2.yaml Chapter08/sample1/calculator.yaml
            ./kubectl apply -f Chapter08/sample1/calculator.yaml -n staging
            ./kubectl get pods -n staging
            sleep 15
            ./kubectl get pods -n staging
            sleep 15
            ./kubectl get pods -n staging
            '''    
          }  
          stage('Test 2') {
            echo "Test 2 - Testing image for sum and div"
            echo "Image hello-kaniko0_5 testing"
            try {
              sh '''
              test $(curl calculator-service.staging.svc.cluster.local:8080/sum?a=4\\&b=2) -eq 6 && echo 'pass' || echo 'fail'
              test $(curl calculator-service.staging.svc.cluster.local:8080/sum?a=4\\&b=2) -eq 5 && echo 'pass' || echo 'fail'
              test $(curl calculator-service.staging.svc.cluster.local:8080/div?a=10\\&b=2) -eq 5 && echo 'pass' || echo 'fail'
              test $(curl calculator-service.staging.svc.cluster.local:8080/div?a=8\\&b=4) -eq 2 && echo 'pass' || echo 'fail'
              test $(curl calculator-service.staging.svc.cluster.local:8080/div?a=4\\&b=0) -eq 4 && echo 'pass' || echo 'fail'
              '''
            }
            catch (Exception E) {
               echo "One or more tests failed"
            }
            echo "Image week8_1_1 testing"
            sh '''
            cp Chapter08/sample1/calculator3.yaml Chapter08/sample1/calculator.yaml
            ./kubectl apply -f Chapter08/sample1/calculator.yaml -n staging
            sleep 30
            '''
            try {
              sh '''
              test $(curl calculator-service.staging.svc.cluster.local:8080/sum?a=4\\&b=2) -eq 6 && echo 'pass' || echo 'fail'
              test $(curl calculator-service.staging.svc.cluster.local:8080/sum?a=4\\&b=2) -eq 5 && echo 'pass' || echo 'fail'
              test $(curl calculator-service.staging.svc.cluster.local:8080/div?a=10\\&b=2) -eq 5 && echo 'pass' || echo 'fail'
              test $(curl calculator-service.staging.svc.cluster.local:8080/div?a=8\\&b=4) -eq 2 && echo 'pass' || echo 'fail'
              test $(curl calculator-service.staging.svc.cluster.local:8080/div?a=4\\&b=0) -eq 4 && echo 'pass' || echo 'fail'
              '''
            }
            catch (Exception E) {
               echo "One or more tests failed"
            }
          }
          stage('Removing Calculator') {
            sh '''
            ./kubectl delete deployment hazelcast calculator-deployment -n staging
            ./kubectl delete service hazelcast calculator-service -n staging
            '''
          }
        }
      }
    }
  }
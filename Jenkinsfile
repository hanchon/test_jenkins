pipeline {
  agent {
    docker {
      label 'Bitprim_Slave'
      image 'ubuntu:18.10'
      args '''-u root -v /var/run/docker.sock:/var/run/docker.sock
-v jenkins_build:/var/jenkins_home'''
    }

  }
  stages {
    stage('Requirements') {
      steps {
        sh '''#Install Requirements on Ubuntu18.10 docker image
apt-get update
apt-get install build-essential -y
apt-get install gcc -y
apt-get install git -y
apt-get install cmake -y
apt-get install python -y
apt-get install python-pip -y
pip install conan --upgrade
conan remote add bitprim https://api.bintray.com/conan/bitprim/bitprim'''
      }
    }
    stage('Create release branchs') {
      steps {
        sh 'echo "hello world"'
      }
    }
  }
}
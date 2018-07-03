pipeline {
  agent {
    docker {
      label 'Bitprim_Slave'
      args '-u root'
      image 'arceri/buildimage-ubuntu:18.10'
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
        slackSend(message: 'Requirements Installed', channel: '#testing_bot')
      }
    }
    stage('Clone repos') {
      steps {
        sh '''ls
git status
git rev-parse HEAD
./clone.sh'''
      }
    }
    stage('Create release branches') {
      steps {
        sh './create_release_branches.sh'
      }
    }
    stage('Compile') {
      parallel {
        stage('Compile BCH') {
          steps {
            sh './compile_coin.sh BCH'
            archiveArtifacts 'bin-BCH/bn-BCH'
            slackSend(message: 'BCH build success', channel: '#testing_bot')
          }
        }
        stage('Compile BTC') {
          steps {
            sh './compile_coin.sh BTC'
            archiveArtifacts 'bin-BTC/bn-BTC'
          }
        }
        stage('Compile LTC') {
          steps {
            sh './compile_coin.sh LTC'
            archiveArtifacts 'bin-LTC/bn-LTC'
          }
        }
      }
    }
    stage('Testing (IBDs)') {
      parallel {
        stage('BCH mainnet') {
          steps {
            sh 'echo "run idb BCH mainnet"'
          }
        }
        stage('BCH testnet') {
          steps {
            sh 'echo "run idb BCH testnet"'
          }
        }
        stage('BTC mainnet') {
          steps {
            sh 'echo "run idb BTC mainnet"'
          }
        }
        stage('BTC testnet') {
          steps {
            sh 'echo "run idb BTC testnet"'
          }
        }
        stage('LTC mainnet') {
          steps {
            sh 'echo "run idb LTC mainnet"'
          }
        }
        stage('LTC testnet') {
          steps {
            sh 'echo "run idb LTC testnet"'
          }
        }
      }
    }
    stage('Merge master') {
      steps {
        sh 'echo "merge release branch code to master"'
      }
    }
    stage('Tag master') {
      steps {
        sh 'echo "Tag master branch using the release version"'
      }
    }
    stage('Upgrade dev version') {
      steps {
        sh 'echo "Upgrade dependencies version on dev branches"'
      }
    }
    stage('Clean') {
      steps {
        cleanWs(cleanWhenAborted: true, cleanWhenFailure: true, cleanWhenNotBuilt: true, cleanWhenSuccess: true, cleanWhenUnstable: true, cleanupMatrixParent: true, deleteDirs: true)
      }
    }
  }
}
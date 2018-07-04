pipeline {
  agent {
    docker {
      label 'Bitprim_Slave'
      image 'arceri/buildimage-ubuntu:18.10'
      args '-u root -v /var/run/docker.sock:/var/run/docker.sock -v jenkins_build:/var/jenkins_home'
    }

  }
  stages {
    stage('Requirements') {
      steps {
        sh '''#Use gea\'s image arceri/buildimage-ubuntu:18.10
#apt-get update
#apt-get install build-essential -y
#apt-get install gcc -y
#apt-get install git -y
#apt-get install cmake -y
#apt-get install python -y
#apt-get install python-pip -y
#pip install conan --upgrade
#conan remote add bitprim https://api.bintray.com/conan/bitprim/bitprim
'''
        sh '''# Clean old files 
ls
rm -rf bitprim-*
rm -rf /root/.conan/data
conan --version
gcc --version

#conan install boost/1.66.0@bitprim/stable'''
      }
    }
    stage('Clone repos') {
      steps {
        sh '''# Clone repos
./clone.sh
git status'''
      }
    }
    stage('Create release branches') {
      steps {
        sh '''# Create release branches using current dev
./create_release_branches.sh

./compile_coin.sh BCH'''
        slackSend(message: 'Release branches created.', channel: '#testing_bot', color: '#37c334')
      }
    }
    stage('Compile') {
      parallel {
        stage('Compile BCH') {
          steps {
            sh '''cat ./compile_coin.sh

#./compile_coin.sh BCH
#mkdir bin-BCH
#cd bin-BCH
#echo "temp" > bn-BCH

cd bitprim-core
conan create . bitprim-core/0.11.0@bitprim/stable -o *:currency=BCH
cd ..'''
            archiveArtifacts 'bin-BCH/bn-BCH,cfg/bch*'
            slackSend(message: 'BCH build success', channel: '#testing_bot', color: '#37c334')
          }
        }
        stage('Compile BTC') {
          steps {
            sh '''./compile_coin.sh BTC
#mkdir bin-BTC
#cd bin-BTC
#echo "temp" > bn-BTC


cat  /root/.conan/data/boost/1.66.0/bitprim/stable/package/a81fa98b0d5c91b5911ac15b73d8ecc843b057b5/conaninfo.txt'''
            archiveArtifacts 'bin-BTC/bn-BTC,cfg/btc*'
            slackSend(message: 'BTC build success', color: '#37c334', channel: '#testing_bot')
          }
        }
        stage('Compile LTC') {
          steps {
            sh '''./compile_coin.sh LTC
#mkdir bin-LTC
#cd bin-LTC
#echo "temp" > bn-LTC'''
            archiveArtifacts 'bin-LTC/bn-LTC,cfg/btc*'
            slackSend(message: 'LTC build success', channel: '#testing_bot', color: '#37c334')
          }
        }
      }
    }
    stage('Testing (IBDs)') {
      parallel {
        stage('BCH mainnet') {
          steps {
            sh 'echo "run idb BCH mainnet"'
            input(message: 'Was the BCH mainnet IBD OK?', id: 'bch-mainnet')
          }
        }
        stage('BCH testnet') {
          steps {
            sh 'echo "run idb BCH testnet"'
            input(message: 'Was the BCH testnet IBD OK?', id: 'bch-testnet')
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
        sh '''echo "merge release branch code to master"
ls
chmod +x merge_master.sh
./merge_master.sh
cd bitprim-core
git status
git log -n 10
cd ..'''
      }
    }
    stage('Tag master') {
      steps {
        sh '''echo "Tag master branch using the release version"
ls
./tag_master.sh
cd bitprim-core
git status
git log -n 10'''
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
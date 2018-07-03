#!/bin/bash
source ./constants.sh

# Usage
# ./compile_coin.sh BTC
# ./compile_coin.sh BCH
# ./compile_coin.sh LTC

COIN=$1

build_repo() {
	#TODO: get version using the ci-utils function
	for i in "${repos[@]}"; do
		cd "${i}"
		conan create . "${i}"/"${version}"@bitprim/stable -o *:currency="${COIN}" -o *:with_rpc=True
		cd ..
	done
}

save_bn() {
	mkdir bin-"${COIN}"
	cd bin-"${COIN}"
	conan install bitprim-node-exe/"${version}"@bitprim/stable -o *:with_rpc=True -o *:currency="${COIN}"
	mv bn bn-"${COIN}"
	cd ..
}

build_repo
save_bn

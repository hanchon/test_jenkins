#!/bin/bash
source ./constants.sh

create_release() {
	for i in "${repos[@]}"; do
		cd "${i}"
		git checkout -b release-"${version}"
		# git push
		cd ..
	done
}

create_release

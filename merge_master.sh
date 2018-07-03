#!/bin/bash
source ./constants.sh

create_release() {
	for i in "${repos[@]}"; do
		cd "${i}"
        git checkout master
        git merge release-"${version}"
		# git push
		cd ..
	done
}
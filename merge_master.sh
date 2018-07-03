#!/bin/bash
source ./constants.sh

merge_release_to_master() {
	for i in "${repos[@]}"; do
		cd "${i}"
		git checkout master
		git merge release-"${version}"
		# git push
		cd ..
	done
}

merge_release_to_master

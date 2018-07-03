#!/bin/bash
source ./constants.sh

tag_master() {
	for i in "${repos[@]}"; do
		cd "${i}"
		git checkout master
		git pull

		git config user.email "guillermo@bitprim.org"
		git config user.name "Hanchon"

		git tag -a v"${version}" -m "version ${version}"
		# git push --tags
		git tag -n5
		git show-ref --tags
		cd ..
	done
}

tag_master

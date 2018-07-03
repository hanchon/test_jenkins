#!/bin/bash
source ./constants.sh

clone_projects() {
	for i in "${repos[@]}"; do
		git clone "${repos_url}""${i}" -b dev --recursive
	done
}

clone_projects

#!/bin/bash
sudo apt-get update > /dev/null
sudo apt-get install git-core --no-install-recommends --no-install-suggests -y
git config --global user.email "seregatte@gmail.com"
git config --global user.name "João Paulo Seregatte Costa"
docker build generator/ -t builder:latest
export ANSIBLE_VERSION=`docker run --rm -it builder:latest ansible --version | head -1 | cut -d' ' -f2`
docker run --rm -it -v `pwd`:/var/www/html builder:latest make
export CI_BRANCH=`date +%Y-%m-%d`-ci
git checkout -b ${CI_BRANCH} || git checkout ${CI_BRANCH}
git add . *.sublime-snippet
git commit --message "Travis build: ${TRAVIS_BUILD_NUMBER} for ${ANSIBLE_VERSION}"
git remote add origin-ci https://${GITHUB_TOKEN}@github.com/seregatte/AnsibleSnippets.git > /dev/null 2>&1
git push --quiet --set-upstream origin-ci ${CI_BRANCH}
#!/bin/bash

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
if [ "$IS_TRAVIS" != "true" ]; then
  TRAVIS_BUILD_DIR=$SCRIPT_PATH
  TRAVIS_BUILD_NUMBER="0000"
fi
export CONFIG_FILE="$TRAVIS_BUILD_DIR/.travis/tex-config.ini"
# Get the tex-scheme config option
export texscheme=$(awk -F "=" '/tex-scheme/ {print $2}' "$CONFIG_FILE")
# export pushtype=$(awk -F "=" '/push-type/ {print $2}' "$CONFIG_FILE")
export pushtype="branch"
DOCKER_IMAGE="strauman/travis-latexbuild:$texscheme"

setup_git() {
  if [ "$IS_TRAVIS" == "true" ]; then
    echo "Testing on travis-ci...";
    git config --global user.email "travis@travis-ci.org"
    git config --global user.name "Travis CI"
  else
    echo "Testing locally...";
  fi
  git checkout --orphan "travis-$TRAVIS_BUILD_NUMBER"
  git rm --cached $(git ls-files)
}

commit_pdfs() {
  echo `ls tests`
  git add -f "$TRAVIS_BUILD_DIR/tests/pdfs/"
  echo `git status`
  git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
}

upload_files() {
  git remote add origin-login "https://${GH_TOKEN}@github.com/$TRAVIS_REPO_SLUG.git"
  git push --set-upstream -f origin-login "travis-$TRAVIS_BUILD_NUMBER"
  echo "PUSHED PDFS TO BRANCH travis-$TRAVIS_BUILD_NUMBER"
}
# Only execute if branch doesn't start with travis-
if [[ "$TRAVIS_BRANCH" == travis-* ]]; then
  echo "On a travis branch ($TRAVIS_BRANCH). Not doing anything."
else
  if [ "$pushtype" == "branch" ]; then
  setup_git
  # Now pull the appropriate docker
  docker pull $DOCKER_IMAGE
  # Run the docker and on the files
  docker run --mount src="$TRAVIS_BUILD_DIR/",target=/repo,type=bind $DOCKER_IMAGE
  # commit_pdfs
  [[ "$IS_TRAVIS" == "true" ]] && upload_files;
  elif [ "$pushtype" == "release" ]; then
    echo "Push type release not supported yet."
  fi
fi

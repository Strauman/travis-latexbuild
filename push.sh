#!/bin/sh
# How to set up TravisCI for projects that push back to github:
# Inspired by:
# https://gist.github.com/willprice/e07efd73fb7f13f917ea

setup_git() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"
}

commit_pdfs() {
  git checkout --orphan "travis-$TRAVIS_BUILD_NUMBER"
  git rm --cached $(git ls-files)
  echo `ls tests`
  git add "$TRAVIS_BUILD_DIR/tests/pdfs/"
  echo `git status`
  git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
}

upload_files() {
  git remote add origin-login https://${GH_TOKEN}@github.com/Strauman/exercisebank.git
  git push --set-upstream -f origin-login "travis-$TRAVIS_BUILD_NUMBER"
  echo "PUSHED PDFS TO BRANCH travis-$TRAVIS_BUILD_NUMBER"
}

setup_git
commit_pdfs
upload_files

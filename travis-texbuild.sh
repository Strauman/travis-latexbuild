#!/bin/sh
export CONFIG_FILE="$TRAVIS_BUILD_DIR/.travis/tex-config.ini"
# Get the tex-scheme config option
export texscheme=$(awk -F "=" '/tex-scheme/ {print $2}' "$CONFIG_FILE")
export pushtype=$(awk -F "=" '/push-type/ {print $2}' "$CONFIG_FILE")

# Now pull the appropriate docker
docker pull strauman/travis-latexbuild:$texscheme
# Run the docker and on the files
docker run --mount src="$TRAVIS_BUILD_DIR/",target=/repo,type=bind strauman/travis-latexbuild:$texscheme

setup_git() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"
}

commit_pdfs() {
  git checkout --orphan "travis-$TRAVIS_BUILD_NUMBER"
  git rm --cached $(git ls-files)
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
if [[ $TRAVIS_BRANCH == travis-* ]]; then
  echo "On a travis branch. Not pushing."
else
  if [ "$pushtype" == "branch" ]; then
  setup_git
  commit_pdfs
  upload_files
  elif [ "$pushtype" == "release" ]; then
    #Do release push stuff
  fi
fi

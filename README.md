- The github repo can be found [here](https://github.com/Strauman/travis-latexbuild/).
- The docker repo can be found [here](https://hub.docker.com/r/strauman/travis-latexbuild/).

How it works:

1. You push to the git repo containing your code.
1. Travis runs the test files you specified (see below).
1. Travis gives a buildstatus of "failed" if any of the builds doesn't result as expected.
1. (optional) Travis pushes (only) the resulting PDFs to a branch called `travis-BUILDNO` where `BUILDNO`. will be replaced by the current travis build number.

Setup:

1. In your main git repo root add this [.travis.yml](https://github.com/Strauman/travis-latexbuild/blob/master/.travis.yml)
1. If you want the push-branch functionality, do the following
    1. Go to  [github personal access tokens](https://github.com/settings/tokens) and generate a new token
    1. You need to encrypt your github token:
      `cd` into your git repo and run `gem install travis; travis GH_TOKEN=YOURTOKEN --add` (replacing `YOURTOKEN` with the generated token). If this doesn't work, have a look on the [travis documentation on environment variables](https://docs.travis-ci.com/user/environment-variables/)
    1. In your main git repo root make a directory called `.travis` 
    1. Add the [`push.sh`](https://github.com/Strauman/travis-latexbuild/blob/master/push.sh) to the `.travis` directory you just created (this file is pushing the branch. You can omit it if you don't want to push the `travis-BUILDNO`-branch to your repos.
4. Make a directory called `tests/` to your git repo root.
5. In this repo, create a directory with a name of your choosing. The name of the directory will be the name of the "test". E.g. `/tests/TestMyFeature`
6. Inside the newly created directory, add a file `main.tex`. This file will be run during test.

Things to note:

- The [git repo][gitrepo] contains the setup example: consisting of `.travis.yml`, `.travis/push.sh` and `/tests`.
- If `tests/testmyfeature/main.tex` is supposed to fail, then you should make a file `tests/testmyfeature/wants-fail`. Then a success run of the `main.tex` would count as a failed build.
- To install package requirements, then add a file `tests/packages` containing a space separated list of packages (see the `tests/packages` in the [github repo][gitrepo]) 
- You can put whatever files and directories you want into `tests`. At test time, only the directories containing the `main.tex` is executed.
- The working directory of a test `main.tex`-file is the directory the current `main.tex` file is in.
- In the docker, by default, the entire repository is loaded to the `/repo` volume. So in your `tests/TestMyFeature/main.tex` you could do e.g. `\def\input@path{{/repo/}}` to include things directly from the repo.


  [gitrepo]: https://github.com/Strauman/travis-latexbuild
  [docker]: https://hub.docker.com/r/strauman/travis-latexbuild/

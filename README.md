[![Build Status](https://travis-ci.org/Strauman/travis-latexbuild.svg?branch=master)](https://travis-ci.org/Strauman/travis-latexbuild)

-   The github repo can be found [here](https://github.com/Strauman/travis-latexbuild/).
-   The docker repo can be found [here](https://hub.docker.com/r/strauman/travis-latexbuild/).

If you're reading this at docker hub, you probably want to head on over to the [git repo](https://github.com/Strauman/travis-latexbuild/).

# This README is made before the features as a "plan". Head over to issues to see what's done and what's not.

# How it works:

1.  You push to the git repo containing your code.
2.  Travis runs the test files you specified (see below).
3.  Travis gives a build status of "failed" if any of the builds doesn't result as expected.
4.  (optional) Travis pushes (only) the resulting PDFs to a branch called `travis-BUILDNO` where `BUILDNO`. will be replaced by the current travis build number.
    You can choose to push these to a release instead of a branch by using the `push-type` option (see below).

# Setup:

1.  In your main git repo root add this [.travis.yml](https://github.com/Strauman/travis-latexbuild/blob/master/.travis.yml)
2.  In your main git repo root make a directory called `.travis`
3.  Copy the [`tex-config.ini`](https://github.com/Strauman/travis-latexbuild/blob/master/tex-config.ini) to `.travis/tex-config.ini`.
    Docs for the config is found further down in this readme.
4.  Add the [`travis-texbuild.sh`](https://github.com/Strauman/travis-latexbuild/blob/master/travis-texbuild.sh) to `.travis/travis-texbuild.sh` directory you just created (this file is pushing the branch. You can omit it if you don't want to push the `travis-BUILDNO`-branch to your repos.
5.  **If you want the push-branch or push-release functionality, do the following**
    1.  Go to  [github personal access tokens](https://github.com/settings/tokens) and generate a new token
    2.  You need to encrypt your github token, via travis, and add it to the `.travis.yml`. If have ruby (gem) installed you can do:
    -   `cd` into your git repo and run `gem install travis; travis GH_TOKEN=YOURTOKEN --add` (replacing `YOURTOKEN` with the generated token).
    -   If the above doesn't work (or you don' know what ruby gems are), you need to install ruby on your machine first.
    -   More information about this step is found on [travis documentation on encryption keys](https://docs.travis-ci.com/user/encryption-keys) and [travis documentation on environment variables](https://docs.travis-ci.com/user/environment-variables/#defining-encrypted-variables-in-travisyml)

Things to note:

<!-- -   The [git repo][gitrepo] contains the setup example: consisting of `.travis.yml`, `.travis/push.sh` and `/tests`. -->

-   If `tests/testmyfeature/main.tex` is supposed to fail, then you should make a file `tests/testmyfeature/wants-fail`. Then a success run of the `main.tex` would count as a failed build.
-   You can put whatever files and directories you want into `tests`. At test time, only the directories containing the `main.tex` is executed.
-   The working directory of a test `main.tex`-file is the directory the current `main.tex` file is in.
-   In the docker, by default, the entire repository is loaded to the `/repo` volume. So in your `tests/TestMyFeature/main.tex` you could do e.g. `\def\input@path{{/repo/}}` to include things directly from the repo.

## config.ini (not implemented yet)

| key                  | default                  | accepted values                             | description                                                                                                                                                                                                                           |
| -------------------- | ------------------------ | ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `build-pattern`      | `tests/\*/main.tex`      | comma separated paths                       | Path of the files to build. The path should be relative to the repo directory. The paths can contain wildcard (`*`).                                                                                                                  |
| `fail-build-pattern` | `fail-tests/\*/main.tex` | comma separated paths                       | Path of the files to build, but that you expect to fail. If the files specified here build without problem, then the travis build will fail. The path should be relative to the repo directory. The paths can contain wildcard (`*`). |
| `tex-scheme`         | `small`                  | `small`, `full`                             | Which TeX-scheme to use; that is how many packages are installed on the docker image by default                                                                                                                                       |
| ^                    | -                        | `full`                                      | Full contains most of the packages in CTAN and has a docker image of 3GB that needs to be downloaded every time.                                                                                                                      |
| ^                    | -                        | `medium`                                    |                                                                                                                                                                                                                                       |
| ^                    | `x`                      | `small`                                     | Small contains only the bare necessities, and probably will most of the packages that you wish to used be specified in the `packages` option                                                                                          |
|                      |                          |                                             |                                                                                                                                                                                                                                       |
| `packages`           | _empty_                  | comma separated list of packages to install | What packages should be installed using TeXLives `tlmgr` before running the TeX-files.                                                                                                                                                |
| `push-type`          | `branch`                 | `branch`, `release` or `none`               | Where to publish the pdfs generated                                                                                                                                                                                                   |

[gitrepo]: https://github.com/Strauman/travis-latexbuild

[docker]: https://hub.docker.com/r/strauman/travis-latexbuild/

## Contributing

Talk about the files, tex profiles and so forth.

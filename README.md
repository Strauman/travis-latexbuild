Master build status: [![Build Status](https://travis-ci.org/Strauman/travis-latexbuild.svg?branch=master)](https://travis-ci.org/Strauman/travis-latexbuild)

Quickstart build status: [![Build Status](https://travis-ci.org/Strauman/travis-latexbuild.svg?branch=quickstart)](https://travis-ci.org/Strauman/travis-latexbuild)

The repo for the dockers used can be found [here](https://github.com/Strauman/latex-docker)

## Check out the [quickstart branch](https://github.com/Strauman/travis-latexbuild/tree/quickstart) to get started with a base setup!

-   The github repo can be found [here](https://github.com/Strauman/travis-latexbuild/).
-   The docker repo can be found [here](https://hub.docker.com/r/strauman/travis-latexbuild/).

If you're reading this at docker hub, you probably want to head on over to the [git repo](https://github.com/Strauman/travis-latexbuild/).

# How it works:

1.  You push to the git repo containing your code.
2.  Travis runs the test files you specified (see below).
3.  Travis gives a build status of "failed" if any of the builds doesn't result as expected.
4.  (optional) Travis pushes (only) the resulting PDFs to a branch called `travis-BUILDNO` where `BUILDNO`. will be replaced by the current travis build number.
    You can choose to push these to a release instead of a branch by using the `push-type` option (see below).

# Setup:

1.  In your main git repo root add this [.travis.yml](https://github.com/Strauman/travis-latexbuild/blob/master/.travis.yml), or if you don't use the `travis-texbuild.sh` you can use this [.travis.yml](https://github.com/Strauman/travis-latexbuild/blob/master/quickstart/.travis.yml).
    Docs for the configuration options in your `.travis.yml` is found further down in this readme.
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

# Configuration options

You can specify configurations in your `.travis.yml` in the form

```yaml
tex-config:
  - config-name=value
```

## `build-pattern`
- Accepted values: one or more paths
- Default value: `tests/*/main.tex`
  - Paths of the files to build. If you want to specify multiple paths, you can comma separate them.
  - The path should be relative to the repo directory.
  - The paths can contain wildcard (`*`) (e.g. `path/to/testfiles/*.tex` is valid).

## `tex-scheme`
- Accepted values: `small` or `full`
- Default value: `small`

Which TeX-scheme to use; this is, basically, how many packages are installed on the docker image by default.
- `full`: Full contains most of the packages in CTAN and has a docker image of 3GB that needs to be downloaded every time.
- `small`: contains only the bare necessities, missing packages will be attempted to be installed using `texliveonfly`. You can manually add packages that you wish to installed using the `packages` option.
(- `medium`: Coming later)

## `packages`
- Accepted values: comma (**not** space) separated list
- Default value: _empty_

What packages should also be installed using TeXLives `tlmgr` before running the TeX-files.
Note that `texliveonfly` will attempt to install missing packages automatically.

## `latexmk-flags`
- Specify compile flags to latexmk, for example `-dvi`
- Multiple flags can be given, separated by spaces

## `push-type`
- Accepted values: `branch` or `none`
- Default value: `branch`

Where to publish the pdfs generated. The option for pushing to `release` is coming: [#3 - Push to releases instead of branches](https://github.com/Strauman/travis-latexbuild/issues/3).



[gitrepo]: https://github.com/Strauman/travis-latexbuild

[docker]: https://hub.docker.com/r/strauman/travis-latexbuild/

## Contributing

Talk about the files, tex profiles and so forth.

## Quickstart
Quickstart build status: [![Build Status](https://travis-ci.org/Strauman/travis-latexbuild.svg?branch=quickstart)](https://travis-ci.org/Strauman/travis-latexbuild)

The repo for the dockers used can be found [here](https://github.com/Strauman/latex-docker)

After following the setup below, then your repository has the following functionality

1. You push to a branch
1. [travis-ci][travis] automatically installs the packages specified in the config file, and runs
    tests the `pdflatex` via `latexmk` on the TeX files specified in the config file.
   - If the directory containing the `.tex` file has a file named `wants-fail`, then travis only succeeds if the `.tex`-file build fails.

**NB** if you want to use more advanced features (push back to git or a different TeX scheme) you __MUST__ use the `.travis.yml`
from the **[master branch][master]**!

### Setup:

In your repo, you need two files from this branch: the [`.travis.yml`][.travis.yml]-file and the [`.travis/tex-config.ini`][tex-config.ini].

**NB**: You also have to add [travis-ci.org][travis] to your repo, and your repo to [travis-ci.org][travis].

1. Copy the [`.travis.yml`][.travis.yml] file from this repo to the root of your git repository
1. Copy the [`.travis/tex-config.ini`][tex-config.ini] file from this repo to `.travis/tex-config.ini` in **your** repo.
1. Profits

Configure the `.travis/tex-config.ini` to your needs. For more advanced options
(e.g. push pdfs back to git repo after tests) see the instructions in the [master branch][master].
The [master branch][master] also has in depth configuration reference.

**NB** if you want to use more advanced features (push back to git or a different TeX scheme) you __MUST__ use the `.travis.yml`
from the **[master branch][master]**!


[1]: https://github.com/Strauman/travis-latexbuild/tree/master
[master]: https://github.com/Strauman/travis-latexbuild/tree/master
[tex-config.ini]: https://github.com/Strauman/travis-latexbuild/blob/quickstart/quickstart/.travis/tex-config.ini
[.travis.yml]: https://github.com/Strauman/travis-latexbuild/blob/quickstart/quickstart/.travis.yml
[travis]: https://travis-ci.org

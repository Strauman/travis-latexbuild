## Quickstart
Quickstart build status: [![Build Status](https://travis-ci.org/Strauman/travis-latexbuild.svg?branch=quickstart)](https://travis-ci.org/Strauman/travis-latexbuild)

**NB** if you want to use more advanced features you __MUST__ use the `.travis.yml`
from the **[master branch][master]**!

In your repo, you need two files from this branch: the [`.travis.yml`][.travis.yml]-file and the [`.travis/tex-config.ini`][tex-config.ini].

### Steps:

1. Copy the [`.travis.yml`][.travis.yml] file from this repo to the root of your git repository
1. Copy the [`.travis/tex-config.ini`][tex-config.ini] file from this repo to `.travis/tex-config.ini` in **your** repo.
1. Profits

Configure the `.travis/tex-config.ini` to your needs. For more advanced options
(e.g. push pdfs back to git repo after tests) see the instructions in the [master branch][master].
The [master branch][master] also has in depth configuration reference.

**NB** if you want to use more advanced features you __MUST__ use the `.travis.yml`
from the **[master branch][master]**!


[master]: https://github.com/Strauman/travis-latexbuild/tree/master
[tex-config.ini]: https://github.com/Strauman/travis-latexbuild/blob/quickstart/quickstart/.travis/tex-config.ini
[.travis.yml]: https://github.com/Strauman/travis-latexbuild/blob/quickstart/quickstart/.travis.yml

1. Add the `.travis.yml` and `.travis/push.sh` to your root in github repo
1. In your root git directory make a `tests/` folder
1. Inside the `tests/` folder make a new folder with the name of a test. E.g. `tests/testmyfeature/`
1. Inside that folder (`tests/testmyfeature/`) create a `main.tex`, which will be run
1. The PDFs of all the tests will be pushed to a branch called `travis-#NO` (where #NO is the travis build number).
- If `tests/testmyfeature/main.tex` is supposed to fail, then you should make a file `tests/testmyfeature/wants-fail`
- If you need extra packages, then add a file `tests/packages` containing a space separated list of packages
- You can put whatever files you want into the `tests` dir, but if you add a directory that contains a `main.tex`-file, it will be executed.
- By default, the `tests` dir is loaded to the `/src` volume
- By default, the entire repository is loaded to the `/repo` volume

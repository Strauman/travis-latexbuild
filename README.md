1. In your root git directory make a `tests/` folder
1. Inside the `tests/` folder make a new folder with the name of a test. E.g. `tests/testmyfeature/`
1. Inside that folder (`tests/testmyfeature/`) create a `main.tex`, which will be run
- If `tests/testmyfeature/main.tex` is supposed to fail, then you should make a file `tests/testmyfeature/wants-fail`
- If you need extra packages, then add a file `tests/packages` containing a space separated list of packages
- The `tests` dir is the only directory loaded into the docker.
- You can put whatever files you want into the `tests` dir, but if you add a directory that contains a `main.tex`-file, it will be executed.

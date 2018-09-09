#!/bin/sh
function echo_errors(){
  if [ -f "tmpstderror" ];then
    echo "!!!ERR:-----------------------";
    cat tmpstderror;
  fi
  if [ -f "tmpstderror" ];then
    echo "----------:::::::::----------";
    echo "!!!OUT:-----------------------";
    cat tmpstderror;
  fi
  echo "----------:::::::::----------";
}
repo_dir="/repo"
tests_dir="${repo_dir}/tests"
main_dir=`pwd`
pdfsdir="${tests_dir}/pdfs"

if [ -f "${tests_dir}/packages" ]; then
  echo "Installing packages:"
  echo `cat ${tests_dir}/packages`
  tlmgr install `cat ${tests_dir}/packages`
fi

if [ -d "$pdfsdir" ]; then
  rm -rf "$pdfsdir"
fi
mkdir -p $pdfsdir
for dir in /${tests_dir}/*
do
  cd $main_dir;
  if [[ ! -d "${dir}" ]]; then
    # echo "${dir} is not a dir"
    continue
  fi
  if [[ ! -f "${dir}/main.tex" ]]; then
    # echo "${dir} does not have a main.tex file"
    continue
  fi
  cd ${dir}
  # latexmk -C
  latexmk -pdf --shell-escape -f -interaction=nonstopmode "main.tex" >tmpstdout 2>tmpstderror
  exitCode=$?
  echo "Exited with code $exitCode"
  dirbase=`basename ${dir}`
  # Do we want it to fail?
  if [ -f "${dir}/wants-fail" ]; then
    # Didn't fail!
    if [ "$exitCode" -eq "0" ]; then
      echo_errors
      echo "${dirbase} should have failed, but didn't."
      exit 2;
    else
      "Build of ${dirbase} failed, as expected"
    fi
  else
    if [ $exitCode -ne 0 ]; then
      echo_errors
      echo "${dirbase} failed, but didn't have the wants-fail file."
      echo "so it is an error"
      exit 1;
    else
      cp "main.pdf" "$pdfsdir/${dirbase}.pdf"
      echo "Test of ${dirbase} succeeded!"
    fi
  fi
  if [ -f "tmpstderror" ];then
    rm tmpstderror;
  fi
  if [ -f "tmpstdout" ];then
    rm tmpstdout;
  fi
  # latexmk -C
done
echo "All good!";
exit 0;

repo_dir="/repo";
pdfsdir="$repo_dir/pdfs"

if [ -f "$repo_dir/execute_tests_override.sh" ]; then
  chmod +x execute_tests_override.sh;
  ./execute_tests_override.sh;
  exitCode=$?;
  exit $exitCode;
fi

cd $repo_dir;
# read options
CONFIG_FILE=".travis/tex-config.ini";
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file $CONFIG_FILE does not exist!"
  exit 1;
fi

export build_patterns=$(awk -F "=" '/build-pattern/ {print $2}' "$CONFIG_FILE");
export packages=$(awk -F "=" '/packages/ {print $2}' "$CONFIG_FILE");
# Install packages
packages=${packages/$'\n'/}
packages=${packages/ /}
packages=${packages//,/ }
if [ ! -z "$packages" ]; then
  packages_comma=${packages// /, }
  echo "Installing packages $packages_comma"
  tlmgr install $packages
else
  echo "Not installing any packages";
fi
# Make dir for pdf output
if [ -d "$pdfsdir" ]; then
  rm -rf "$pdfsdir"
fi
mkdir -p "$pdfsdir"

# Run the tests
# First a function to produce output if something goes wrong:
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

for buildpattern in $(echo $build_patterns | sed "s/,/ /g")
do
  echo "BUILDING PATTERN $buildpattern"
  for texfile_full in ${buildpattern}
  do
    echo "BUILDING FILE $texfile_full"
    cd $repo_dir
    filename=$(basename -- "$texfile_full")
    extension="${filename##*.}"
    filename_base="${filename%.*}"
    # echo "FN: $filename"
    # echo "FNB: $filename_base"
    # filebase="${}"
    if [ ! "$extension" == "tex" ]; then
      echo "$texfile_full is not a .tex file!"
      exit 2
    fi
    dirname=`dirname $texfile_full`
    cd "$dirname";
    echo "Building $texfile_full"
    latexmk -C > /dev/null 2>/dev/null
    latexmk -pdf --shell-escape -f -interaction=nonstopmode "$filename" >tmpstdout 2>tmpstderror
    exitCode=$?
    # "Error when building $texfile_full.tex"
    # Did we want it to fail?
    if [ -f "$repo_dir/${dirname}/wants-fail" ]; then
      # Didn't fail!
      if [ "$exitCode" -eq "0" ]; then
        echo_errors
        echo "${texfile_full} should have failed, but didn't."
        exit 2;
      else
        echo "Build of ${texfile_full} failed, as expected ($exitCode)"
      fi
    else
      # Did not want it to fail
      if [ $exitCode -ne 0 ]; then
        echo_errors
        echo "${texfile_full} failed, but didn't have the wants-fail file."
        echo "so it is an error"
        exit 1;
      else
        # cp "${filename_base}.pdf" "$pdfsdir/${filename_base}.pdf"
        # git add ${filename_base}.pdf
        echo "Test of ${texfile_full} succeeded!"
      fi
    fi
    [[ -f "tmpstdout" ]] && rm "tmpstdout"
    [[ -f "tmpstderror" ]] && rm "tmpstderror"
  done
done

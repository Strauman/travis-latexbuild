#!/bin/sh

repo_dir="/repo";
pdfsdir="$repo_dir/pdfs"

# function to produce output if something goes wrong:
function echo_errors(){
  if [ -f "tmpstderror" ];then
    echo "!!!ERR:-----------------------";
    cat tmpstderror;
  fi
  if [ -f "tmpstdout" ];then
    echo "----------:::::::::----------";
    echo "!!!OUT:-----------------------";
    cat tmpstdout;
  fi
  echo "----------:::::::::----------";
}

# Check if an override file exists

if [ -f "$repo_dir/execute_tests_override.sh" ]; then
  chmod +x execute_tests_override.sh;
  ./execute_tests_override.sh;
  exitCode=$?;
  exit $exitCode;
fi
# Make sure we are in the git repo root
cd $repo_dir;
# read options
CONFIG_FILE=".travis.yml";
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file $CONFIG_FILE does not exist!"
  exit 1;
fi

# ---- BEGIN PARSE OPTIONS
# ---- PACKAGES:
# Read option from .INI file
export packages=$(awk -F "=" '/packages/ {print $2}' "$CONFIG_FILE");
# remove all spaces (no packages contains spaces)
packages=${packages// /}
# Remove all commas (since they are delimiters in package list)
# and make them into spaces (which are the way texlive want them)
packages=${packages//,/ }
# Remove any newlines (because it will have a newline if it's empty)
packages=${packages//$'\n'/}
# If we have packages to install
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

# ---- LATEXMK FLAGS
# Read option from .INI file
export buildflags=$(awk -F "=" '/latexmk-flags/ {print $2}' "$CONFIG_FILE");

# --- STRIP BUILDPATTERNS
# Read option from .INI file
export build_patterns=$(awk -F "=" '/build-pattern/ {print $2}' "$CONFIG_FILE");
# Remove spaces before and after commas
build_patterns="`perl -E '$_=$ENV{build_patterns}; s/\s*,\s*/,/g; s/^\s*//g;s/\s*$//g; print;'`"
# build_patterns might have file names that contains spaces, so
# replacing the spaces with illegal filename character: <
build_patterns=${build_patterns// /'<'}
for texfile_full in $(echo $build_patterns | sed "s/,/ /g")
do
  # Substitute back from '<' and escape spaces:
  export texfile_full=$texfile_full;
  texfile_full="`perl -E '$_=$ENV{texfile_full}; s/</\\\ /g; print;'`"
  echo "BUILDING FILE $texfile_full"
  cd $repo_dir
  filename=$(basename -- "$texfile_full")
  extension="${filename##*.}"
  filename_base="${filename%.*}"
  if [ ! "$extension" == "tex" ]; then
    echo "$texfile_full is not a .tex file!"
    exit 2
  fi
  dirname=`dirname $texfile_full`
  # Check if file (and relative dir) exists
  if [[ ! -d "$dirname" || ! -f "$texfile_full" ]]; then
    echo "Couldn't find file $texfile_full for testing.";
    exit 1;
  fi
  cd "$dirname";
  echo "Building $texfile_full"
  latexmk -C ${buildflags} > /dev/null 2>/dev/null
  latexmk -pdf --shell-escape -f -interaction=nonstopmode ${buildflags} "$filename" >tmpstdout 2>tmpstderror
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

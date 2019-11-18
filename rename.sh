#!/usr/bin/env bash

#/*============================================================================
#
#  CMakeTemplateRenamer: A script to generate new projects from our templates.
#
#  Copyright (c) University College London (UCL). All rights reserved.
#
#  This software is distributed WITHOUT ANY WARRANTY; without even
#  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#  PURPOSE.
#
#  See LICENSE.txt in the top level directory for details.
#
#============================================================================*/

if [ $# -ne 8 -a $# -ne 9 ]; then
  echo "Usage: rename.sh A B C D E F G H [optional I]"
  echo "Where:"
  echo "  A: is the folder you want to clone."
  echo "  B: is the new folder name you want to create."
  echo "  C: is the new project name all in CamelCase."
  echo "  D: is new project name all in lowercase."
  echo "  E: is new project name all in UPPERCASE."
  echo "  F: is a short 1 line description, in double quotes."
  echo "  G: is the new namespace without :: specifiers."
  echo "  H: is either Y or N, meaning yes/no to drop the git history."
  echo "  I: if specified is the new python module name."
  exit
fi

OLD_PROJECT_DIR=$1
NEW_PROJECT_DIR=$2
NEW_PROJECT_NAME_CAMEL_CASE=$3
NEW_PROJECT_NAME_LOWER_CASE=$4
NEW_PROJECT_NAME_CAPS=$5
NEW_SHORT_DESCRIPTION=$6
NEW_NAMESPACE=$7
DROP_GIT_HISTORY=$8
PYTHON_MODULE=
if [ $# -eq 9 ]; then
  PYTHON_MODULE=$9
fi

######################################################
# Strings to replace
######################################################
OLD_PROJECT_NAME_CAMEL_CASE='MyProject'
OLD_PROJECT_NAME_LOWER_CASE='myproject'
OLD_PROJECT_NAME_CAPS='MYPROJECT'
OLD_DOXYGEN_INTRO='A software package for whatever.'
OLD_SHORT_DESCRIPTION='A software package for whatever.'
OLD_NAMESPACE='mp'

######################################################
# Bare bones validation.
######################################################
if [ -d ${NEW_PROJECT_DIR} ]; then
  echo "Error: ${NEW_PROJECT_DIR} already exists!"
  exit -1
fi

if [ ! -d ${OLD_PROJECT_DIR} ]; then
  echo "Error: ${OLD_PROJECT_DIR} does not exist!"
  exit -2
fi

if [ "${HOME}" = "" ]; then
  echo "Error: No HOME variable set!"
  exit -3
fi

######################################################
# Print out stuff before we do it.
######################################################
echo "Swapping \"${OLD_PROJECT_DIR}\" to \"${NEW_PROJECT_DIR}\""
echo "Swapping \"${OLD_PROJECT_NAME_CAMEL_CASE}\" to \"${NEW_PROJECT_NAME_CAMEL_CASE}\""
echo "Swapping \"${OLD_PROJECT_NAME_LOWER_CASE}\" to \"${NEW_PROJECT_NAME_LOWER_CASE}\""
echo "Swapping \"${OLD_PROJECT_NAME_CAPS}\" to \"${NEW_PROJECT_NAME_CAPS}\""
echo "Swapping \"${OLD_SHORT_DESCRIPTION}\" to \"${NEW_SHORT_DESCRIPTION}\""
echo "Swapping \"${OLD_NAMESPACE}::\" to \"${NEW_NAMESPACE}::\""
echo "Dropping git history:${DROP_GIT_HISTORY}"
if [ $# -eq 9 ]; then
  echo "Python module:${PYTHON_MODULE}"
fi

######################################################
# Get user agreement.
######################################################
echo "Is this OK? [Y|N]"
read USER_AGREEMENT

if [ "${USER_AGREEMENT}" != "Y" ]; then
  echo "You did not type exactly \"Y\", so this script is exiting."
  exit 0
else
  echo "Starting."
fi

######################################################
# Clone repo.
######################################################
cp -r ${OLD_PROJECT_DIR} ${NEW_PROJECT_DIR}
echo "Copied \"${OLD_PROJECT_DIR}\" to \"${NEW_PROJECT_DIR}\"."

######################################################
# Run within new repo.
######################################################
cd ${NEW_PROJECT_DIR}
echo "Current working dir:"
pwd

######################################################
#### Replacements ###
######################################################

move_command="mv"
is_git_repo=`find . -type d -name "[.]git" | wc -l`
if [ ${is_git_repo} -gt 0 ]; then
  echo "Running on a git repository."
  move_command="git mv --force"
fi

find_and_replace_string(){
    echo "Swapping string \"${1}\" with \"${2}\" "
    find . -type f | grep -v "[.]git" | grep -v "[.]idea" | grep -v "3rdParty" | grep -v "multibuild" > $HOME/tmp.$$.files.txt
    for f in `cat $HOME/tmp.$$.files.txt`
    do
      wc1=`file $f | grep text | wc -l`
      wc2=`file --mime $f | grep "application/xml" | wc -l`
      if [ ${wc1} -gt 0 -o ${wc2} -gt 0 ]; then
        cat $f | sed s/"$1"/"$2"/g > $HOME/tmp.$$.file.txt
        mv $HOME/tmp.$$.file.txt $f
      fi
    done
    rm $HOME/tmp.$$.files.txt
    echo "Swapping string \"${1}\" with \"${2}\" - DONE. "
}

find_and_replace_filename(){
    echo "Swapping filename part \"$1\" with \"$2\" "
    find . -name "*$1*" > $HOME/tmp.far.$$.files.txt
    wc=`cat $HOME/tmp.far.$$.files.txt | wc -l`
    if [ $wc -gt 0 ]; then
      change_name_command="cat $HOME/tmp.far.$$.files.txt | sed -e \"p;s/${1}/${2}/\" | xargs -n2 ${move_command}"
      eval ${change_name_command}
    fi
    rm $HOME/tmp.far.$$.files.txt
    echo "Swapping filename part \"$1\" with \"$2\" - DONE. "
}

find_and_replace_filename_and_string(){
    find_and_replace_filename $1 $2
    find_and_replace_string $1 $2
}

# Change comment at top of each file describing project
find_and_replace_string "${OLD_SHORT_DESCRIPTION}" "${NEW_SHORT_DESCRIPTION}"

# Change Doxygen intro
find_and_replace_string "${OLD_DOXYGEN_INTRO}" "${NEW_SHORT_DESCRIPTION}"

# These are special cases just for CMakeCatchTemplate project
find_and_replace_string "CMakeCatchTemplatePython" "${PYTHON_MODULE}"
find_and_replace_string "CMakeCatchTemplate" "${NEW_PROJECT_DIR}"

# Replace name MyProject, myproject, MYPROJECT etc.
find_and_replace_string "${OLD_PROJECT_DIR}" "${NEW_PROJECT_DIR}"
find_and_replace_string "${OLD_PROJECT_NAME_CAMEL_CASE}" "${NEW_PROJECT_NAME_CAMEL_CASE}"
find_and_replace_string "${OLD_PROJECT_NAME_LOWER_CASE}" "${NEW_PROJECT_NAME_LOWER_CASE}"
find_and_replace_string "${OLD_PROJECT_NAME_CAPS}" "${NEW_PROJECT_NAME_CAPS}"

# namespace
find_and_replace_string "namespace ${OLD_NAMESPACE}" "namespace ${NEW_NAMESPACE}"
find_and_replace_string "${OLD_NAMESPACE}::" "${NEW_NAMESPACE}::"

# Filename replacements
find_and_replace_filename "${OLD_PROJECT_NAME_CAMEL_CASE}" "${NEW_PROJECT_NAME_CAMEL_CASE}"
find_and_replace_filename "${OLD_PROJECT_NAME_LOWER_CASE}" "${NEW_PROJECT_NAME_LOWER_CASE}"
find_and_replace_filename "${OLD_PROJECT_NAME_CAPS}" "${NEW_PROJECT_NAME_CAPS}"

# mp prefixes
nc=`echo ${OLD_NAMESPACE} | wc -c | tr -d '[:space:]'`
for g in .h .cpp .ui .cmake
do
  find . -name "${OLD_NAMESPACE}*${g}" | grep -v "[.]git" | grep -v "[.]idea" | grep -v "3rdParty" | grep -v "multibuild" > $HOME/tmp.$$.${OLD_NAMESPACE}.${g}.txt
  for f in `cat $HOME/tmp.$$.${OLD_NAMESPACE}.${g}.txt`
  do
    basename $f $g | cut -c ${nc}-10000 >> $HOME/tmp.$$.prefixes.txt
  done
  rm $HOME/tmp.$$.${OLD_NAMESPACE}.${g}.txt
done
cat $HOME/tmp.$$.prefixes.txt | sort -u > $HOME/tmp.$$.prefixes.sorted.txt
for f in `cat $HOME/tmp.$$.prefixes.sorted.txt`
do
  echo "${f}\.cpp" >> $HOME/tmp.$$.prefixes.all.txt
  echo "${f}_h" >> $HOME/tmp.$$.prefixes.all.txt
  echo "${f}\.h" >> $HOME/tmp.$$.prefixes.all.txt
  echo "${f}\.ui" >> $HOME/tmp.$$.prefixes.all.txt
  echo "${f}" >> $HOME/tmp.$$.prefixes.all.txt
done

declare -a file_names=(`cat $HOME/tmp.$$.prefixes.all.txt`)
for i in "${file_names[@]}"
do
    find_and_replace_filename_and_string "${OLD_NAMESPACE}${i}" "${NEW_NAMESPACE}${i}"
done

REMOTE_ORIGIN=`git remote -v | grep origin | tail -1 | cut -f 1 -d " " | cut -c 8-1000`
git remote remove origin

if [ "${DROP_GIT_HISTORY}" == "Y" ]; then
  HASH=`git log --oneline | tail -1 | cut -f 1 -d " "`
  git reset --soft ${HASH}
  git add .
  GIT_COMMITTER_DATE=`date`
  git commit --amend --no-edit --date "${GIT_COMMITTER_DATE}" -m "Initial commit" -m "Generated from ${REMOTE_ORIGIN}."
  for t in `git tag`
  do
    git tag --delete ${t}
  done
else
  git add .
  git commit --no-edit -a -m "Generated from ${OLD_PROJECT_DIR}." -m "See ${REMOTE_ORIGIN}."
fi

echo "Tidying up."

rm $HOME/tmp.$$.prefixes.txt
rm $HOME/tmp.$$.prefixes.sorted.txt
rm $HOME/tmp.$$.prefixes.all.txt

echo "Finished."
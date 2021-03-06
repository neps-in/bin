#!/bin/bash
set -e
set -o pipefail

##############################################################################
# Find any dirty git projects in the current working directory
# and recursively beneath this directory
#
# USAGE:
# finddirtygit
#   Quiet mode that outputs only the project that is dirty
# finddirtygit -v
#   Verbose mode that outputs what files are dirty
##############################################################################

# Find all directories that have a .git directory in them
for gitprojpath in $(find . -type d -name .git | sed "s/\/\.git//"); do
  # Save the current working directory before CDing for git's purpose
  pushd . >/dev/null

  # Switch to the git-enabled project directory
  cd "$gitprojpath"

  # Are there any changed files in the status output?
  isdirty=$(git status -s | grep "^.*")
  if [ -n "$isdirty" ]; then
    # Should output be verbose?
    if [ "$1" = "-v" ]; then
      echo
      echo "DIRTY: $gitprojpath"
      git status -s
    # Or should output be quiet?
    else
      echo "DIRTY: $gitprojpath"
    fi
  fi
  # Return to the starting directory, suppressing the output
  popd >/dev/null
done

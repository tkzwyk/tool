if [ $# -ne 1 ]; then
  # If shell is zsh, $0 is used
  script_full_path=${BASH_SOURCE:-$0}
  echo "Usage : source $script_full_path <ssh private key>"
  return 2> /dev/null
  exit 1
fi

eval `ssh-agent`

ssh-add $1

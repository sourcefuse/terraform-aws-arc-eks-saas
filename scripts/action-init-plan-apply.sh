#!/bin/bash

set -e

EXTRA_ARGS=""
plan_id=$(git rev-parse --short "$GITHUB_SHA")
INIT=false
PLAN=false
APPLY=false

while getopts "hi:p:a:d:z:" option; do
  case $option in
    h) #show help
    help
    ;;
    i) #initialise backend
    export ENV=$OPTARG
    INIT=true
    ;;
    p) #run plan
    export ENV=$OPTARG
    PLAN=true
    ;;
    a) #run apply
    export ENV=$OPTARG
    APPLY=true
    ;;
    d) #set directory
    DIRECTORY=$OPTARG
    ;;
    z) #pass extra arguments
    EXTRA_ARGS=$OPTARG
    ;;
    \?)
    echo "ERROR: Invalid option $option"
    echo "valid options are : [-i|p|a|d]"
    break;
    ;;
  esac
done

cleanup () {
  OPTIND=1
  unset EXTRA_ARGS
  unset DIRECTORY
  unset INIT
  unset PLAN
  unset APPLY
}

help () {
    help () {
   printf "Script to run terraform actions in github actions. Source this with arguments\n"

   printf "\n"
   printf "Syntax: [-h|i|p|a|d|z]\n"
   printf "options:\n"
   printf "h     Print this help menu.\n"
   printf "i     run terraform init\n"
   printf "p     run terraform plan against passed env (requires env as argument)\n"
   printf "a     run terraform apply against passed env (requires env as argument)\n"
   printf "d     !!REQUIRED!! directory inside terraform/ in this repo to run terraform commands on\n"
   printf "\n"
}
}

check_dir() {
 ! [ -d "terraform/$DIRECTORY" ]
}

init () {
  cd terraform/$DIRECTORY
  terraform init -backend-config config.hcl $EXTRA_ARGS
  terraform workspace list
}

plan () {

  cd terraform/$DIRECTORY
  PLAN_FILENAME=$ENV-$(basename $DIRECTORY)-$plan_id.tfplan
  terraform plan $EXTRA_ARGS -out $PLAN_FILENAME
  PLAN_OUTPUT=$(terraform show -no-color $PLAN_FILENAME)

  echo "<details><summary>Terraform plan output for $DIRECTORY in $ENV</summary>" >> $ENV-plan-output.txt
  echo "" >> $ENV-plan-output.txt
  echo "\`\`\`text" >> $ENV-plan-output.txt
  echo "" >> $ENV-plan-output.txt
  echo "$PLAN_OUTPUT" >> $ENV-plan-output.txt
  echo "" >> $ENV-plan-output.txt
  echo "\`\`\`" >> $ENV-plan-output.txt
  echo "</details>" >> $ENV-plan-output.txt

}

apply () {

  cd terraform/$DIRECTORY
  terraform apply -auto-approve $EXTRA_ARGS $ENV-$DIRECTORY-$plan_id.tfplan

}

main () {
  if check_dir;
  then
    echo "ERROR: Invalid value for directory : directory $DIRECTORY does not exist within current directory"
  return 1;
  fi

  if [[ ! $ENV =~ ^(poc|dev|qa|stage|prod)$ ]];
  then
    echo "Invalid environment $ENV passed with plan/apply option"
  return
  fi

  if $INIT;
  then
    init
    return $?
  fi

  if $PLAN;
  then
    plan
    return $?
  fi

  if $APPLY;
  then
    apply
    return $?
  fi

}

main
cleanup
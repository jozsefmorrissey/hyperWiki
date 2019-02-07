#!/usr/bin/env bash

source ./passwordServer/BashScripts/commandParser.sh
# Save propertys and create passwords to passwordServer
sudo confidentalInfo.sh selfDistruct UserSrvc

installJdbcs() {
  for filename in ./config/jars/*
  do
    version=$(echo $filename | sed "s/^.*-\([^-]*\).jar$/\1/")
    artifact=$(echo $filename | sed "s/^.*\/\([^\/]*\)-.*.jar$/\1/")
    mvn install:install-file -DgroupId=com.oracle -DartifactId=$artifact -Dversion=$version -Dpackaging=jar -Dfile=$filename -DgeneratePom=true
  done
}

setupProperties() {
  echo setting up Properties...
  ./passwordServer/BashScripts/properties.sh each ./config/global_${flags[env]}.properties "confidentalInfo.sh update k: v:"
  ./passwordServer/BashScripts/properties.sh each ./config/password_${flags[env]}.properties "sudo confidentalInfo.sh update k: v:"
}

setupDataBase() {
  user=$(confidentalInfo.sh value UserSrvc dbUser)
  sqlCmd="select USERNAME from dba_users where username='$user';\nexit"
  sqlOut=$(echo -e $sqlCmd | sqlplus system/42CkyzXzGu3tjTe8@localhost:1521/xe)
  noRowsTxt=$(echo $sqlOut | grep -oP "no rows selected")
  if [ "${booleans[db]}" == "true" ]
  then
    echo Setting up DataBase
    cd ./UserServer/Setup\ files/DATA\ BASE/
    password=$(sudo confidentalInfo.sh value UserSrvc dbPass)
    ./runSimpleSetup.sh
    cd ../../../
  fi
}


installJdbcs
setupProperties
setupDataBase

#!/usr/bin/env bash

source ./PasswordServer/BashScripts/commandParser.sh
# Save propertys and create passwords to passwordServer
sudo confidentalInfo.sh selfDistruct UserSrvc

installJdbcs() {
  jars=$(find ./config/jars/ -name "*.jar")
  echo $jars
  # for filename in ./config/jars/*
  # do
  #   version=$(echo $filename | sed "s/^.*-\([^-]*\).jar$/\1/")
  #   artifact=$(echo $filename | sed "s/^.*\/\([^\/]*\)-.*.jar$/\1/")
  #   mvn install:install-file -DgroupId=com.oracle -DartifactId=$artifact -Dversion=$version -Dpackaging=jar -Dfile=$filename -DgeneratePom=true
  # done
}

setupProperties() {
  echo setting up Properties...
  ./PasswordServer/BashScripts/properties.sh each ./config/global_${flags[env]}.properties "confidentalInfo.sh update k: v:"
  ./PasswordServer/BashScripts/properties.sh each ./config/password_${flags[env]}.properties "sudo confidentalInfo.sh update k: v:"
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

setupMcTemplates() {
  mc -name userSrvc template -od ./UserServer/server/ "./cleanRun.sh"
  mc -name collab template -od ./collabStr/ "node ./webSocket.js"
  mc -name nodeServer template -od ./2TP/ "node ./server.js"
  mc -name passwordServer template -od ./PasswordServer/ "sudo confidentalInfo.sh start-server \$(confidentalInfo.sh value HLWA CONFIG_PORT)"
  mc -name webApp template -od ./2TP/ "npm start"
}

# setupMcTemplates
installJdbcs
# setupProperties
# setupDataBase

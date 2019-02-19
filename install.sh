#!/usr/bin/env bash

source ./PasswordServer/BashScripts/commandParser.sh

sudo apt-get install pwgen
sudo ./PasswordServer/installGlobal.sh
# Save propertys and create passwords to passwordServer
sudo confidentalInfo.sh selfDistruct UserSrvc

installJdbcs() {
  jars=$(find ./config/jars/ -name "*.jar")
  dependencyStr=""
  for filename in $jars
  do
    version=$(echo $filename | sed "s/^.*-\([^-]*\).jar$/\1/")
    artifact=$(echo $filename | sed "s/^.*\/\([^\/]*\)-.*.jar$/\1/")
    group=com.oracle
    dependencyStr+="<dependency><groupId>$group</groupId><artifactId>$artifact</artifact><version>$version</version></dependency>\n"
    mvn install:install-file -DgroupId=com.oracle -DartifactId=$artifact -Dversion=$version -Dpackaging=jar -Dfile=$filename -DgeneratePom=true
  done
  echo -e "$dependencyStr" > ./config/oracleDependencies.xml
}

setupProperties() {
  echo setting up Properties...
  ./PasswordServer/BashScripts/properties.sh each ./config/global_${flags[env]}.properties "confidentalInfo.sh update k: v:" $(boolStr) $(flagStr)
  ./PasswordServer/BashScripts/properties.sh each ./config/password_${flags[env]}.properties "sudo confidentalInfo.sh update k: v:" $(boolStr) $(flagStr)
  dbUrl=$(./PasswordServer/BashScripts/properties.sh value ./config/global_${flags[env]}.properties HLWA.DB_URL)
  ./PasswordServer/BashScripts/properties.sh update ./UserServer/server/src/main/resources/application-test.properties spring.datasource.url $dbUrl
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
  mc userSrvc template -od ./UserServer/server/ "./cleanRun.sh"
  mc collab template -od ./collabStr/ "node ./webSocket.js"
  mc nodeServer template -od ./2TP/ "node ./server.js"
  mc passwordServer template -od ./PasswordServer/ "sudo confidentalInfo.sh start-server \$(confidentalInfo.sh value HLWA CONFIG_PORT)"
  mc webApp template -od ./2TP/ "npm start"
  mc webAppConfig template -od ./2TP/ "node ./configServer.js"
}

setupMcTemplates
installJdbcs
setupProperties
# setupDataBase

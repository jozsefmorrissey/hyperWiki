#!/usr/bin/env bash

source ./passwordServer/BashScripts/commandParser.sh
# Save propertys and create passwords to passwordServer
sudo confidentalInfo.sh selfDistruct UserSrvc

setupProperties() {
  echo setting up Properties...
  ./passwordServer/BashScripts/properties.sh each ./global.properties "confidentalInfo.sh update k: v:"
  ./passwordServer/BashScripts/properties.sh each ./password.properties "sudo confidentalInfo.sh update k: v:"
}

setupDataBase() {
  user=$(confidentalInfo.sh value UserSrvc dbUser)
  sqlCmd="select USERNAME from dba_users where username='$user';\nexit"
  sqlOut=$(echo -e $sqlCmd | sqlplus system/42CkyzXzGu3tjTe8@localhost:1521/xe)
  noRowsTxt=$(echo $sqlOut | grep -oP "no rows selected")
   if [ "${booleans[c]}" != "true" ] && [ "$noRowsTxt" == "" ]
   then
     echo DataBase already setup
   else
     echo Setting up DataBase
     cd ./UserServer/Setup\ files/DATA\ BASE/
     password=$(sudo confidentalInfo.sh value UserSrvc dbPass)
     ./runSimpleSetup.sh
     cd ../../../
   fi
}


setupProperties
setupDataBase

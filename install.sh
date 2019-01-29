#!/usr/bin/env bash

# Save propertys and create passwords to passwordServer
setupProperties() {
  echo setting up Properties...
  ./BashScripts/properties.sh each ./global.properties "sudo confidentalInfo.sh update k: v:"
}

setupDataBase() {
  user=$(sudo confidentalInfo.sh value UserSrvc dbUser)
  sqlCmd="select USERNAME from dba_users where username='$user';\nexit"
  sqlOut=$(echo -e $sqlCmd | sqlplus system/42CkyzXzGu3tjTe8@localhost:1521/xe)
  noRowsTxt=$(echo $sqlOut | grep -oP "no rows selected")
   if [ "$noRowsTxt" == "" ]
   then
     echo DataBase already setup
   else
     echo Setting up DataBase
     cd ./UserServer/Setup\ files/DATA\ BASE/
     ./runSimpleSetup.sh
     cd ../../../
   fi
}


setupProperties
setupDataBase

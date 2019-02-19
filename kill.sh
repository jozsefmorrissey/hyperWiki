#!/usr/bin/env bash
source ./PasswordServer/BashScripts/debugLogger.sh

port=$(confidentalInfo.sh value HLWA CONFIG_PORT)
sudo confidentalInfo.sh stop-server $port

mc collab kill clear -d ${flags[d]}
mc nodeServer kill clear -d ${flags[d]}
mc webApp kill clear -d ${flags[d]}
mc userSrvc kill clear -d ${flags[d]}

#!/usr/bin/env bash
source ./PasswordServer/BashScripts/debugLogger.sh

port=$(confidentalInfo.sh value HLWA CONFIG_PORT)
sudo confidentalInfo.sh stop-server $port

mc collab kill clear $(boolStr) $(flagStr)
mc nodeServer kill clear $(boolStr) $(flagStr)
mc webApp kill clear $(boolStr) $(flagStr)
mc userSrvc kill clear $(boolStr) $(flagStr)
mc webAppConfig kill clear $(boolStr) $(flagStr)

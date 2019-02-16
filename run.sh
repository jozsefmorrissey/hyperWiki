#!/usr/bin/env bash

source ./PasswordServer/BashScripts/debugLogger.sh

sudo confidentalInfo.sh selfDistruct UserSrvc
# port=$(confidentalInfo.sh value HLWA CONFIG_PORT)
# sudo confidentalInfo.sh start-server $port

# target_term -set 4

mc passwordServer start $(boolStr) $(flagStr)
mc collab start $(boolStr) $(flagStr)
mc nodeServer start $(boolStr) $(flagStr)
mc webApp start $(boolStr) $(flagStr)
mc userSrvc start $(boolStr) $(flagStr)

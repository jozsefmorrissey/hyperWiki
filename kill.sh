#!/usr/bin/env bash
source ./PasswordServer/BashScripts/debugLogger.sh

mc passwordServer kill clear -d ${flags[d]}
mc collab kill clear -d ${flags[d]}
mc nodeServer kill clear -d ${flags[d]}
mc webApp kill clear -d ${flags[d]}
mc userSrvc kill clear -d ${flags[d]}

#!/usr/bin/env bash

sudo confidentalInfo.sh selfDistruct UserSrvc
port=$(confidentalInfo.sh value HLWA configPort)
sudo confidentalInfo.sh start-server $port

target_term -set 4

target_term -run 0 cd ./UserServer/server/
target_term -run 0 ./cleanRun.sh

target_term -run 1 cd ./2TP/
target_term -run 1 node ./server.js

target_term -run 2 cd ./2TP/
target_term -run 2 npm start

target_term -run 3 cd ./collabStr/
target_term -run 3 node ./webSocket.js

#!/usr/bin/env sh

AGENT_HOST=${AGENT_HOST:=localhost}
AGENT_PORT=${AGENT_PORT:=6831}

socat UDP4-RECVFROM:6831,fork UDP4-SENDTO:${AGENT_HOST}:${AGENT_PORT} &

cd /root/hotrod

./hotrod --bind 0.0.0.0 --port 8080 frontend &
./hotrod --bind 0.0.0.0 --port 8081 customer &
./hotrod --bind 0.0.0.0 --port 8082 driver   &
./hotrod --bind 0.0.0.0 --port 8083 route

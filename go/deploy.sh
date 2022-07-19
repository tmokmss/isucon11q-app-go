#!/bin/bash -x

echo "start deploy ${USER}"
BINARY='isucondition'
SERVICE='isucondition.go.service'

GOOS=linux go build -o $BINARY main.go
for server in isu1 isu2 isu3; do
    ssh -t $server "sudo systemctl stop ${SERVICE}"
    scp ./$BINARY $server:/home/isucon/webapp/go/
    ssh -t $server "sudo systemctl start ${SERVICE}"
done

echo "finish deploy ${USER}"

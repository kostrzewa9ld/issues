#!/usr/bin/env bash

export DOCKER_HOST= #10.9.4.172

HOSTS="" #"10.9.4.209 10.9.4.217 10.9.4.172"

echo "Restaring nodes..."
(for host in $HOSTS; do sshpass -p packer ssh packer@$host "sudo reboot"; sleep $((10 + $RANDOM % 10)); done) >/dev/null 2>&1

SLEEP_SECS=300

echo "Sleeping $SLEEP_SECS seconds to stabilize..."
sleep $SLEEP_SECS

echo "Checking if services are replicated..."
SVC_NUM=`docker service ls | grep -c "1/1"`
if [ $SVC_NUM != 3 ]; then
	echo "NOT ALL SERVICES ARE REPLICATED!!!"
fi
echo "Number of replicated services: $SVC_NUM"

MY_NET_SVC=`docker network inspect --verbose my_net --format '{{range \$key, \$val := .Services}}{{\$key}} {{end}}'`
echo "Services attached to my_net network: $MY_NET_SVC"

echo

set -e
for svc in postgres1 postgres2 postgres3; do
	echo "Checking service $svc..."
	docker run -it --rm --network my_net centos ping -c2 -W3 $svc
	if [ $? != 0 ]; then
		echo "failed!" 
		break
	fi
	echo "passed."
done
set +e

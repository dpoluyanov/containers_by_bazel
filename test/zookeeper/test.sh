#!/bin/bash

readonly zk_cli="/opt/zookeeper/bin/zkCli.sh -server 127.0.0.1:2181"

until $zk_cli create /test-word jimjams 2>&1 | grep '^Created /test-word' > /dev/null ; do
  sleep 5
done

until $zk_cli get /test-word 2>&1 | grep '^jimjams' > /dev/null ; do
  sleep 5
done

result=$($zk_cli get /test-word 2>&1)
echo "$result" | grep '^jimjams'
echo "$result" | grep '^dataLength = 7'

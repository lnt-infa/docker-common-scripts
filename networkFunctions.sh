#!/bin/bash

add-docker-nat-rules() {
  DEST_IP=$1
  DEST_PORT=$2
  sudo iptables -t nat -A POSTROUTING -s ${DEST_IP}/32 -d ${DEST_IP}/32 -p tcp -m tcp --dport ${DEST_PORT} -j MASQUERADE
  sudo iptables -t nat -A DOCKER ! -i docker0 -p tcp -m tcp --dport ${DEST_PORT} -j DNAT --to-destination ${DEST_IP}:${DEST_PORT}
  sudo iptables -t filter -A DOCKER -d ${DEST_IP}/32 ! -i docker0 -o docker0 -p tcp -m tcp --dport ${DEST_PORT} -j ACCEPT
}


del-docker-nat-rules() {
  DEST_IP=$1
  DEST_PORT=$2
  sudo iptables -t nat -D POSTROUTING -s ${DEST_IP}/32 -d ${DEST_IP}/32 -p tcp -m tcp --dport ${DEST_PORT} -j MASQUERADE
  sudo iptables -t nat -D DOCKER ! -i docker0 -p tcp -m tcp --dport ${DEST_PORT} -j DNAT --to-destination ${DEST_IP}:${DEST_PORT}
  sudo iptables -t filter -D DOCKER -d ${DEST_IP}/32 ! -i docker0 -o docker0 -p tcp -m tcp --dport ${DEST_PORT} -j ACCEPT
}


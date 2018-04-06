#!/bin/bash

# {{{ update_dns
function consul_update_dns() {
  consul_port=8500
  h=`hostname -a`
  d=`cat /etc/resolv.conf | grep nameserver | awk '{print($2)}' | head -1` 

  n=`curl -s http://${d}:${consul_port}/v1/catalog/nodes/${h}`
  ip_old=`echo $n | python -c "import sys, json; print json.load(sys.stdin)['Node']['Address']"`
  ip_new=`hostname -I | tr -d " "`
 
  if [ "${ip_old}" != "${ip_new}" ]; then
    dc=`echo $n | python -c "import sys, json; print json.load(sys.stdin)['Node']['Datacenter']"`
    curl -s -X PUT -d "{\"Datacenter\": \"$dc\", \"Node\": \"$h\",
       \"Address\": \"$ip_new\"
      }" http://${d}:${consul_port}/v1/catalog/register
  fi
}
#}}}

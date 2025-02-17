#!/bin/bash

DIR=$(dirname "$(readlink -f "$0")")

nodechk=$(cat <<EOF
curl -s 127.0.0.1:9100/metrics | grep "node_cpu_seconds_total" > /dev/null 2>&1 ; 
[ $? -eq 0 ] && echo -e "\n\nnode_exporter OK\n\n" || echo -e "\n\nnode_exporter FAIL\n\n"
EOF
)

for ip in `cat ip.list` ; do
    ssh -o StrictHostKeyChecking=no root@$ip -p 22 "bash /root/openvpn/buildVPN.sh"
    ssh -o StrictHostKeyChecking=no root@$ip -p 22 "if [[ -e /root/openvpn/openvpn.ovpn ]] && echo "okok""
    ssh -o StrictHostKeyChecking=no root@$ip -p 22 "docker run -d -p 9100:9100 --name=node_exporter prom/node-exporter"
    sleep 5s
    ssh -o StrictHostKeyChecking=no root@$ip -p 22 "echo $nodechk | bash"

    mkdir -p $DIR/download/$ip
    scp -o StrictHostKeyChecking=no -P 22 root@$ip:/root/openvpn/passwd $DIR/download/$ip/$ip-pwd.txt
    scp -o StrictHostKeyChecking=no -P 22 root@$ip:/root/openvpn/openvpn.ovpn $DIR/download/$ip/$ip-opvpn.ovpn
    sleep 2s
done

echo -e "\n===Add node exporter targets===\n"
echo -e "File : /your_path/monitor/office-monitor/prometheus/target/node-exporter/target-openvpn.yml\n"

for line in `cat ip.list` ; do
echo "- targets:
   - \"$line:9100\"
  labels:
    instance: \"$line\"
    use: openvpn
    group: aws
   "
done

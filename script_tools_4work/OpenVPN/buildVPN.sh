#!/bin/bash
cd /root/openvpn
rm -f *.ovpn passwd
rm -rf openvpn-data
bash /root/pass-gene > /root/openvpn/passwd

docker-compose run --rm ${services_name} ovpn_genconfig -u udp://${ip}
docker-compose run --rm ${services_name} ovpn_genconfig -e 'duplicate-cn'

expect ./expt.sh

docker-compose run --rm ${services_name} ovpn_getclient "$CLIENTNAME" > "$CLIENTNAME.ovpn"

sed -i -e "s/remote ${ip} 1194 udp/remote ${ip} your-port udp/" openvpn.ovpn

docker-compose up -d ${services_name}

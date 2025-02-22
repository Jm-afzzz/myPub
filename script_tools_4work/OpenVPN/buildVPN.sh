#!/bin/bash
DIR=$(dirname "$(readlink -f "$0")")
rm -f $DIR/*.ovpn $DIR/passwd
rm -rf $DIR/openvpn-data
bash /root/pass-gene.sh > $DIR/passwd

docker compose run --rm ${SRV_NM} ovpn_genconfig -u udp://${IP}
docker compose run --rm ${SRV_NM} ovpn_genconfig -e 'duplicate-cn'

expect $DIR/ovpn_init.expt

docker compose run --rm ${SRV_NM} ovpn_getclient "$CLIENTNAME" > "$CLIENTNAME.ovpn"

sed -i -e "s/remote ${IP} 1194 udp/remote ${IP} ur-port udp/" $CLIENTNAME.ovpn

docker compose up -d ${SRV_NM}

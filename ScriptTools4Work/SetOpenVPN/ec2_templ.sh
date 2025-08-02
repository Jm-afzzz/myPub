#!/bin/bash

cat > /root/dkinstall.sh <<EOF
sudo apt-get update
sudo apt-get install -y git ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
EOF
bash /root/dkinstall.sh && rm -f /root/dkinstall.sh

apt-get install -y expect

cat > /root/pass_gene.sh <<EOF
#!/bin/bash
array=( % \\# \
a b c d e f g h i j k m n o p q r s t u v w x y z \
0 1 2 3 4 5 6 7 8 9 \
A B C D E F G H I J K L M N P Q R S T U V W X Y Z)

mun=\`echo \${#array[@]}\`
quota=1
length=12

for x in \`seq 1 \$quota\`
do
        for i in \`seq 1 \$length\`
        do
                echo -n "\${array[\$((RANDOM%\${mun}))]}"
        done
        echo
done
EOF

echo -e \
"export SRV_NM=\"openvpn\"\n\
export CLIENTNAME=\"openvpn\"\n\
export IP=\`curl -s ipinfo.io | sed -n '2p' | cut -d '\"' -f 4\`" >> /root/.bashrc

mkdir /root/openvpn

cat > /root/openvpn/docker-compose.yml <<EOF
services:
  openvpn:               
    cap_add:
     - NET_ADMIN
    image: kylemanna/openvpn
    container_name: openvpn     
    ports:
     - "31095:1194/udp"  
    restart: always
    volumes:
     - ./openvpn-data/conf:/etc/openvpn
EOF

cat > /root/openvpn/ovpn_init.expt <<EOF
#!/usr/bin/expect -f

set services_name "\$env(SRV_NM)"
set cli_name "\$env(CLIENTNAME)"
set password [exec cat /root/openvpn/passwd]

spawn docker compose run --rm \${services_name} ovpn_initpki
expect "Enter New CA Key Passphrase"
send "\$password\n"
expect "Re-Enter New CA Key Passphrase"
send "\$password\n"
expect "Common Name (eg: your user, host, or server name) \[Easy-RSA CA\]"
send "\$cli_name\n"
expect "Enter pass phrase for /etc/openvpn/pki/private/ca.key"
send "\$password\n"
expect "Enter pass phrase for /etc/openvpn/pki/private/ca.key"
send "\$password\n"
interact

spawn docker compose run --rm \${services_name} easyrsa build-client-full "\$cli_name"
expect "Enter PEM pass phrase"
send "\$password\n"
expect "Verifying - Enter PEM pass phrase"
send "\$password\n"
expect "Enter pass phrase for /etc/openvpn/pki/private/ca.key"
send "\$password\n"
interact
EOF

cat > /root/openvpn/build_VPN.sh <<EOF
DIR=\$(dirname "\$(readlink -f "\$0")")
rm -f \$DIR/*.ovpn \$DIR/passwd
rm -rf \$DIR/openvpn-data
bash /root/pass-gene.sh > \$DIR/passwd

docker compose run --rm \${SRV_NM} ovpn_genconfig -u udp://\${IP}
docker compose run --rm \${SRV_NM} ovpn_genconfig -e 'duplicate-cn'

expect \$DIR/ovpn_init.expt

docker compose run --rm \${SRV_NM} ovpn_getclient "\$CLIENTNAME" > "\$CLIENTNAME.ovpn"

sed -i -e "s/remote \${IP} 1194 udp/remote \${IP} 31095 udp/" \$CLIENTNAME.ovpn

docker compose up -d \${SRV_NM}
EOF


#!/usr/bin/expect -f

set services_name "openvpn"
set password [exec cat /root/openvpn/passwd]
spawn docker-compose run --rm ${services_name} ovpn_initpki
expect "Enter New CA Key Passphrase"
send "$password\n"
expect "Re-Enter New CA Key Passphrase"
send "$password\n"
expect "Common Name (eg: your user, host, or server name) \[Easy-RSA CA\]"
send "openvpn\n"
expect "Enter pass phrase for /etc/openvpn/pki/private/ca.key"
send "$password\n"
expect "Enter pass phrase for /etc/openvpn/pki/private/ca.key"
send "$password\n"
interact

set CLIENTNAME "openvpn"
spawn docker-compose run --rm ${services_name} easyrsa build-client-full "$CLIENTNAME"
expect "Enter PEM pass phrase"
send "$password\n"
expect "Verifying - Enter PEM pass phrase"
send "$password\n"
expect "Enter pass phrase for /etc/openvpn/pki/private/ca.key"
send "$password\n"
interact

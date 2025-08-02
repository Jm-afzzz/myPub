#!/bin/bash

# create home dir for ubuntu
mkdir /home/ubuntu

# put in the script for installing docker and execute
cat > /home/ubuntu/dkinstall.sh <<EOF
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
bash /home/ubuntu/dkinstall.sh

# put in the script for pulling the image from dockerHub and execute
cat > /home/ubuntu/dkpull.sh <<EOF
echo 'xxxxxxxxxxx' > /home/ubuntu/dk-pwd.txt
cat /home/ubuntu/dk-pwd.txt | docker login --username usr --password-stdin
sudo docker pull dockerhub/img-name:tag
EOF
bash /home/ubuntu/dkpull.sh

# put in the script for running the container and logging the start-up result 
cat > /home/ubuntu/run-vrycdpy.sh <<EOF
#!/bin/bash

dt=\`date +%y/%m/%d\`
ctname=vry-code

run(){
sudo docker run -d --rm --name \$ctname -v /home/ubuntu/algoTrading_TW/poinTrading:/root/poinTrading dockerhub/img-name:tag bash -c "python3 verify_code_\$1.py"
}

chk(){
sudo docker ps -a | grep \$ctname | grep -i up
}

rmv(){
sudo docker rm -f \$ctname
}

### Main

cd ~/algoTrading_TW ; git pull

run \$1
sleep 4s
chk
if [ \$? -eq 0 ] ; then
    echo "\$dt  start-up OK" > ~/algoTrading_TW/poinTrading/dkrun.log 
else
    try=0
    while true ; do
        rmv && sleep 4s 
        try=\$((try+1))
        run \$1 && sleep 4s 
        chk 
        if [ \$? -eq 0 ] ; then
            echo "\$dt  start-up OK" > ~/algoTrading_TW/poinTrading/dkrun.log 
            break
        elif [ \$try -eq 5 ] ; then
            echo "\$dt  start-up FAIL" > ~/algoTrading_TW/poinTrading/dkrun.log
            rmv
            break
        fi
    done
fi
EOF

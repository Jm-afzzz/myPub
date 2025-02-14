# Build & Push docker img
1.install Docker on your host(EC2)

2.add Dockerfile to the goal dir on your host(EC2)

3.run Build_Push_Img.sh

# Create AWS Runner EC2s
1.add ec2templ.sh when you launch EC2 instances with User data input

2.keep the EC2 instance ids

# Start & Stop docker-runners
1.put the EC2 instance ids into variable(array) callled id_set in startup-ec2.sh and stop-ec2.sh

2.set crontab to exec startup-ec2.sh and stop-ec2.sh

# Architecture diagram
![d4runpy.png](https://github.com/Jm-afzzz/myPub/blob/main/Py%20web-crawler%20by%20Docker/d4runpy.png)

# Build & Push docker img
1.install Docker on your host(EC2)

2.add the Dockerfile to the goal dir on your host(EC2)

3.run build_push_img.sh

# Create AWS Runner EC2
1.add ec2_templ.sh when you launch EC2 instances with User data input

2.keep the EC2 instance ids

# Start & Stop docker-runners
1.put the EC2 instance ids into variable(array) callled id_set in startup_ec2.sh and stop_ec2.sh

2.set crontab to exec startup_ec2.sh and stop_ec2.sh

# Architecture diagram
![d4runpy.png](https://github.com/Jm-afzzz/myPub/blob/main/Dockerize_Py_Web-crawler/arch-diagram.png)

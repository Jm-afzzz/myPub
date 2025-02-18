::配合在Windows上設定工作排程器，用來定時開關AWS上的特定EC2機器

::開機
@echo off
start cmd /k "echo EC2 machine status & ^
aws ec2 describe-instances --filters ^"Name=instance-type,Values=ec2-type^" --query ^"Reservations[].Instances[].[Tags[].Value, InstanceId, PublicIpAddress, State.Name]^" --profile AWS-profile & ^
timeout /t 10 & ^
aws ec2 start-instances --instance-ids instance-id-1 instance-id-2 instance-id-3 instance-id-4 --profile AWS-profile & ^
timeout /t 40"

start cmd /k "echo EC2 machine new status && aws ec2 describe-instances --filters ^"Name=instance-type,Values=ec2-type^" --query ^"Reservations[].Instances[].[Tags[].Value, InstanceId, PublicIpAddress, State.Name]^" --profile AWS-profile" 

::關機
@echo off
start cmd /k "echo EC2 machine status & ^
aws ec2 describe-instances --filters ^"Name=instance-type,Values=ec2-type^" --query ^"Reservations[].Instances[].[Tags[].Value, InstanceId, PublicIpAddress, State.Name]^" --profile AWS-profile & ^
timeout /t 10 & ^
aws ec2 stop-instances --instance-ids instance-id-1 instance-id-2 instance-id-3 instance-id-4 --profile AWS-profile & ^
timeout /t 40"

start cmd /k "echo EC2 machine new status && aws ec2 describe-instances --filters ^"Name=instance-type,Values=ec2-type^" --query ^"Reservations[].Instances[].[Tags[].Value, InstanceId, PublicIpAddress, State.Name]^" --profile AWS-profile"

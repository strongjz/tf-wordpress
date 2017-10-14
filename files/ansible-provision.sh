#!/bin/bash -e

x=1
while [ $x -le 18 ]
do
  echo "Waiting On Userdata ${x}/18"
  x=$(( $x + 1 ))
  sleep 10
done

unzip /home/ec2-user/ansible.zip

cd /home/ec2-user/ansible

/usr/local/bin/ansible-playbook -i hosts site.yml

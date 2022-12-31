#!/bin/bash
sudo apt update -y
sudo sed 's/PasswordAuthentication no/PasswordAuthentication yes/g' -i  /etc/ssh/sshd_config
sudo systemctl restart sshd
useradd ansible
echo "ansible:Password@1234" | sudo chpasswd
sudo usermod -a -G sudo ansible
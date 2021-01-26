#!/bin/sh
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get install -y \
    docker-ce=5:19.03.10~3-0~ubuntu-focal \
    docker-ce-cli=5:19.03.10~3-0~ubuntu-focal \
    containerd.io
sudo apt-get update
sudo usermod -aG docker ${username}
sudo cat /dev/zero | ssh-keygen -q -N ""
sudo iptables -A INPUT -p tcp --dport 6443 -j ACCEPT
mkdir -p /mnt/disks/ssd1
touch home/${username}/wait
cat << EOF >> /home/${username}/.ssh/authorized_keys
${ssh_auth_key}
EOF
cat << EOF >> /home/${username}/.ssh/id_rsa
${ssh_private_key}
EOF
cat << EOF >> /home/${username}/.ssh/id_rsa.pub
${ssh_public_key}
EOF
exit 0
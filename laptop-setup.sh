#!/bin/bash

# sudo echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# ssh-keygen -t ed25519
# google-chrome --profile-directory=YOUR_PROFILE_NAME 

#check k9s version here: https://github.com/derailed/k9s/releases
# alias sshk='ssh-agent && eval "$(ssh-agent)" && ssh-add ~/.ssh/id_ed25519 && ssh -A'
# alias vaulttoken="ssh hoantd@setup1v.itim.vn 'sudo cat /etc/coccoc/vault/token_admin' | xclip -sel clip"
# alias t3-phong-tho='ffplay rtsp://prometheus:prometheus@100.120.18.138:8554/t3-phong-tho'
# alias t2-phong-khach='ffplay rtsp://prometheus:prometheus@100.120.18.138:8554/t2-phong-khach'
# alias t2-phong-ngu='ffplay  rtsp://prometheus:prometheus@100.120.18.138:8554/t2-phong-ngu'
# alias t2-phong-bep='ffplay  rtsp://prometheus:prometheus@100.120.18.138:8554/t2-phong-bep'
# alias t1-san-chinh='ffplay rtsp://prometheus:prometheus@100.120.18.138:8554/t1-san-chinh'


k9s_version=v0.32.5
helm_verion=v3.15.3

apt_pkgs="curl git wget telegram-desktop apt-transport-https ca-certificates python3-pip python3 python3-venv konsole tmux ffmpeg calibre gpg smartmontool xclip vim"
snap_pkgs="snap kustomize terraform"

echo "#################################################################"
echo "Setup alias"
echo "alias kg='kubectl get -o wide'"  >> ~/.bashrc
echo "alias kd='kubectl describe'" >> ~/.bashrc
echo "alias kl='kubectl logs'" >> ~/.bashrc
echo "alias k='kubectl'" >> ~/.bashrc
echo "alias kus='kustomize build'" >> ~/.bashrc
source ~/.bashrc

echo "#################################################################"
echo "Install apt packages"
sudo apt update -y
for pkg in $apt_pkgs
do
  echo "Installing $pkg"
  sudo apt install $pkg -y
done

echo "#################################################################"
echo "Install snap packages"
for pkg in $snap_pkgs
do
  echo "Installing $snap_pkgs"
  sudo snap install $pkg
done

echo "#################################################################"
echo "Install ansible"
pip3 install ansible

echo "#################################################################"
echo "Install visual studio code"
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
sudo apt update
sudo apt install code -y

echo "#################################################################"
echo "Install helm"
wget https://get.helm.sh/helm-$helm_verion-linux-amd64.tar.gz -O /tmp/helm-$helm_verion-linux-amd64.tar.gz
tar -zxf /tmp/helm-$helm_verion-linux-amd64.tar.gz 
sudo mv linux-amd64/helm /usr/local/bin/helm

echo "#################################################################"
echo "Install k9s"
wget https://github.com/derailed/k9s/releases/download/$k9s_version/k9s_linux_amd64.deb -O k9s_linux_amd64.deb
sudo dpkg -i k9s_linux_amd64.deb
rm -rf k9s_linux_amd64.deb

echo "#################################################################"
echo "Install docker"
sudo apt-get update
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

echo "#################################################################"
echo "Install chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

echo "#################################################################"
echo "Install tailscale"
curl -fsSL https://tailscale.com/install.sh | sh

echo "#################################################################"
echo "Install kubelet"
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet


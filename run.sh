
export https_proxy=http://xx.xx.xx.xx:3128
export http_proxy=${https_proxy}
echo insecure > $HOME/.curlrc


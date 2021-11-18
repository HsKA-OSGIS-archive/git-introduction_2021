#!/bin/bash

if [ $(id -u) -ne 0 ]; then
  echo "This script must be run as root";
  exit 1;
fi

proxyport=8888
proxyurl="proxy.hs-karlsruhe.de"
unset proxyuser
unset proxypass
echo -n "Proxy Username:"
read proxyuser
prompt="Password:"
while IFS= read -p "$prompt" -r -s -n 1 char
do
    if [[ $char == $'\0' ]]
    then
         break
    fi
    prompt='*'
    proxypass+="$char"
done

#  gsettings set org.gnome.system.proxy mode 'manual' ;
#  gsettings set org.gnome.system.proxy.http host '$3';
#  gsettings set org.gnome.system.proxy.http port $4;
  
grep PATH /etc/environment > lol.t;
printf \
"http_proxy=http://$proxyuser:$proxypass@$proxyurl:$proxyport/\n\
https_proxy=http://$proxyuser:$proxypass@$proxyurl:$proxyport/\n\
ftp_proxy=http://$proxyuser:$proxypass@$proxyurl:$proxyport/\n\
no_proxy=\"localhost,127.0.0.1,localaddress,.localdomain.com\"\n\
HTTP_PROXY=http://$proxyuser:$proxypass@$proxyurl:$proxyport/\n\
HTTPS_PROXY=http://$proxyuser:$proxypass@$proxyurl:$proxyport/\n\
FTP_PROXY=http://$proxyuser:$proxypass@$proxyurl:$proxyport/\n\
NO_PROXY=\"localhost,127.0.0.1,localaddress,.localdomain.com\"\n" >> lol.t; 

cat lol.t > /etc/environment;
 
printf \
"Acquire::http::proxy \"http://$proxyuser:$proxypass@$proxyurl:$proxyport/\";\n\
Acquire::ftp::proxy \"ftp://$proxyuser:$proxypass@$proxyurl:$proxyport/\";\n\
Acquire::https::proxy \"http://$proxyuser:$proxypass@$proxyurl:$proxyport/\";\n" > /etc/apt/apt.conf.d/95proxies;
 
rm -rf lol.t;
printf "\n"

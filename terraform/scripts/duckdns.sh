mkdir duckdns
#!/bin/bash

mkdir /home/ubuntu/duckdns
echo 'echo url="https://www.duckdns.org/update?domains=patofofo&token=ec05fd47-e322-4935-a0b0-adb0cb198f60&ip=" | curl -k -o ~/duckdns/duck.log -K -' > /home/ubuntu/duckdns/duck.sh
chmod 700 duckdns/duck.sh

sudo chmod 755 /etc/cron.d

sudo echo '*/5 * * * * /home/ubuntu/duckdns/duck.sh >/dev/null 2>&1' >> /etc/cron.d/duck
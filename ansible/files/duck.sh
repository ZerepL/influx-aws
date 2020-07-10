#!/bin/bash

echo "Prepare DuckDNS script"
cat > /home/ubuntu/duckdns/duck.sh <<EOF
echo url="https://www.duckdns.org/update?domains=$1&token=$2&ip=" | curl -k -o /home/ubuntu/duckdns/duck.log -K -
EOF

chmod +x /home/ubuntu/duckdns/duck.sh

echo "Prepare DuckDNS cron"
cat > /etc/cron.d/duck <<EOF
*/5 * * * * ubuntu /home/ubuntu/duckdns/duck.sh >/dev/null 2>&1
EOF

echo "First run of duck.sh"
/home/ubuntu/duckdns/duck.sh
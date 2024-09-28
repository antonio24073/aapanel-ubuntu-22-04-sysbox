# adding postgres environment variables to bashrc example

sed -z -i "s/\nexport PATH=\/www\/server\/pgsql\/bin:\$PATH//g" /etc/bash.bashrc
echo "export PATH=/www/server/pgsql/bin:\$PATH"  >> /etc/bash.bashrc

source /etc/bash.bashrc
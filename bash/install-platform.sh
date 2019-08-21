mkdir /var/www /var/www/html
cp misc/index.html /var/www/html/
cp misc/motd /etc/

apt-get install openjdk-8-jdk git maven at vim mysql-client psmisc redis-server
env EDITOR=vim


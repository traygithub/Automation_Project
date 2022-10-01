netstat -antp
sudo apt-get -h
sudo apt-get update
sudo apt-get install apache2
systemctl status apache2
systemctl start  apache2
systemctl enable apache2
name="Traydev"
timestamp=$(date '+%d%m%y-%H%M%S')
cd /var/log/apache2
tar -cf /tmp/${name}-httpd-logs-${timestamp}.tar *.log

s3_bucket="upgrad-traydev"
aws s3 \
cp /tmp/${name}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${name}-httpd-logs-${timestamp}.tar

docroot="/var/www/html"
if [[ ! -f ${docroot}/inventory.html ]]; then
echo -e 'Log Type\t-\tTime Created\t-\tType\t-\tSize' > ${docroot}/inventory.html
fi

if [[ ! -f ${docroot}/inventory.html ]]; then
size=$(du -h /tmp/${name}-httpd-logs-${timestamp}.tar | awk '{print $1}')
echo -e "httpd-logs\t-\t${timestamp}\t\ttar\t-\t${size}" >> ${docroot}/inventory.html
fi

if [[ ! -f /etc/cron.d/automation ]];then
echo "* * * * * root /root/Automation_Project/automation.sh" >> /etc/cron.d/automation
fi

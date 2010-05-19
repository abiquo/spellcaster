rsync --delete -rtlz --exclude config/ --exclude log/ --exclude db/ --exclude public/generated/ . root@ruido.hq.abiquo.com:/var/www/spellcaster/
ssh root@ruido /etc/init.d/httpd reload

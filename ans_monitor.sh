#!/bin/bash

#Скрипт провеерки статуса сервера

#Имя хоста
host=`hostname`
#

#Внешний ip
ext_ip=`wget -qO- eth0.me`
#Место в opt
opt_size=`df -BG | awk '/opt/{print "Занято: " $3 " Свободно: " $4 }'`
#Место в корне
root_size=`df -BG | grep -wi /  | grep -v // | awk '{print "Занято: " $3 " Свободно: " $4 }'`
#Место в usr1cv83
size1c=`df -BG |awk '/usr1cv8/{print "Занято: " $3 " Свободно: " $4 }'`
#Место в backup
backup_size=`df -BG |awk '/backup/{print "Занято: " $3 " Свободно: " $4 }'`



echo "Сервер:                  $host"
echo "Внешний адрес:           $ext_ip"
echo "Место в opt:             $opt_size"
echo "Место в корне:           $root_size"
echo "Место в директории 1с:   $size1c"
echo "Размер бэкапа:           $backup_size"

#Статус службы 1с
c8status=`systemctl status srv1cv83 | grep -i active | awk '{print $2}'`

echo "Статус службы 1с:        $c8status"



#Статус postgresql
postgres_status=`systemctl status postgresql | grep -i active | awk '{print $2}'`
echo "Статус службы postgresql:$postgres_status"

#Статус haspd
haspd_status=`systemctl status haspd  | grep -i active | awk '{print $2}' `
echo "Статус службы hasp:      $haspd_status"


#Статус nginx
nginx_status=`systemctl status nginx  | grep -i active | awk '{print $2}'`
echo "Статус сервера nginx:    $nginx_status"

#Статус apache2

apache_status=`systemctl status apache2  | grep -i active | awk '{print $2}'`
echo "Статус сервера apache2:  $apache_status"

#Статус agent+
agent_status=`pm2 status | grep -i agent | awk '{print $26}'`
echo "Статус Agent+:           $agent_status"

#Провайдер
#provider=`curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python - | grep -i Testing | grep -i from | awk '{ print $3}'`
#echo "Кто провайдер:                   $provider"

#Скрость интернета
#ether_channel=`curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python - | grep -i download | grep -i mbit`
#echo "Скорость интернета загрузка:      $ether_channel"

#Скрость интернета
#ether_channel_up=`curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python - | grep -i upload | grep -i mbit`
#echo "Скорость интернета отдача:      $ether_channel_up"



#Проверка подключений к ресурсам

#Банковские выписки
nc -vz 192.168.4.50 21 2>&1  | awk '/succeeded/{print "Банковские выписки доступны"}'

#Остатки Чех
nc -vz 192.168.4.204 80 2>&1   | awk  '/succeeded/{print "Остатки Чехова доступны"}'

#Шара ЦБ
nc -vz 192.168.4.150 445 2>&1 | awk  '/succeeded/{print "Шара ЦБ доступна"}'

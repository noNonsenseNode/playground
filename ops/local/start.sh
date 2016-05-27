#!/bin/bash

# wait for dbserver to come up
while ! nc -z dbserver 3306 ; do
    sleep 10;
    echo "dbserver not up yet...."
done

# setup database
echo "create database"
mysql -h dbserver -u root -proot -e "CREATE DATABASE IF NOT EXISTS playground;"
mysql -h dbserver -u root -proot -e "GRANT SELECT, INSERT, UPDATE, DELETE,EXECUTE, ALTER, CREATE, DROP, CREATE, CREATE ROUTINE ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;"
mysql -h dbserver -u root -proot -e "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;"
mysql -h dbserver -u root -proot -e "GRANT SELECT, INSERT, UPDATE, DELETE,EXECUTE, ALTER, CREATE, DROP, CREATE, CREATE ROUTINE ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root' WITH GRANT OPTION;"
mysql -h dbserver -u root -proot -e "GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root' WITH GRANT OPTION;"

# upgrade schema to latest version
echo "update playground database"
pushd ./database
    db-migrate up
popd

# run debugger
node-inspector --no-preload --web-port=8080 --save-live-edit=true --hidden=node_modules &

# install npm modules
cd /srv
npm install

# start website process
forever -a --uid="playground" -c "node --debug=4001" /srv/server.js &

# dont let container end
echo "run container"
while true; do sleep 10000; done

#!/bin/bash

if [ ! -f /data/db/.mongodb_password_set ]; then
    mongod --fork --logpath /var/log/mongodb/mongod.log --bind_ip 127.0.0.1

    mongo $DB --eval "db.createUser({ user: '$USER', pwd: '$PASS', roles: [ { role: '$ROLE', db: '$DB' } ] });" 

    mongod --shutdown

    touch /data/db/.mongodb_password_set
fi

exec mongod --auth --bind_ip 0.0.0.0

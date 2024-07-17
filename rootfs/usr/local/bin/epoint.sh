#!/bin/bash -xe


chown -R user.user /home/user

exec "$@"

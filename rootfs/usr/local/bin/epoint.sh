#!/bin/bash -xe

if ! getent group $USER_GID >/dev/null; then
    groupadd -g $USER_GID user
else
    while getent group $USER_GID >/dev/null; do
        USER_GID=$((USER_GID + 1))
    done
    groupadd -g $USER_GID user
fi

# Check if the user with USER_UID exists
if ! getent passwd $USER_UID >/dev/null; then
    useradd -u $USER_UID -g $USER_GID -ms /bin/bash user
else
    while getent passwd $USER_UID >/dev/null; do
        USER_UID=$((USER_UID + 1))
    done
    useradd -u $USER_UID -g $USER_GID -ms /bin/bash user
fi
chown -R user.user /home/user

exec "$@"

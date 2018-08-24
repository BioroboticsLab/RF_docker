#! /bin/sh

set -e

case "$1" in
sshd)
    exec /usr/sbin/sshd -D
    ;;
*)
    exec "$@"
    ;;
esac
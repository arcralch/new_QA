#!/bin/sh

# Create the necessary file structure for /dev/net/tun
if ( [ ! -c /dev/net/tun ] ); then
  if ( [ ! -d /dev/net ] ); then
        mkdir -m 755 /dev/net
  fi
  mknod /dev/net/tun c 10 200
  chmod 600 /dev/net/tun
fi

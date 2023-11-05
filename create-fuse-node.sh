#!/bin/bash

if hostnamectl | grep -q openvz && [ ! -e /dev/fuse ]; then
  mknod /dev/fuse c 10 229
else
  echo "This virtualization is not OpenVZ or /dev/fuse already exists"
fi

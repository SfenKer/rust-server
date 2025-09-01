#!/bin/bash

# Permissions
setfacl -R -d -m u:admin:rwx /home/container/

# Invoke Script
su - admin -c "/home/container/scripts/shell/run_server.sh"
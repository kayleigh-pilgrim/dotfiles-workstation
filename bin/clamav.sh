#!/bin/bash

# Update
sudo freshclam

# Scan entire system
sudo clamscan --recursive --infected \
  --exclude-dir='^/proc' \
  --exclude-dir='^/sys' \
  --exclude-dir='^/dev' \
  --exclude-dir='^/run' \
  /


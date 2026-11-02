#!/bin/bash

rclone copy onedrive: "$HOME/OneDrive-Backup" --progress --create-empty-src-dirs --transfers 4 --checkers 8

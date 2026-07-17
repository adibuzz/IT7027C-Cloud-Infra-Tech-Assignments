#!/bin/bash

# This script is used to create the environment needed for the lab exercises in this course.

# Update and upgrade the repository and auto-remnove any unused packages

sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y

# Install VSCode

# Add the Microsoft GPG key and repository
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg 
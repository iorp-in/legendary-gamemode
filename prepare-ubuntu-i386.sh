#!/bin/bash

echo ">> prearing for samp server..."

# Set DEBIAN_FRONTEND to noninteractive
export DEBIAN_FRONTEND=noninteractive

# Add i386 architecture
dpkg --add-architecture i386
apt-get update
apt-get install apt-utils ca-certificates gdb tmux -y
apt-get install libc6:i386 libncurses6:i386 libstdc++6:i386 libssl3:i386 -y

# Install tzdata package
apt-get install -y tzdata

# Set timezone to Asia/Kolkata
ln -fs /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

# Finish
echo ">> samp server prepared"

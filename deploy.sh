#!/usr/bin/env bash

source /etc/environment

echo -e "[info] update database"
apt-get update
echo -e "[info] install necessary packages for upgrade"
apt-get install update-notifier-common -y
echo -e "[info] upgrade"
apt-get upgrade -y
apt-get dist-upgrade -y
add-apt-repository multiverse
dpkg --add-architecture i386
echo -e "[info] upgrade database"
apt update
echo -e "[info] install necessary packages"
echo steam steam/question select "I AGREE" | debconf-set-selections
echo steam steam/license note '' | debconf-set-selections
apt install ca-certificates steamcmd -y

useradd -m -s /usr/sbin/nologin steam
su steam -s "/bin/bash" -c "steamcmd +@sSteamCmdForcePlatformBitness 64 +login anonymous +app_update 2394010 validate +quit"
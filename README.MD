[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) 

English | [简体中文](https://github.com/sht2017/MCBE-Fast-deploy-server-on-linux/blob/master/README-zh.md)

PalDep
=====
This project aims to provide a fast deployment solution for [Palworld](https://store.steampowered.com/app/1623730) dedicated servers on Linux. Currently accessible via a CLI interface, there are plans to potentially offer a GUI version through the web in the future.


## How to use?
copy, paste, enter and enjoy =)

### Prepare
Make sure ```curl```, ```tar``` and  ```unzip``` is installed on your system.

If you are not that sure, you may try (For Debian and Ubuntu):
```Shell
sudo apt update && sudo apt install curl tar unzip -y
```

### Install
```Shell
bash <(curl -sL https://raw.githubusercontent.com/sht2017/PalDep/Dev/paldep.sh) install
```
### Remove
```Shell
bash <(curl -sL https://raw.githubusercontent.com/sht2017/PalDep/Dev/paldep.sh) clean
```
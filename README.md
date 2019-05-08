Asterisk Docker Image
===

Asterisk Version from Alpine Linux is used.\
This Image is Based on https://github.com/andrius/asterisk

# Requirements

docker-alpine-mini Image see https://github.com/gpauli/docker-alpine-mini.git

# Building

Edit **build.sh** and adjust you settings
Start **build.sh**

# Operation

* start with **start.sh**
  * reuse a previous container if exists
* stop with **stop.sh**
  * container will not deleted
* save data with **backup.sh**
* restore data wih **restore.sh**
* access the container with **console.sh**
* edit files and trasfer with **edit.sh**

# Network

Uses macvlan networking named docker-adsl
Adds iptable settings from firewall.sh

# Notes

have fun

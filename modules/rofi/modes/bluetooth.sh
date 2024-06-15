#!/bin/sh

mainMenu() {
  echo -en "\0prompt\x1fAction >\n"

  item "Paired Devices" "preferences-desktop-peripherals" "devicesMenu"
}

item() {
  echo -en "$1\0"
  echo -en "icon\x1f$2\x1f"
  echo -en "info\x1f$3\x1f"
  echo -en "\n"
}

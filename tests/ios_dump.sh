#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
export PATH=${DIR}/../static_data/libimobiledevice-darwin/:$PATH

serial=$(idevice_id -l 2>&1 | tail -n 1)
mkdir -p "$serial"_ios
cd "$serial"_ios
# gets all of the details about each app (basically what ios_deploy does but with extra fields)
ideviceinstaller -u "$serial" -l -o xml -o list_all > ios_apps.plist
# use with installer_parse.py

# gets OS version, serial, etc. -x for xml. Raw is easy to parse, too.
ideviceinfo -u "$serial" -x > ios_info.xml

# try to check for jailbroken by mounting the entire filesystem. 
# Gets output:
# "Failed to start AFC service 'com.apple.afc2' on the device.
# This service enables access to the root filesystem of your device.
# Your device needs to be jailbroken and have the AFC2 service installed."
# if fails (so in that case not jailbroken -- or 'not sure' for false negative).
rm -rf /tmp/phonescanmnt
mkdir -p /tmp/phonescanmnt
ifuse -u "$serial" --root /tmp/phonescanmnt &> ios_jailbroken.log
cd ..

# for consumption by python
echo $serial

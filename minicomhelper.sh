#!/bin/bash
tty_list="$(ls -q /dev/tty*)" # all tty devices in /dev
extras="" # initialize to empty

# loop through tty devices in /dev
for tty in $tty_list; do
    # weird stupid regex to filter out useless ones
    echo "$tty" | grep -q -E 'tty[0-9]{0,2}$|ttyACM[0-9]{1,2}$|ttyAMA[0-9]{1,2}$|ttyprintk$'
    retcode=$? # get the return code 0 match 1 for no match

    if [ $retcode -eq 0 ]; then
        devices+="$tty\n" # create/add to devices var
    fi
done

if [ -z "$devices" ]; then # devices var empty
    echo -e "\nFAIL: no good devices found\n"
    exit 1
else
    echo -e "$devices"
fi

# get choice of device
echo -e "\nOptions are:"
read -p "Enter device: " tty_selection

# baud?
read -p "Enter baudrate (common are 9600, 19200, 38400, 57600, and 11520 blank for auto: " baudrate
if [ ! -z "$baudrate" ]; then
    extras+="--baudrate=$baudrate " # dun forger the extra space
fi

read -p "Capture session to file blank for auto? y/n " capture_choice
if [[ "$capture_choice" =~ [yY] ]]; then
    capture_file=$HOME/minicom/captures/$(date +%Y-%m-%d-%H%M-%Z)_minicom_capture
    echo "Capturing session to $capture_file"
    touch $capture_file
    extras+="--capturefile=$capture_file " # dont froget da space
fi

read -p "Hex dump view blank for auto? y/n " hex_choice
if [[ "$hex_choice" =~ [yY] ]]; then
    extras+="--displayhex "
fi

# make sure device exists as any file/dir type
if [ ! -e "$tty_selection" ]; then
    echo -e "FAIL: device $tty_selection does not exist"
    exit 1
fi

# --device for tty device
# --color=on for color
# extras trimmed has a prepended space so it butts up against color=on as minicom does not like extra spaces
minicom --device=$tty_selection --color=on$(echo $extras_trimmed) $HOME/minicomhelper/minirc.dfl

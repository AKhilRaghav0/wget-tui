#!/bin/bash

HEIGHT=20
WIDTH=60
CHOICE_HEIGHT=5
BACKTITLE="wget TUI"
TITLE="Download file"
MENU="Select options:"
OPTIONS=""
URLS=""

while true; do
    URL=$(dialog --clear --backtitle "$BACKTITLE" --title "$TITLE" --inputbox "Enter URL to download:" $HEIGHT $WIDTH 2>&1 > /dev/tty)

    if [ -z "$URL" ]; then
        break
    fi

    URLS="$URLS $URL"

    CHOICES=$(dialog --clear --backtitle "$BACKTITLE" --title "$TITLE" --checklist "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "-c" "Use -c option (continue previous download)" off "-r" "Use -r option (recursive download)" off "-np" "Use -np option (don't ascend to the parent directory)" off "-nH" "Use -nH option (don't create host directories)" off "-P <dir>" "Specify download directory (default is current directory)" off "-l <depth>" "Specify depth of recursion (default is 5)" off "-o <file>" "Save download log to file" off "-q" "Use -q option (quiet mode)" off 2>&1 > /dev/tty)

    if [ $? -eq 1 ]; then
        break
    fi

    OPTIONS=""
    for CHOICE in $CHOICES; do
        case $CHOICE in
            -P)
                DIR=$(dialog --clear --backtitle "$BACKTITLE" --title "$TITLE" --inputbox "Enter download directory:" $HEIGHT $WIDTH 2>&1 > /dev/tty)
                if [ -n "$DIR" ]; then
                    OPTIONS="$OPTIONS $CHOICE $DIR"
                fi
                ;;
            -l)
                DEPTH=$(dialog --clear --backtitle "$BACKTITLE" --title "$TITLE" --inputbox "Enter depth of recursion (default is 5):" $HEIGHT $WIDTH 2>&1 > /dev/tty)
                if [ -n "$DEPTH" ]; then
                    OPTIONS="$OPTIONS $CHOICE $DEPTH"
                else
                    OPTIONS="$OPTIONS $CHOICE 5"
                fi
                ;;
            -o)
                FILE=$(dialog --clear --backtitle "$BACKTITLE" --title "$TITLE" --inputbox "Enter log file name:" $HEIGHT $WIDTH 2>&1 > /dev/tty)
                if [ -n "$FILE" ]; then
                    OPTIONS="$OPTIONS $CHOICE $FILE"
                fi
                ;;
            *)
                OPTIONS="$OPTIONS $CHOICE"
                ;;
        esac
    done

    for URL in $URLS; do
        wget $OPTIONS $URL &
    done

    dialog --clear --backtitle "$BACKTITLE" --title "$TITLE" --infobox "Downloading files..." $HEIGHT $WIDTH
    wait

    dialog --clear --backtitle "$BACKTITLE" --title "$TITLE" --yesno "Do you want to download another file?" $HEIGHT $WIDTH
    if [ $? -ne 0 ]; then
        break
    fi
done

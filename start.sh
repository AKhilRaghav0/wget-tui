#!/bin/bash

# Define dialog box size
HEIGHT=10
WIDTH=40
CHOICE_HEIGHT=2
BACKTITLE="wget TUI"
TITLE="Download file"
MENU="Do you want to use -c option?"

# Define wget command
URL="http://example.com/file"

# Create dialog box and get user's choice
while true; do
    CHOICE=$(dialog --clear \
                    --backtitle "$BACKTITLE" \
                    --title "$TITLE" \
                    --menu "$MENU" \
                    $HEIGHT $WIDTH $CHOICE_HEIGHT \
                    "1" "Download with -c option" \
                    "2" "Download without -c option" \
                    2>&1 > /dev/tty)

    case $CHOICE in
        1)
            # Download with -c option
            wget -c $URL
            break
            ;;
        2)
            # Download without -c option
            wget $URL
            break
            ;;
        *)
            # Invalid choice, show error message and try again
            dialog --clear \
                   --backtitle "$BACKTITLE" \
                   --title "Error" \
                   --msgbox "Invalid choice, please try again." \
                   $HEIGHT $WIDTH
            ;;
    esac
done

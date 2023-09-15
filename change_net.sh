#!/bin/dash

COMMAND_NAME="s"

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
YELLOW='\033[0;33m'
BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_ORANGE='\033[1;33m'
BOLD_BLUE='\033[1;34m'
BOLD_PURPLE='\033[1;35m'
BOLD_YELLOW='\033[1;33m'
BOLD_WHITE='\033[1m'
NC='\033[0m' # No Colornilter

function s()
{
    if [[ $1 == "--help" ]];then
        display_help

    elif [[ $1 == "--usage" ]];then
        display_usage

    elif [[ $# -eq 1 ]];then # Change to network type that has been ordered.
	    if [ $1 == "wifi" ]  || [ $1 == "w" ];then
            # connect to wifi as ordered.
            connect_wifi
	 
        elif [ $1 == "ethernet" ] || [ $1 == "e" ];then
            # connect to ethernet as ordered.
            connect_ethernet
        fi

    elif [[ $# -eq 0 ]];then # No any command has been provided, change \
    # should be in between known connections.

        if [ "`nmcli con show --active`" ];then # There is a currently \
	# established network.
            echo ""
            echo ""
            echo ""
            echo -e "${BOLD_PURPLE}You are currently connected to network${NC}"

            # current=`ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//"`
            currentUUID=`nmcli -t -f UUID con | head -1`
            currentNAME=`nmcli -g NAME con | head -1`
            currentTYPE=`nmcli -g TYPE con | head -1`

            echo ""
            echo "Current Connection Details"
            echo -e "NAME: ${BOLD_BLUE}$currentNAME${NC}"
            echo -e "UUID: ${BOLD_BLUE}$currentUUID${NC}"
            echo -e "TYPE: ${BOLD_BLUE}$currentTYPE${NC}"
            echo ""

            # Change between
            if [[ $currentTYPE == *"ethernet"* ]];then                  
                connect_wifi 
            elif [[ $currentTYPE == *"wireless"* ]];then
                connect_ethernet      
            else
                echo "Can not detect the type of network."
            fi

        else # There is no any established connection currently.
            echo ""
            echo -e "You are currently ${RED}OFFLINE${NC}"
            echo ""
            echo "Connecting you to wifi..."
            connect_wifi
        fi

    else # Command is not recognizable, display usage.
        echo -e "${BOLD_RED}Command has been not found!"
    fi
}

function display_help ()
{
        echo ""
        echo ""
        echo ""
        echo -e "${BOLD_WHITE}Changes from wifi to ethernet or viceversa.${NC}"
        echo -e "${BOLD_WHITE}If you are currently offline, wifi ${NC}"
        echo -e "${BOLD_WHITE}will be selected as a default connection.${NC}"
        display_usage
        
        return 0
}

function display_usage ()
{
        echo ""
        echo ""
        echo ""
        echo -e "${BOLD_BLUE}${COMMAND_NAME}${NC}"
        echo "   : Changes the networks in between." 
        echo ""
        echo -e "${BOLD_BLUE}${COMMAND_NAME}${NC}${BOLD_YELLOW} w${NC}||${BOLD_YELLOW}wifi${NC}"
	echo "   : Changes to known wifi network."
        echo ""
        echo -e "${BOLD_BLUE}${COMMAND_NAME}${NC}${BOLD_YELLOW} e${NC}||${BOLD_YELLOW}ethernet${NC}"
        echo "   : Changes to known ethernet network."        
        echo ""
        echo ""
        echo ""
        
        return 0
}

function connect_wifi ()
{
    if [ "`nmcli con show --active`" ];then
        #current=`ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//"`
        currentUUID=`nmcli -t -f UUID con | head -1`
        currentNAME=`nmcli -g NAME con | head -1`
        currentTYPE=`nmcli -g TYPE con | head -1`
        nmcli connection down $currentUUID  
    fi

    # Look for known available wifi
    iterator=1
    while  [[ $(ls -A) ]] # While inputted command returns no output. nmcli \
    # returns nothing when you check variable for out of index. In our case \ 
    # that means that we already went through all the available networks has \
    # been already established
    do
        if [ $iterator -eq 100 ];then # Safe spot.
            echo -e "${BOLD_YELLOW}Could not find any known wifi network! Exiting now.${NC}"
            echo ""
            echo ""
            break
        
        else
            #echo "`nmcli -g TYPE con | sed -n ''$iterator'p;' `" # This took 2 hours of mine btw :/.
            if [[ "`nmcli -g TYPE con | sed -n ''$iterator'p;' `" == *"wireless"* ]];then

                targetUUID=`nmcli -t -f UUID con | sed -n ''$iterator'p;' `
                targetNAME=`nmcli -g NAME con | sed -n ''$iterator'p;' `
                targetTYPE=`nmcli -g TYPE con | sed -n ''$iterator'p;' `

                echo -e "Connecting To: ${BOLD_RED}$targetNAME${NC}"

                # Resurrect Wifi
                nmcli connection up $targetUUID
                echo ""
                if [ "`nmcli g | awk 'FNR==2{print $2}' `" == "none" ];then
                    echo ""
                    echo -e "${BOLD_YELLOW}nmcli fails! Faced with unknown network, advancing...${NC}"
                    echo ""
                    echo ""
                    break
                else
                    echo -e "${BOLD_GREEN}$targetNAME ($targetTYPE)${NC} has been resurrected"
                    echo ""
                    echo ""
                    echo ""
                    break
                fi

            else
                iterator=$((iterator + 1))
            fi
        fi
    done    
}

function connect_ethernet ()
{
    if [ "`nmcli con show --active`" ];then
        #current=`ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//"`
        currentUUID=`nmcli -t -f UUID con | head -1`
        currentNAME=`nmcli -g NAME con | head -1`
        currentTYPE=`nmcli -g TYPE con | head -1`
        nmcli connection down $currentUUID  
    fi

    # Look for known available ethernet
    iterator=1
    while  [[ $(ls -A) ]] # While inputted command returns no output. \
    # nmcli returns nothing when you check variable for out of index. \
    # In our case that means that we already went through all the available \ 
    # networks has been already established.
    do
        if [ $iterator -eq 100 ];then # Safe spot.
            echo -e "${BOLD_YELLOW}Could not find any known ethernet network! Exiting now.${NC}"
            echo ""
            echo ""
            break
        
        else
            #echo "`nmcli -g TYPE con | sed -n ''$iterator'p;' `" # This took mine 2 hours btw.
            if [[ "`nmcli -g TYPE con | sed -n ''$iterator'p;' `" == *"ethernet"* ]];then

                targetUUID=`nmcli -t -f UUID con | sed -n ''$iterator'p;' `
                targetNAME=`nmcli -g NAME con | sed -n ''$iterator'p;' `
                targetTYPE=`nmcli -g TYPE con | sed -n ''$iterator'p;' `

                echo -e "Connecting To: ${BOLD_RED}$targetNAME${NC}"

                # Resurrect ethernet
                nmcli connection up $targetUUID
                echo ""
                
                if [ "`nmcli g | awk 'FNR==2{print $2}' `" == "none" ];then
                    echo ""
                    echo -e "${BOLD_YELLOW}nmcli fails! Faced with unknown network, advancing...${NC}"
                    iterator=$((iterator + 1))
                    echo ""
                    echo ""
                else
                    echo -e "${BOLD_GREEN}$targetNAME ($targetTYPE)${NC} has been resurrected"
                    echo ""
                    echo ""
                    echo ""
                    break
                fi

            else
                iterator=$((iterator + 1))
            fi
        fi
    done            
}

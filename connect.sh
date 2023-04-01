#!/bin/bash
# set -x

getSshConfig=`cat ~/.ssh/config | grep "^Host " | awk '{print $2}' | sort`
getActiveContainers=`docker ps --format "{{.Names}}"`

if [[ -z "${1}" ]] ; then
    echo -e "connect requires at least 1 argument.
    See 'connect -h'.

    Usage:  connect [OPT] [ARG]."
    exit
fi

############################################################
# Help                                                     #
############################################################
Help()
{
    # Display Help
    echo "Add description of the script functions here."
    echo
    echo "Syntax: connect [OPT] [ARG]"
    echo "options:"
    echo "h     Print this Help."
    echo "l     List known connections."
    echo "c     Connect to a client."
    echo "g     Generate a new connection in .ssh/config."
    echo
}

############################################################
# Main program                                             #
############################################################
List()
{
    # display list of possible connections
    if [[ -z "${getSshConfig}" ]]; then
        echo "Nothing configured in ~/.ssh/config."
    else
        echo "From your ~/.ssh/config file :"
        echo "${getSshConfig}"
        echo
    fi

    if [[ -z "${getActiveContainers}" ]] ; then
        echo "No active containers."
    else 
        echo "From your active docker containers :"
        echo "${getActiveContainers}"
    fi
    echo
}

launchConnection()
{
    checkSshConfig=`cat ~/.ssh/config | grep "^Host " | awk '{print $2}' | sort | grep ${Name}`
    checkActiveContainer=`docker ps --format "{{.Names}}" | grep ${Name}`
    if [ -z "${checkActiveContainer}" ] ; then
        sshConnection
    else
        dockerConnection
    fi 
}

sshConnection()
{
    echo -n "Connecting to ${Name}."
    ssh "${Name}"
}

dockerConnection()
{ 
    echo -n "Connecting to ${Name}."
    docker exec -it "${Name}" bash
}

getVariablesForCreation()
{
    echo -n "Which user will you connect to ?" # Pretty self explanatory
    read -p "#? " User
    echo -n "Which Address/Name will you connect to ?"
    read -p "#? " FQDN
    echo -n "What port you will be connecting to ?"
    read -p "#? " Port
    echo -n "What will be the connection name ? (Pick an easy one to remember)"
    read -p "#? " ConName
    echo -n "Do you really want to create the ssh connection '${User}@${FQDN} -p ${Port}' ? (y/N)" # Asking for a confirmation there, nothing fancy
    read -p "#? " confirmation
    if [ "${confirmation}" = 'y' ] || [ "${confirmation}" = 'Y' ]
        then
            echo
            createConnection
            echo "Now you only need to launch 'ssh ${ConName}' or use this script for easy picking."
            exit 1
    else
        exit 1
    fi
}

createConnection()
{
    echo -e "\n \
    Host ${ConName} \
    \n	HostName ${FQDN} \
    \n	User ${User} \
    \n	Port ${Port}" >> ~/.ssh/config
}


############################################################
# Process the input options.                               #
############################################################
# Get the options
while getopts ":lghc:" option; do
    case $option in
        h) # display Help
            Help
            exit;;
        l) # display list of possible connections
            List
            exit;;
        c) # connect to a client
            Name=${OPTARG}
            launchConnection
            exit;;
        g) # create a new connection
            getVariablesForCreation
            exit;;
        \?) # Invalid option
            echo "Error: Invalid option"
            Help
            exit;;
    esac
done

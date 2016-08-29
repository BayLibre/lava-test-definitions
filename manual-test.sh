#!/bin/bash

###############################################################################
#usage function
function usage {
echo "usage:"
echo "1/ $(basename "$0") [-h] --list : print list of possible test files"
echo "2/ $(basename "$0") [-h] <test file> : excute test define in filename"
echo ""
echo "where:"
echo "   -h | --help : print this usage"
echo "   --list :      list test files"
}
###############################################################################

# Test no option or argument
if [ $# -eq 0 ]; then
    echo "Need at least one argument"
    usage
    exit
fi

# Option treatment
OPTS=$( getopt -o h -l help,list -- "$@" )
if [ $? -ne 0 ]; then
    usage
    exit 1
fi

eval set -- "$OPTS"
 
while true ; do
    case "$1" in
        --list)
            find health/ test-shell/ -type f \( -name "*.json" -o -name "*.yaml" \)
            shift
            exit;;

        -h|--help)
            usage
            exit;;
            
        --) shift; break;;

        *)
            usage
            exit 1;;
    esac
done

# Put all argument in array
IN_ARRAY_FILES=("$@")
if [ ${#IN_ARRAY_FILES[@]} -eq 0 ]; then
    echo "test filename is mandatory"
    exit 1
fi

# split argument in 3 array
#    - 1 for the good file that will be executed
#    - 1 for wrong files
#    - 1 for good files ignored
WRONG_FILES=()
IGNORED_FILES=()
GOOD_FILE=()
GOOD="false"
for ((i=0; i<${#IN_ARRAY_FILES[@]}; i++)); do
    if [ -f ${IN_ARRAY_FILES[$i]} ] && [ ${#GOOD_FILE[@]} -eq 0 ]; then
        GOOD_FILE+=(${IN_ARRAY_FILES[$i]})
        GOOD="true"
    fi
    if [ ! -f ${IN_ARRAY_FILES[$i]} ]; then
        WRONG_FILES+=(${IN_ARRAY_FILES[$i]})
    elif [ ${#GOOD_FILE[@]} -ne 0 ] && [ "${GOOD}" == "false" ]; then
        IGNORED_FILES+=(${IN_ARRAY_FILES[$i]})
    fi
    GOOD="false"
done

#no good file found, exit with error
if [ ${#GOOD_FILE[@]} -eq 0 ]; then
    echo "### ERROR ### A correct test filename is mandatory"
    echo "use option --list to list them"
    exit 1
fi

#list wrong files
if [ ${#WRONG_FILES[@]} -ne 0 ]; then
    echo ""
    echo "### ERROR ### Following files are wrong"
    echo "use option --list to list available files"
    for ((i=0; i<${#WRONG_FILES[@]}; i++)); do
        echo "    ${WRONG_FILES[$i]}"
    done
fi

#list ignored files
if [ ${#IGNORED_FILES[@]} -ne 0 ]; then
    echo ""
    echo "### WARNING ### following files will be ignored"
    for ((i=0; i<${#IGNORED_FILES[@]}; i++)); do
        echo "    ${IGNORED_FILES[$i]}"
    done
fi
echo ""

#to get the port number, use lsof filtered on apache2
#ports need to be set first in /etc/apache2/ports.conf and /etc/apache2/sites-enabled/lava-server.conf
#service apache2 need to be started
#PORT=`sudo lsof -nP -i | grep apache2 | awk '{ print $9 }' | awk -F: '{ print $2 }' | tail -1`

#calc Address automatically
LAVA_URL_API="http://${USER}@`uname -n`.local:10080/RPC2/"
export LAVA_URL_API="http://${USER}@`uname -n`.local:10080/RPC2/"

#change variable ${LAVA_URL_API} in ${GOOD_FILE[0]} (json file) by correct value
sed -e "s#\"{LAVA_URL_API}\"#\"${LAVA_URL_API}\"#g" ${GOOD_FILE[0]} > ${GOOD_FILE[0]}.new

#execute test
echo "Execute test ${GOOD_FILE[0]}"
echo "lava-tool submit-job ${LAVA_URL_API} ${GOOD_FILE[0]}.new"
lava-tool submit-job ${LAVA_URL_API} ${GOOD_FILE[0]}.new

rm -f ${GOOD_FILE[0]}.new

#! /bin/bash

##########################################################################
#       Author  :   Clément Trassoudaine
#       Date    :   24/04/2018
#       License :   MIT
#
#       Desc    :   Useful script for easy config backup and restore
##########################################################################

# Usage: save conf_folder save_folder save_name file1 file2 ... filen
function save {
    WD=$(pwd);
    # Conf folder
    CF=$1;
    # Save folder
    SF=$2;
    # Name of the save
    NAME=$3.tar.bz2;
    shift 3;
    # Files to save
    FILES=$@;

    cd $CF;
    tar jcvf $NAME $FILES > /dev/null;
    mv $NAME $SF/;
    cd $WD;
    echo "$NAME configuration saved in $CF";
}

# Usage: restore conf_folder save_folder save_name
function restore {
    WD=$(pwd);
    # Conf folder
    CF=$1;
    # Save folder
    SF=$2;
    # Name of the save
    NAME=$3.tar.bz2;

    cd $SF;
    tar jxvf $SF/$NAME -C $CF; #> /dev/null;
    cd $WD;
    echo "$NAME restored saved in $CF";
}

function print_help {
    echo "

syntax 1 : help [Opt]
    Prints help
    [Opt] : 
        none    --> prints the standard help menu
        config  --> Prints the help with regard to the configuration

syntax 2 : [Operation] [Name]

    Operations list :
        save            --> save linux confing
        recover         --> restore saved config 
        custom_rec      --> recover saved config in custom path

    Name:
        The name of the configuration block as specified in the config.json
        
    ";
}

function print_config_help {
    echo "

    ";
}

function load_config {
    conf_chunk_names=$(jq -r "keys | .[]" $CFMNGT_CONFIG);
    for conf_chunk_name in $conf_chunk_names; 
    do 
        echo $conf_chunk_name;
        BF=$(jq -r ".$conf_chunk_name.base_folder" $CFMNGT_CONFIG);
        FILES=$(jq -r ".$conf_chunk_name.files | .[]" $CFMNGT_CONFIG);
        echo $BF; 
        echo $FILES;
    done
    #return $config;
}

function check_config {
    echo "TODO";
}

function invalid_syntax {
    echo "INVALID SYNTAX";
    print_help;
}

function parse_help {
    if [ $# -ge 2 ] && [ $2 = "config" ]; then
        print_config_help;
    else
        print_help;
    fi
}

function parse_save {
    echo "TODO";
}

function parse_restore {
    echo "TODO";
}

function main {
    if [ $# -ge 1 ] 
    then
        case $1 in

        'help'|'--help'|'-h')
            parse_help $@;
        ;;

        'save')
            parse_save $@;
        ;;

        'restore'|'custom_rec')
            parse_restore $@;
        ;;

        *)
            invalid_syntax;
        ;;
        esac
    else
        print_help;
    fi;
}

main $@;
load_config;



#!/bin/bash

function saveall {
  savegen $1;
  savessh $1;
}

function savessh {
  cd ~;
  tar jcvf ssh_conf.tar.bz2 .ssh > /dev/null;
  mv ssh_conf.tar.bz2 $1
  echo "General configuration saved in $conf_path";
}

function savegen {
  cd ~;
  tar jcvf gen_conf.tar.bz2 .bashrc .bash_aliases .bash_vars .profile > /dev/null;
  mv gen_conf.tar.bz2 $1
  echo "SSH configuration saved in $conf_path";
}

function printhelp {
  echo "
syntax : [Operation] [conf_path] ([Optionnal])

         Operations list :
          save        --> save linux confing into conf_path
            Opt : all (default), ssh, gen
          recover     --> restaure saved config from conf_path
          winconfig   --> configure windows ssh from conf_path
  ";
}

case $# in
  0)
    echo 'Syntax error, please check for help (--help)'
  ;;
  1)
    if [ $1 = '--help' ] || [ $1 = '-h' ]
    then
      printhelp;
    else
      echo "Syntax error, please check for help (--help)"
    fi
  ;;
  [2-3])
    if [ -d $2 ]
    then
      conf_path=$(realpath $2);
      case $1 in 
      "save")
          case $3 in
          "all")
            saveall $conf_path;
            ;;
          "")
            saveall $conf_path;
            ;;
          "ssh")
            savessh $conf_path;
            ;;
          "gen")
            savegen $conf_path;
            ;;
          *)
            echo "Unrecognized instruction, please check for help (--help)";
            ;;
          esac
        ;;
      "recover")
        tar jxvf $conf_path/gen_conf.tar.bz2 -C ~;
        tar jxvf $conf_path/ssh_conf.tar.bz2 -C ~;
        chmod 700 ~/.ssh/keys/*;
        echo "Configuration successfully restored from $conf_path";
        ;;
      "winconfig")
        if [ -n $HOME_FOLDER ]
        then
          tar jxvf $conf_path/ssh_conf.tar.bz2 -C $HOME_FOLDER;
        else
          echo "Windows user path is not defined (export \$HOME_FOLDER)"
        fi
      ;;
      *)
        echo "Unrecognized instruction, please check for help (--help)"
      ;;
      esac
    else
      echo "Invalid path"
    fi
  ;;
  3)
  ;;
  *)
    echo "Syntax error, please check for help (--help)"
  ;;
esac


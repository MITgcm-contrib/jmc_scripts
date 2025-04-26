#! /usr/bin/env bash

tmpfil='TTT.'$$
if test $# = 0 -o "x$1" = 'x-h' ; then
       echo 'Usage: '`basename $0`' [-s sfile][-b][-f Action] list_of_file_to_process'
       echo ' --> : apply modifications using sed script file "sfile", default: "mod.sed"'
       echo '  -b : remove double blank lines (keep only 1 blank)'
       echo '  -f : always do {Action} without asking, Action in: Y,I,K,S,N,E'
       echo '   Y/I/K=apply, I=+confirm, K=+keep_date; S=save_to ".modif"; N=no; E=N+rm'
       echo '  -h : print this message and exit'
       exit
fi
sfile=
rmDblBlk=0
askresp='Y' ;  resp='Y'
if test $1 = '-b' ; then rmDblBlk=1 ; shift ; fi
if test $1 = '-s' ; then sfile=$2 ; shift ; shift ; fi
if test $1 = '-b' ; then rmDblBlk=1 ; shift ; fi
if test $1 = '-f' ; then
  case $2 in
   "Y"|"I"|"K"|"S"|"N"|"E") askresp='N' ; resp=$2 ;;
   *) echo "option '-f' with invalid argument {Action}='$2'" ; exit 1 ;;
  esac
 shift ; shift
fi
if test $1 = '-b' ; then rmDblBlk=1 ; shift ; fi

liste=$*
thisfile=`basename $0`
if test "x$sfile" = x ; then sfile=${thisfile}.sed ; fi
if test -f $sfile
then
  echo "modification file =" $sfile ":"
  cat $sfile
  sleep 1
  for xx in $liste
  do
    rm -f $tmpfil
    if test $rmDblBlk = 1 ; then
      sed -f $sfile $xx | cat -s > $tmpfil
    else
      sed -f $sfile $xx > $tmpfil
    fi
    echo diff $xx $tmpfil
    diff $xx $tmpfil
    yy=$?
    if test $yy != '0'
    then
        #echo " chmod --reference=$xx $tmpfil :"
        chmod --reference=$xx $tmpfil
        if test $askresp = 'Y'
        then
          echo "Apply changes ? (y/i/s=sav,k=y+keep_date,n=no,e=n+rm) ->" $xx 1>&2
          read resp
        else
          echo "Apply changes ->" $xx
        fi
        case $resp in
         "k"|"K") touch -r $xx $tmpfil ; mv -f $tmpfil $xx ;;
         "y"|"Y") mv -f $tmpfil $xx ;;
         "i"|"I") mv -i $tmpfil $xx ;;
         "s"|"S") mv -f $tmpfil $xx.modif ;;
         "e"|"E") rm -f $tmpfil ;;
            *) ;;
        esac
    else
        echo "No changes in :" $xx
        rm -f $tmpfil
    fi
  done
  #rm -f $tmpfil
else
  echo "no file $sfile"
fi
exit

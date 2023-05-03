#!/bin/bash
 
 
export PS1='\[\e]0;\w\a\]\n\[\e[36m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
 

alias rm='rm -i' 
alias mv='mv -i' 
alias cp='cp -i' 
 
alias vi='vim'
 
 
if test $0 == "-bash" 
then 
  
    function job_color()   
    {   
        if [ $(jobs -s | wc -l) -gt "0" ]; then   
            echo -en ${BRed}   
        elif [ $(jobs -r | wc -l) -gt "0" ] ; then   
            echo -en ${BCyan}   
        fi   
    }   
  
  
    function ff() { find . -type f -iname '*'"$*"'*' -ls ; }   
   
  
    function extract()    
    {   
        if [ -f $1 ] ; then   
            case $1 in   
                *.tar.bz2)   tar xvjf $1     ;;   
                *.tar.gz)    tar xvzf $1     ;;   
                *.bz2)       bunzip2 $1      ;;   
                *.rar)       unrar x $1      ;;   
                *.gz)        gunzip $1       ;;   
                *.tar)       tar xvf $1      ;;   
                *.tbz2)      tar xvjf $1     ;;   
                *.tgz)       tar xvzf $1     ;;   
                *.zip)       unzip $1        ;;   
                *.Z)         uncompress $1   ;;   
                *.7z)        7z x $1         ;;   
                *)           echo "'$1' cannot be extracted via >extract<" ;;   
            esac   
        else   
            echo "'$1' is not a valid file!"   
        fi   
    }   
  
  
    function maketar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }   
  
    function makezip() { zip -r "${1%%/}.zip" "$1" ; }   
  
    function qhost()      
    {   
        echo -e "\nYou are logged on ${BRed}$HOST$NC"   
        echo -e "\n${BRed}Additionnal information:$NC " ; uname -a   
        echo -e "\n${BRed}Users logged on:$NC " ; w -hs | cut -d " " -f1 | sort | uniq   
        echo -e "\n${BRed}Current date :$NC " ; date   
        echo -e "\n${BRed}Machine stats :$NC " ; uptime   
        echo -e "\n${BRed}Memory stats :$NC " ; free   
        echo -e "\n${BRed}Diskspace :$NC " ; mydf / $HOME   
        echo -e "\n${BRed}Local IP Address :$NC" ; my_ip   
        echo -e "\n${BRed}Open connections :$NC "; netstat -pan --inet;   
        echo   
    }   
  
   
    function qloc()   
    {   
      echo   
      echo -e "${BRed}Shell    : $NC$0"   
      echo -e "${BRed}Hostname : $NC$HOSTNAME"   
      echo -e "${BRed}Issue    : $NC"; cat /etc/issue   
      #echo -e "\nHistory  : "; history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10   
      echo   
    }   
  
  
    #----------------- Colors -----------------------   
    Black='\e[0;30m'        # Black   
    Red='\e[0;31m'          # Red   
    Green='\e[0;32m'        # Green   
    Yellow='\e[0;33m'       # Yellow   
    Blue='\e[0;34m'         # Blue   
    Purple='\e[0;35m'       # Purple   
    Cyan='\e[0;36m'         # Cyan   
    White='\e[0;37m'        # White   
    BBlack='\e[1;30m'       # Black   
    BRed='\e[1;31m'         # Red   
    BGreen='\e[1;32m'       # Green   
    BYellow='\e[1;33m'      # Yellow   
    BBlue='\e[1;34m'        # Blue   
    BPurple='\e[1;35m'      # Purple   
    BCyan='\e[1;36m'        # Cyan   
    BWhite='\e[1;37m'       # White   
    On_Black='\e[40m'       # Black   
    On_Red='\e[41m'         # Red   
    On_Green='\e[42m'       # Green   
    On_Yellow='\e[43m'      # Yellow   
    On_Blue='\e[44m'        # Blue   
    On_Purple='\e[45m'      # Purple   
    On_Cyan='\e[46m'        # Cyan   
    On_White='\e[47m'       # White   
    NC="\e[m"               # Color Reset   
    ALERT=${BWhite}${On_Red} # Bold White on red background   
   
       
    if [ -n "${SSH_CONNECTION}" ]; then   
        CNX=${Green}        # Connected on remote machine, via ssh (good).   
    elif [[ "${DISPLAY%%:0*}" != "" ]]; then   
        CNX=${ALERT}        # Connected on remote machine, not via ssh (bad).   
    else   
        CNX=${BCyan}        # Connected on local machine.   
    fi   
   
    # Test user type:   
    if [[ ${USER} == "root" ]]; then   
        SU=${Red}           # User is root.   
    elif [[ ${USER} != $(logname) ]]; then   
        SU=${BRed}          # User is not login user.   
    else   
        SU=${BCyan}         # User is normal (well ... most of us are).   
    fi   
  
    NCPU=$(grep -c 'processor' /proc/cpuinfo)    # Number of CPUs   
    SLOAD=$(( 100*${NCPU} ))        # Small load   
    MLOAD=$(( 200*${NCPU} ))        # Medium load   
    XLOAD=$(( 400*${NCPU} ))        # Xlarge load   
   
    function load()   
    {   
        local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.')   
        # System load of the current host.   
        echo $((10#$SYSLOAD))       # Convert to decimal.   
    }   
  
  
   
    function load_color()   
    {   
        local SYSLOAD=$(load)   
        if [ ${SYSLOAD} -gt ${XLOAD} ]; then   
            echo -en ${ALERT}   
        elif [ ${SYSLOAD} -gt ${MLOAD} ]; then   
            echo -en ${Red}   
        elif [ ${SYSLOAD} -gt ${SLOAD} ]; then   
            echo -en ${BRed}   
        else   
            echo -en ${Green}   
        fi   
    }   
  
  
   
    function disk_color()   
    {   
        if [ ! -w "${PWD}" ] ; then   
            echo -en ${Red}   
            
        elif [ -s "${PWD}" ] ; then   
            local used=$(command df -P "$PWD" |   
                       awk 'END {print $5} {sub(/%/,"")}')   
            if [ ${used} -gt 95 ]; then   
                echo -en ${ALERT}        
            elif [ ${used} -gt 90 ]; then   
                echo -en ${BRed}         
            else   
                echo -en ${Green}        
            fi   
        else   
            echo -en ${Cyan}   
            # Current directory is size '0' (like /proc, /sys etc).   
        fi   
    }   
  
   
  
    function job_color()   
    {   
        if [ $(jobs -s | wc -l) -gt "0" ]; then   
            echo -en ${BRed}   
        elif [ $(jobs -r | wc -l) -gt "0" ] ; then   
            echo -en ${BCyan}   
        fi   
    }   
   
   
    export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'   
    export HISTIGNORE="&:bg:fg:ll:h"   
    export HISTTIMEFORMAT="$(echo -e ${BCyan})[%d/%m %H:%M:%S]$(echo -e ${NC}) "   
    export HISTCONTROL=ignoredups   
    export HOSTFILE=$HOME/.hosts    # Put a list of remote hosts in ~/.hosts       
   
   
    netinfo ()   
    {   
        echo "--------------- Network Information ---------------"   
        /sbin/ifconfig | awk /'inet addr/ {print $2}'   
        /sbin/ifconfig | awk /'Bcast/ {print $3}'   
        /sbin/ifconfig | awk /'inet addr/ {print $4}'   
        /sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'   
        myip=`lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' `   
        echo "${myip}"   
        echo "---------------------------------------------------"   
    }  
  
    function my_ip() 
    {   
        MY_IP=$(/sbin/ifconfig eth0 | awk '/inet/ { print $2 } ' |   
          sed -e s/addr://)   
        echo ${MY_IP:-"Not connected"}   
    }  
  
  
    function mydf()        
    {                        
        for fs ; do   
            if [ ! -d $fs ]   
            then   
              echo -e $fs" :No such file or directory" ; continue   
            fi   
  
            local info=( $(command df -P $fs | awk 'END{ print $2,$3,$5 }') )   
            local free=( $(command df -Pkh $fs | awk 'END{ print $4 }') )   
            local nbstars=$(( 20 * ${info[1]} / ${info[0]} ))   
            local out="["   
            for ((j=0;j<20;j++)); do   
                if [ ${j} -lt ${nbstars} ]; then   
                   out=$out"*"   
                else   
                   out=$out"-"   
                fi   
            done   
            out=${info[2]}" "$out"] ("$free" free on "$fs")"   
            echo -e $out   
        done   
    }  
  
  
    function ii()   # Get current host related info. 
    { 
       #echo -en "\nYou are logged on ${BRed}$HOST" 
       echo -e  "\n"
       echo -en "${BRed}Kernel info          :$NC " ; uname -a; 
       echo -en "${BRed}OS info              :$NC " ; cat /etc/issue; 
       echo -en "${BRed}Current date         :$NC " ; date; 
       echo -e  "${BRed}Users logged on      :$NC " ; w -hs | cut -d " " -f1 | sort | uniq; 
       echo -e  "\n"
       echo -en "${BRed}Machine stats        :$NC " ; uptime ;
       echo -en "${BRed}Memory Total         :$NC " ; cat /proc/meminfo | grep "MemTotal" | awk '{print $2}'; 
       echo -e  "${BRed}Memory stats         :$NC " ; free;
       echo -e  "\n"
       echo -en "${BRed}CPU Sockets          :$NC " ; lscpu | grep "Socket" | awk '{print $2}';
       echo -en "${BRed}CPU Cores            :$NC " ; lscpu | grep "socket" | awk '{print $4}';
       echo -en "${BRed}Thread per CPU Core  :$NC " ; lscpu | grep "Thread" | awk '{print $4}';
       echo -en "${BRed}CPU Max Speed        :$NC " ; lscpu | grep "CPU max MHz:" | awk '{print $4}';
       echo -e  "\n"
       echo -e  "${BRed}Diskspace            :$NC " ; mydf / $HOME ;
       echo -e  "\n"
       echo -en "${BRed}Local IP Address     :$NC " ; my_ip 
       echo -e  "${BRed}Open connections     :$NC "; netstat -pan --inet; 
       echo 
    } 
  
  
    function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; } 
    function pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; } 
  
  
    function killps()   
    { 
        local pid pname sig="-TERM"  
        if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then 
            echo "Usage: killps [-SIGNAL] pattern" 
            return; 
        fi 
        if [ $# = 2 ]; then sig=$1 ; fi 
        for pid in $(my_ps| awk '!/awk/ && $0~pat { print $1 }' pat=${!#} ) 
        do 
            pname=$(my_ps | awk '$1~var { print $5 }' var=$pid ) 
            if ask "Kill process $pid <$pname> with signal $sig?" 
                then kill $sig $pid 
            fi 
        done 
    } 
  
  
    function swap() 
    { 
        local TMPFILE=tmp.$$ 
  
        [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1 
        [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1 
        [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1 
  
        mv "$1" $TMPFILE 
        mv "$2" "$1" 
        mv $TMPFILE "$2" 
    } 
  
    function ps_stop()   # stop process
    { 
        local pid pname sig="-STOP"  
        if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then 
            echo "Usage: killps [-SIGNAL] pattern" 
            return; 
        fi 
        if [ $# = 2 ]; then sig=$1 ; fi 
        for pid in $(my_ps| awk '!/awk/ && $0~pat { print $1 }' pat=${!#} ) 
        do 
            pname=$(my_ps | awk '$1~var { print $5 }' var=$pid ) 
            if ask "Kill process $pid <$pname> with signal $sig?" 
                then kill $sig $pid 
            fi 
         done 
    } 
  
 
    function ps_cont()   # Unstop 
    { 
        local pid pname sig="-CONT"  
        if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then 
             echo "Usage: killps [-SIGNAL] pattern" 
             return; 
        fi 
        if [ $# = 2 ]; then sig=$1 ; fi 
        for pid in $(my_ps| awk '!/awk/ && $0~pat { print $1 }' pat=${!#} ) 
        do 
            pname=$(my_ps | awk '$1~var { print $5 }' var=$pid ) 
            if ask "Kill process $pid <$pname> with signal $sig?" 
                 then kill $sig $pid 
            fi 
        done 
    } 
  
  
fi 

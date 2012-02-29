### PATHS ######################################################################

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin:~/bin

PLATFORM=`uname`
if [[ $PLATFORM == 'Darwin' ]]; then
  # command-line developer tools
  export PATH=$PATH:/Developer/usr/bin
fi

# my poor-man's vpn
export PATH=$PATH:~/code/oss/sshuttle

if [[ $PLATFORM == 'Darwin' ]]; then
  # clean all clipboard history files (for when I have to copy/paste a password
  # from 1Password)
  export PATH=$PATH:/Users/dlp/code/personal/scripts/cleanclipboard
fi

if [[ $PLATFORM == 'Darwin' ]]; then
  # arduino gcc toolchain binaries
  export PATH=$PATH:/usr/local/CrossPack-avr/bin
fi


### ALIASES ####################################################################

# colors!
if [[ $PLATFORM == 'Linux' ]]; then
  alias ls='ls --color=auto'
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
elif [[ $PLATFORM == 'Darwin' ]]; then
  # if only os x had GNU ls
  export CLICOLOR=1;
  export LSCOLORS=exGxhxDxcxhxhxhxhxcxcx
fi
alias grep='grep --color=auto'

alias la="ls -a"
alias ll="ls -alh"

alias ga='git add'
alias gp='git push'
alias gl='git log'
alias gs='git status -s'
alias gd='git diff'
alias gc='git commit'
alias gcm='git commit -m'
alias gb='git branch'
alias gk='git checkout'
alias gr='git reset'
alias gra='git remote add'
alias grr='git remote rm'
alias grb='git rebase'
alias gpl='git pull --rebase'
alias gcl='git clone'

alias keyon="ssh-add -t 14400"
alias keyoff='ssh-add -D'
alias keylist='ssh-add -l'

alias pageouts="top -l 1 \
                 | grep pageouts \
                 | sed 's/^.*pageins, \\([0-9]*\\)([0-9]*) pageouts.*$/\1/'"

# the address in there is where sax--my linux vm--lives.
alias prgmr_tunnel="while true; \
                      do sshuttle --dns -vvr dlp@focus.aperiodic.org 0/0 \
                                  -x 192.168.23.131; \
                      sleep 1; \
                    done" 


### SERVER GROUPS ##############################################################

lannisters=(tywin cersei kevan lancel jaime genna)
baratheons=(robert stannis renly steffon shireen)


### EC2 KEYS ###################################################################

if [[ `hostname` =~ 'fiona' ]]; then
  export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"
  export EC2_PRIVATE_KEY="$(/bin/ls $HOME/.ec2/pk-*.pem)"
  export EC2_CERT="$(/bin/ls $HOME/.ec2/cert-*.pem)"
  export EC2_HOME="/usr/local/Cellar/ec2-api-tools/1.4.2.2/jars"
fi


### GENERAL CLI GOODNESS #######################################################

[ -z "$SSH_CLIENT" ] && . $HOME/.ssh-agent

export PS1="[\u@\h:\W]$ "
set -o vi

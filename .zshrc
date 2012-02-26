### PATHS ######################################################################

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin

PLATFORM=`uname`
if [[ $PLATFORM == 'Darwin' ]]; then
  # command-line developer tools
  export PATH=$PATH:/Developer/usr/bin
fi

# my poor-man's vpn
export PATH=$PATH:~/code/oss/sshuttle

if [[ $PLATFORM == 'Darwin' ]]; then
  # clean all clipboard history files (for when I have to copy/paste a password from 1Password)
  export PATH=$PATH:/Users/dlp/code/personal/scripts/cleanclipboard
fi

if [[ $PLATFORM == 'Darwin' ]]; then
  # arduino gcc toolchain binaries
  export PATH=$PATH:/usr/local/CrossPack-avr/bin
fi


### ALIASES ####################################################################

alias la="ls -a"
alias ll="ls -alh"

# these save me a ton of time
alias ga='git add'
alias gp='git push'
alias gl='git log'
alias gs='git status -s'
alias gd='git diff'
alias gdc='git diff --cached'
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

alias ssh-agent="exec ssh-agent /bin/bash"
alias keyon="ssh-add -t 86400"
alias keyoff='ssh-add -D'
alias keylist='ssh-add -l'

alias pageouts="top -l 1 | grep pageouts | sed 's/^.*pageins, \\([0-9]*\\)([0-9]*) pageouts.*$/\1/'"

# the ip in there is the address of sax, my linux vm
alias prgmr_tunnel="while true; do sshuttle --dns -vvr dlp@focus.aperiodic.org 0/0 -x 192.168.23.131; sleep 1; done" 


### FUNCTIONS ##################################################################

# would like to know why this doesn't work
#pgrep() { ps aux | grep "$1" | awk '{print substr($*,1,100)'}


### SERVER GROUPS ##############################################################

lannisters=(tywin cersei kevan lancel jaime genna)
baratheons=(robert stannis renly)


### EC2 KEYS ###################################################################

if [[ `hostname` =~ 'fiona' ]] || [[ `hostname` =~ 'sax' ]]; then
  export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"
  export EC2_PRIVATE_KEY="$(/bin/ls $HOME/.ec2/pk-*.pem)"
  export EC2_CERT="$(/bin/ls $HOME/.ec2/cert-*.pem)"
  export EC2_HOME="/usr/local/Cellar/ec2-api-tools/1.4.2.2/jars"
fi


### GENERAL CLI GOODNESS #######################################################

export CLICOLOR=1;
export LSCOLORS=exGxhxDxcxhxhxhxhxcxcx
export PROMPT='[%n@%m:%~%F{blue}?:%?%f] %# '
set -o vi
bindkey -M vicmd '?' history-incremental-search-backward

PLATFORM=`uname`

### PATHS ######################################################################

if [[ $HOST == 'fiona' ]]; then
  export PATH=/usr/local/upgraded/bin:$PATH
  export PATH=/usr/local/Cellar/sqlite/3.7.10/bin:$PATH
fi

export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:~/bin:$PATH
export PATH=/usr/local/pgsql/bin:$PATH
export PATH=$PATH:/usr/local/lib/larceny

if [[ $PLATFORM == 'Darwin' ]]; then
  # command-line developer tools
  export PATH=$PATH:/Developer/usr/bin
fi

# my poor-man's vpn
export PATH=$PATH:~/src/oss/sshuttle

if [[ $PLATFORM == 'Darwin' ]]; then
  # clean all clipboard history files (for when I have to copy/paste a password
  # from 1Password)
  export PATH=$PATH:/Users/dlp/src/personal/scripts/cleanclipboard
fi

if [[ $PLATFORM == 'Darwin' ]]; then
  # arduino gcc toolchain binaries
  export PATH=$PATH:/usr/local/CrossPack-avr/bin
fi

if [[ $PLATFORM == 'Darwin' ]]; then
  export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"
elif [[ $PLATFORM == 'Linux' ]]; then
  export JAVA_HOME='/usr/lib/jvm/java-6-sun'
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

alias la='ls -a'
alias ll='ls -alh'

# these save me a ton of time
alias ga='git add'
alias gb='git branch'
alias gk='git checkout'
alias gcl='git clone'
alias gc='git commit'
alias gcm='git commit -m'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git log'
alias gpl='git pull --rebase'
alias gp='git push'
alias grb='git rebase'
alias gra='git remote add'
alias grr='git remote rm'
alias gr='git reset'
alias grm='git rm'
alias gs='git status -s'

if [[ $PLATFORM == 'Darwin' ]]; then
  alias ssh-agent="exec ssh-agent /bin/zsh"
elif [[ $PLATFORM == 'Linux' ]]; then
  alias ssh-agent="exec ssh-agent /usr/bin/zsh"
fi
alias keyon="ssh-add -t 86400"
alias keyoff='ssh-add -D'
alias keylist='ssh-add -l'

alias pageouts="top -l 1 \
                 | grep pageouts \
                 | sed 's/^.*pageins, \\([0-9]*\\)([0-9]*) pageouts.*$/\1/'"

# the address in there is where sax (my linux vm) lives.
alias prgmr_tunnel="while true; \
                      do sshuttle --dns -vvr dlp@focus.aperiodic.org 0/0 \
                                  -x 192.168.23.131; \
                      sleep 1; \
                    done"


### FUNCTIONS ##################################################################

# would like to know why this doesn't work
#pgrep() { ps aux | grep "$1" | awk '{print substr($*,1,100)'}


### AWS CREDENTIALS ############################################################

if [[ $HOST = 'fiona' ]]; then
  source ~/.aws_credentials
  export EC2_PRIVATE_KEY="$(/bin/ls $HOME/.ec2/pk-*.pem)"
  export EC2_CERT="$(/bin/ls $HOME/.ec2/cert-*.pem)"
  export EC2_HOME="/usr/local/Cellar/ec2-api-tools/1.4.2.2/jars"
fi

if [[ $HOST = 'sax' ]]; then
  export EC2_HOME='/home/dlp/.ec2/ec2-api-tools-1.5.2.5'
  export PATH=$PATH:$EC2_HOME/bin
  source ~/.aws_credentials
fi


### GENERAL CLI GOODNESS #######################################################

export PROMPT_L='[%n@%m:%~%F{blue}?:%?%f]'
export PROMPT="$PROMPT_L%# "
zle-keymap-select () {
  case $KEYMAP in
    vicmd) export PROMPT="$PROMPT_L%# ";;
    viins) export PROMPT="$PROMPT_L%F{blue}%#%f ";;
  esac
}

set -o vi
bindkey -M vicmd '?' history-incremental-search-backward

PLATFORM=`uname`

### PATHS ######################################################################

if [[ $HOST == 'fiona' ]]; then
  export PATH=/usr/local/upgraded/bin:$PATH
  export PATH=/usr/local/Cellar/sqlite/3.7.10/bin:$PATH
fi

export PATH=/usr/local/sbin:~/bin:$PATH
export PATH=/usr/local/pgsql/bin:$PATH
export PATH=/usr/bin:$PATH
export PATH=/usr/local/bin:$PATH

if [[ $PLATFORM == 'Darwin' ]]; then
  # command-line developer tools
  export PATH=$PATH:/Developer/usr/bin
  # my poor-man's vpn
  export PATH=$PATH:~/src/oss/sshuttle
  # clean all clipboard history files (for when I have to copy/paste a password
  # from 1Password)
  export PATH=$PATH:/Users/dlp/src/personal/scripts/cleanclipboard
  # truecrypt CLI
  alias truecrypt='/Applications/TrueCrypt.app/Contents/MacOS/Truecrypt --text'
fi

if [[ $PLATFORM == 'Darwin' ]]; then
  export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.7.0_21.jdk/Contents/Home"
elif [[ $PLATFORM == 'Linux' && -d /usr/lib/jvm ]]; then
  jdk=$(ls /usr/lib/jvm/ | grep 'java-7' | head -n 1)
  if [ ! -z "$jdk" ]; then
    export JAVA_HOME="/usr/lib/jvm/$jdk"
  fi
fi

if [ -e ~/.rbenv ]; then
  export PATH=~/.rbenv/bin:$PATH
  eval "$(rbenv init -)"
fi

# Puppet projects in RUBYLIB
for project in puppet facter hiera puppetdb beaker; do
  project_path=~/src/puppetlabs/$project
  if [ -e $project_path ]; then
    export RUBYLIB=$project_path:$RUBYLIB
  fi
done

# PSAS arm development tools
if [ -d ~/opt/psas ]; then
  export PATH=$PATH:~/opt/psas/x-tools/stm32f407/gcc-arm-none-eabi-4_7-2013q3/bin
fi

# slashpackage-convention commands
if [ -d /command ]; then
  export PATH=$PATH:/command
fi

# Amazon EC2 API/AMI tools
if [ ! -z "$(find /usr/local/ -iregex 'ec2-ami-*')" ]; then
  export EC2_AMITOOL_HOME="/usr/local/$(ls /usr/local | grep 'ec2-ami' | head -n 1)"
  export PATH=$PATH:$EC2_AMITOOL_HOME/bin
fi
if [ -z "$(find /usr/local/ -iregex 'ec2-api-*')" ]; then
  export EC2_HOME="/usr/local/$(ls /usr/local | grep 'ec2-api' | head -n 1)"
  export PATH=$PATH:$EC2_HOME/bin
fi

### ALIASES ####################################################################

alias la='ls -a'
alias ll='ls -alh'

# git aliases
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
alias gr='git reset'
alias grb='git rebase'
alias gra='git remote add'
alias grr='git remote rm'
alias grl='git remote'
alias grm='git rm'
alias gs='git status -s'

# ssh-agent aliases
if [[ $PLATFORM == 'Darwin' ]]; then
  alias ssh-agent="exec ssh-agent /bin/zsh"
elif [[ $PLATFORM == 'Linux' ]]; then
  alias ssh-agent="exec ssh-agent /usr/bin/zsh"
fi
alias keyon="ssh-add -t 14400"
alias keyoff='ssh-add -D'
alias keylist='ssh-add -l'

# xscreensaver lock alias
if [[ $PLATFORM == 'Linux' ]]; then
  alias xlock="xscreensaver-command -lock"
fi

alias pageouts="top -l 1 \
                 | grep pageouts \
                 | sed 's/^.*pageins, \\([0-9]*\\)([0-9]*) pageouts.*$/\1/'"

alias st_ocd="sudo openocd -f ~/src/psas/stm32/openocd/olimex_stm32_e407.cfg --search ~/opt/psas/openocd/share/openocd/scripts"


### FUNCTIONS ##################################################################

# would like to know why this doesn't work
#pgrep() { ps aux | grep "$1" | awk '{print substr($*,1,100)'}

function dict () {
  if [[ $1 == (d|m) ]]; then
    curl dict://dict.org/$1:$2 | less
  else
    echo 'Unknown command. Use (d)efine or (m)atch.'
  fi
}

### CREDENTIALS ################################################################

if [[ $HOST == 'kasei' ]]; then
  eval `keychain --confirm --clear --timeout 10 --eval --agents ssh id_rsa`
fi

### ZSH OPTIONS ################################################################

setopt hist_ignore_dups

### GENERAL CLI GOODNESS #######################################################

export TERM='xterm-256color'

export PROMPT_L='[%n@%m:%~%F{blue}?:%?%f]'
export PROMPT="$PROMPT_L%# "
zle-keymap-select () {
  case $KEYMAP in
    vicmd) export PROMPT="$PROMPT_L%# ";;
    viins) export PROMPT="$PROMPT_L%F{blue}%#%f ";;
  esac
}

export EDITOR=vim
export VISUAL=vim
set -o vi
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -s "^t" "\e"

if [[ $PLATFORM == 'Linux' ]]; then
  export LC_CTYPE=en_US.UTF-8
  alias fixkeyboard="setxkbmap -model pc104 -layout us -variant dvp -option ctrl:nocaps"
fi

# colors!
if [[ $PLATFORM == 'Linux' ]]; then
  alias ls='ls --color=auto'
  test -e ~/.dircolors && source ~/.dircolors || eval "$(dircolors -b)"
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
elif [[ $PLATFORM == 'Darwin' ]]; then
  # if only os x had GNU ls
  export CLICOLOR=1;
  export LSCOLORS=exGxhxDxcxhxhxhxhxcxcx
fi
alias grep='grep --color=auto'

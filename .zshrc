PLATFORM=`uname`

### PATHS ######################################################################

if [[ $HOST == 'fiona' ]]; then
  export PATH=/usr/local/upgraded/bin:$PATH
  export PATH=/usr/local/Cellar/sqlite/3.7.10/bin:$PATH
fi

export PATH=~/bin:$PATH

hc4_bin='/opt/HipChat4/bin'
if [[ -e $hc4_bin ]]; then
  export PATH=$PATH:$hc4_bin
fi

if [[ $PLATFORM == 'Linux' && -d /usr/lib/jvm ]]; then
  jdk=$(ls /usr/lib/jvm/ | grep 'java-7' | head -n 1)
  if [ ! -z "$jdk" ]; then
    export JAVA_HOME="/usr/lib/jvm/$jdk"
  fi
fi

# arch ruby gems path
ruby_gems_bin="$HOME/.gem/ruby/2.3.0/bin"
if [ -e "$ruby_gems_bin" ]; then
  export PATH="$PATH:$ruby_gems_bin"
fi

# Puppet projects in RUBYLIB
for project in puppet facter hiera puppetdb beaker; do
  project_path=~/src/work/puppetlabs/$project
  if [ -e $project_path ]; then
    export RUBYLIB=$project_path:$RUBYLIB
  fi
done

# PSAS arm development tools
if [ -d ~/opt/psas ]; then
  export PATH=$PATH:~/opt/psas/x-tools/stm32f407/gcc-arm-none-eabi-4_7-2013q3/bin
  alias st_ocd="sudo openocd -f ~/src/psas/stm32/openocd/olimex_stm32_e407.cfg --search ~/opt/psas/openocd/share/openocd/scripts"
fi

# slashpackage-convention commands
if [ -d /command ]; then
  export PATH=$PATH:/command
fi

# rbenv
if [ -d ~/.rbenv ]; then
  eval "$(rbenv init -)"
fi

# pyenv
if [ -d ~/.pyenv ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

homebrew_pg15_bin='/usr/local/opt/postgresql@15/bin'
# postgres 15
if [ -d "$homebrew_pg15_bin" ]; then
  export PATH="$PATH:$homebrew_pg15_bin"
fi

### ALIASES ####################################################################

alias la='ls -a'
alias ll='ls -alh'

alias be='bundle exec'

alias collapse-spaces='sed -e "s/[[:space:]]\{1,\}/ /g"'

alias tree-py="tree -I '__pycache__|*.egg-info|*.pyc' --prune"

# git aliases
# these save me a ton of time
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gcl='git clone'
alias gcm='git commit -m'
alias gd='git diff'
alias gdc='git diff --cached'
alias gk='git checkout'
alias gl='git log'
alias gpl='git pull --rebase'
alias gp='git push'
alias gr='git reset'
alias grb='git rebase'
alias grl='git remote'
alias gra='git remote add'
alias grr='git remote rm'
alias grs='git remote show'
alias grm='git rm'
alias gs='git status -s'

alias agpy="ag -G '.*\\.py'"

# ssh-agent aliases
if [[ $PLATFORM == 'Darwin' ]]; then
  alias ssh-agent="exec ssh-agent /bin/zsh"
elif [[ $PLATFORM == 'Linux' ]]; then
  alias ssh-agent="exec ssh-agent /usr/bin/zsh"
fi
alias keyon="ssh-add -t 14400"
alias keyoff='ssh-add -D'
alias keylist='ssh-add -l'

#### Platform-Specific Aliases

# aliases that are only available on one platform, not aliases that are
# available on all platforms but have different implementations

if [[ $PLATFORM == 'Linux' ]]; then
  alias xlock="xscreensaver-command -lock"
  alias startx="sx sh .xinitrc"
  alias pageouts="top -l 1 \
                   | grep pageouts \
                   | sed 's/^.*pageins, \\([0-9]*\\)([0-9]*) pageouts.*$/\1/'"
fi

if [[ $PLATFORM == 'Darwin' ]]; then
  alias flush-dns='sudo killall -HUP mDNSResponder'
  alias restart-dns='sudo killall -KILL mDNSResponder'
  alias xlock='open -a /System/Library/CoreServices/ScreenSaverEngine.app'

  if [[ "$(uname -m)" == 'arm64' ]]; then
    # x86-emulated homebrew, rather than native apple silicon homebrew
    alias x86-brew='arch --x86_64 /usr/local/Homebrew/bin/brew'
    alias x86='PATH=/usr/local/bin:$PATH'
  fi
fi


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

_EXTRACT_EC2_IP_WITH_SED_SUB='s/^[[:space:]]*"\(i-[0-9a-zA-Z]*\)"$/\1/'

function ec2-terminate-by-ip () {
  if [ -z "$1" ]; then
    echo "USAGE: $0 ip_address" 1>&2;
  else
    instance_id="$(aws ec2 describe-instances --filters Name=private-ip-address,Values=$1 --query 'Reservations[0].Instances[0].[InstanceId]' | grep "i-" | sed -e ${_EXTRACT_EC2_IP_WITH_SED_SUB})"
    aws ec2 terminate-instances --instance-ids ${instance_id}
  fi
}

function ec2-stop-by-ip () {
  if [ -z "$1" ]; then
    echo "USAGE: $0 ip_address" 1>&2;
  else
    instance_id="$(aws ec2 describe-instances --filters Name=private-ip-address,Values=$1 --query 'Reservations[0].Instances[0].[InstanceId]' | grep "i-" | sed -e ${_EXTRACT_EC2_IP_WITH_SED_SUB})"
    aws ec2 stop-instances --instance-ids ${instance_id}
  fi
}

function ec2-start-by-ip () {
  if [ -z "$1" ]; then
    echo "USAGE: $0 ip_address" 1>&2;
  else
    instance_id="$(aws ec2 describe-instances --filters Name=private-ip-address,Values=$1 --query 'Reservations[0].Instances[0].[InstanceId]' | grep "i-" | sed -e ${_EXTRACT_EC2_IP_WITH_SED_SUB})"
    aws ec2 start-instances --instance-ids ${instance_id}
  fi
}

function ec2-list-by-key () {
  if [ -z "$1" ]; then
    echo "USAGE: $0 key_name" 1>&2;
  else
    aws ec2 describe-instances --filters "Name=key-name,Values=$1" --query 'Reservations[*].Instances[*].[InstanceId,State]';
  fi
}

function ec2-id-to-ip () {
  if [ -z "$1" ]; then
    echo "USAGE: $0 instance-id" 1>&2;
  else
    aws ec2 describe-instances --instance-ids $1 --query 'Reservations[0].Instances[0].PrivateIpAddress' | sed -e 's/"//g';
  fi
}

function cleanup-branches () {
  for branch in $(git branch | grep -v '^\*' | sed -e 's/^[[:space:]]\{1,\}//'); do
    git branch -d $branch
  done
}

### CREDENTIALS ################################################################

if [[ $HOST == 'kasei' ]]; then
  eval `keychain --confirm --timeout 10 --eval --agents ssh id_rsa`
fi

### ZSH OPTIONS ################################################################

setopt hist_ignore_dups

### X11 ########################################################################

xresources="$HOME/.xresources"
if [[ -e "$xresources" ]] && command -v xrdb >/dev/null; then
  xrdb -m "$xresources"
fi

wp="$(find $HOME -maxdepth 1 -iname 'wallpaper.*')"
if [ ! -z "$wp" ] && command -v feh >/dev/null; then
  feh --bg-fill $wp
fi

### GENERAL CLI GOODNESS #######################################################

export EDITOR=vim
export VISUAL=vim
set -o vi
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -s "^t" "\e"

if [[ $TERM == "screen" ]]; then
  export TERM="xterm-256color"
fi

if [[ $PLATFORM == 'Linux' ]]; then
  export LC_CTYPE=en_US.UTF-8
  alias fixkeyboard="setxkbmap -model pc104 -layout us -variant dvp -option ctrl:nocaps"
fi

BASE_PROMPT='%#[%F{blue}%n@%m:%f%~%(?.%F{blue}.%F{red})#%f]'
INS_MODE_TRAILER='%F{yellow}|%f'
DEFAULT_PROMPT="$BASE_PROMPT "
export PROMPT=$DEFAULT_PROMPT

# Make prompt indicate current vim mode
# known bug: when you do a backwards search but cancel out with ^c
function zle-keymap-select zle-line-init {
  if [[ "$KEYMAP" == viins ]] || [[ "$KEYMAP" == main ]]; then
    PROMPT="${BASE_PROMPT}${INS_MODE_TRAILER}"
  else
    PROMPT=$DEFAULT_PROMPT
  fi

  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select


# colors!
if [[ $PLATFORM == 'Linux' ]]; then
  alias ls='ls --color=auto'
  test -e ~/.dircolors && source ~/.dircolors || eval "$(dircolors -b)"
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
elif [[ $PLATFORM == 'Darwin' ]]; then
  # if only os x had GNU ls
  export CLICOLOR=1;
  export LSCOLORS=exgxhxDxcxdxfxFxhxcxcx
fi
alias grep='grep --color=auto'

zfuncs_dir="$HOME/.zfunc"
if [[ -d "$zfuncs_dir" ]]; then
  fpath+="$zfuncs_dir"
fi

# Git tab completion
autoload -Uz compinit && compinit

# increase file descriptor limit; with current MacOS default of 256, some unit
# tests fail
ulimit -n 1024

export DOCKER_DEFAULT_PLATFORM=linux/amd64

### ZSH PLUGINS ################################################################

source ~/.zsh-plugins/syntax-highlighting/zsh-syntax-highlighting.zsh

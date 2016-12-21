# Path to your oh-my-zsh configuration.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="clean"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# source oh-my-zsh init.
source $ZSH/oh-my-zsh.sh

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(tmux docker docker-compose git suse python colorize zsh-syntax-highlighting history history-substring-search)


# update path
export PATH=/usr/local/bin:/usr/local/sbin:${PATH}


# Set architecture flags
export ARCHFLAGS="-arch x86_64"


# Java setup
unset JAVA_HOME
unset JAVA_BINDIR
unset JAVA_ROOT
unset JDK_HOME
unset JRE_HOME
unset SDK_HOME

export JAVA_BINDIR="/usr/lib64/jvm/java/bin"
export JAVA_HOME="/usr/lib64/jvm/java"
export JAVA_ROOT="/usr/lib64/jvm/java"
export JDK_HOME="/usr/lib64/jvm/java"
export JRE_HOME="/usr/lib64/jvm/java/jre"
export SDK_HOME="/usr/lib64/jvm/java"

# alias
source $HOME/.aliases

# unset kssh
unset SSH_ASKPASS

# graphic accelerate
export MOZ_USE_OMTC=1

# editor
export EDITOR='vim'

# tmux windows name show properly
export DISABLE_AUTO_TITLE=true

# zypper use aria2
export ZYPP_ARIA2C=1

# oracle stupid proxy
#export http_proxy=http://www-proxy.us.oracle.com:80
#export http_proxys=http://www-proxy.us.oracle.com:80

# opengrok
#export OPENGROK_TOMCAT_BASE=/home/vsProject/application/apache-tomcat-9.0.0.M3
#export CATALINA_BASE=${OPENGROK_TOMCAT_BASE}
#export OPENGROK_INSTANCE_BASE=/home/vsProject/opengrok_data

# export TERM=screen-256color
# export TERM=xterm-256color
eval `dircolors ~/.dir_colors/dircolors-solarized-master/dircolors.ansi-light`

# start tmux function
function start_tmux() {
    if type tmux &> /dev/null; then
        #if not inside a tmux session, and if no session is started, start a new session
        #if [[ $HOST == "buddha-ca" && -z "$TMUX" && -z $TERMINAL_CONTEXT ]]; then
        if [[ -z "$TMUX" && -z $TERMINAL_CONTEXT ]]; then
            (tmux -2 attach || tmux -2 new-session)
        fi
    fi
}

start_tmux

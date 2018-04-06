# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Startup config
source /usr/bin/thisroot.sh

# local path
export PATH=/bin/:/sbin/:/usr/local/bin/:/usr/bin/voms-clients/bin/

# EOS setup
export EOS_MGM_URL="root://eosuser"

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# proper <Tab> completion for shell variables
if ((BASH_VERSINFO[0] >= 4)) && ((BASH_VERSINFO[1] >= 2)); then
   shopt -s direxpand
fi

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#-------------------------------------------------------------------------------
#COLORED PROMPT :D

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# il prompt dei campioni ;)

orange='\e[1;24m'
green='\e[0;32m'
blu='\e[0;34m'
red='\e[1;34m'
time='\e[1;32m'
dir='\e[34m'
reset='\e[00m'

#PS1="\\[${orange}\]┌─[\\[${green}\]\u\\[${reset}\]\\[${orange}\]@\\[${green}\]\h\\[${reset}\]\\[${orange}\]: \\[${blu}\]\$(pwd)\\[${reset}\]\\[${orange}\]]\\[${reset}\]\r\n\\[${orange}\]└─[\\[${time}\]⌚ \t\\[${reset}\]\\[${orange}\]|\\[${dir}\] \W\\[${reset}\]\\[${orange}\]]► \\[${reset}\]"

unset color_prompt force_color_prompt

# set title
PROMPT_COMMAND="echo -ne '\033]0;APOLLO\007'"

#------------------------------------------------------------------------------

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -ahlF'
alias la='ls -A'
alias l='ls -CF'
alias q='exit'
alias rmtmp='rm $(find ./ | grep ".*~") &> /dev/null'
alias emacs="emacs -nw"
#"fg emacs &> /dev/null || emacs -nw"
alias gnus='emacs -f gnus'
alias afsinit='source /usr/local/bin/afs_init.sh'

# path alias
export AFS_HOME=/afs/cern.ch/user/s/spigazzi/

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Enviroment tuning
export VISUAL="emacs -nw"
export EDITOR=emacs
export LS_COLORS=$LS_COLORS'*.cfg=00;36:'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -f /usr/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh ]; then
    source /usr/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
fi


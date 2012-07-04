# Bash completion
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

export GIT_PS1_SHOWDIRTYSTATE=1

colorless="\[\033[0m\]"    # unsets color to term's fg color
    
# regular colors
textK="\[\033[0;30m\]"    # black
textR="\[\033[0;31m\]"    # red
textG="\[\033[0;32m\]"    # green
textY="\[\033[0;33m\]"    # yellow
textB="\[\033[0;34m\]"    # blue
textM="\[\033[0;35m\]"    # magenta
textC="\[\033[0;36m\]"    # cyan
textW="\[\033[0;37m\]"    # white

# emphasized (bolded) colors
emphK="\[\033[1;30m\]"
emphR="\[\033[1;31m\]"
emphG="\[\033[1;32m\]"
emphY="\[\033[1;33m\]"
emphB="\[\033[1;34m\]"
emphM="\[\033[1;35m\]"
emphC="\[\033[1;36m\]"
emphW="\[\033[1;37m\]"

# background colors
backgK="\[\033[40m\]"
backgR="\[\033[41m\]"
backgG="\[\033[42m\]"
backgY="\[\033[43m\]"
backgB="\[\033[44m\]"
backgM="\[\033[45m\]"
backgC="\[\033[46m\]"
backgW="\[\033[47m\]"

export PS1="\[$textC$backgK\]\u@\h\[$textM$backgK\] \w\[$textY$backgK\]\$(__git_ps1)\[$textB\] \$\[\033[00m\] "


# Setting PATH for MacPython 2.5
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/Current/bin:${PATH}"
export PATH

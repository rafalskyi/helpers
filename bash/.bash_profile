 # Path env
export PATH="/usr/local/mysql/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/opt/gettext/bin:$PATH"

export PATH="/Users/raf/pear/bin/pear:$PATH"
export PATH="/usr/local/Library/Formula:$PATH"
export PATH="/Applications/IntelliJ IDEA 13.app/plugins/testng/lib:$PATH"

#source .bash_profile

# Aliases
alias ls='ls -FGal'
alias mysqls='sudo /usr/local/mysql/support-files/mysql.server'
alias apachectls='sudo apachectl -k'
alias updatedb='sudo /usr/libexec/locate.updatedb'
alias sites='cd /Users/raf/Sites'
alias gvo='cd /Users/raf/Sites/gogvo.srv/www/public_html'
alias 7min='cd /Users/raf/Sites/7minuteworkout.srv/www/public_html'
alias 7minsoc='cd /Users/raf/Sites/7minuteworkout.srv/social7min/www/public_html'
alias PL='cd /Users/raf/Sites/pureleverage.srv/www/public_html'
alias HC='cd /Users/raf/Sites/hotconference.srv/www/public_html'
alias GC='cd /Users/raf/Sites/gvoconference.srv/www/public_html'
alias HTP='cd /Users/raf/Sites/hostthenprofit.srv/www/public_html'
alias phpswitch='sudo /Users/raf/helpers/bash/phpswitcher.sh'
alias branchup='/Users/raf/helpers/bash/branchesup.sh'

# Colors
export CLICOLOR=1
LSCOLORS=gxfxcxdxbxegedabagacad
#export LSCOLORS=GxFxCxDxBxegedabagaced
# set custom bash prompt
export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH

#Чтобы одинаковые команды не сохранялись в истории, добавьте строчку:
HISTCONTROL=ignoredups
#Не добавлять запись в историю команд, если команда начинается с пробела:
HISTCONTROL=ignorespace
#стираются все повторения, в том числе идущие не подряд, но в разной последовательности. (например, после cd..ls..cd..ls останется cd и ls)
HISTCONTROL=erasedups
# Чтобы история команд сохранялась сразу после ввода (а не во время закрытия терминала)
shopt -s histappend
PROMPT_COMMAND='history -a; history -n' 
#чистить историю переходом mc
export HISTIGNORE="&:ls:[bf]g:exit: cd \"\'*: PROMPT_COMMAND='*"

export PATH="/opt/chef/embedded/bin:$PATH"

export NODE_PATH=".:/Users/raf/Sites/test/node:$NODE_PATH"

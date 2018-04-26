#hortcuts for accessing directories
alias uni="cd /home/uni/university/"
# ...

# shortcuts for commands
alias ll='ls -lh --color=auto --group-directories-first'
alias ls='_ls'
function _ls
{
	if [[ $# -gt 0 ]]; then
		'ls' $@;
	else
		'ls' -F -1 --color=auto --group-directories-first;
	fi
}

alias ,='cd ..'
alias ,,='cd ../..'
alias ,,,='cd ../../..'

alias df='df -h'
alias free='free -h'
alias vi='vim'
alias lessend='less +G'
alias remake='make clean && make'
alias vmstat='vmstat -S M -w'
alias bc='bc -l'
alias cl='clear'
alias val='echo $?'
alias mars='java -jar Mars.jar'

# for git
alias gis='git status --short'
alias gil='git log --graph --oneline --decorate=full'

# for managing wifi through NetworkManager
alias wifi_on='sudo nmcli radio wifi on'
alias wifi_off='sudo nmcli radio wifi off'

# opens the given file with the associated graphical application
function run
{
	xdg-open "$@" 2> /dev/null 
}

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

function nonzero_return() {
	RETVAL=$?
	[ $RETVAL -ne 0 ] && echo "$RETVAL"
}

export PS1="\u\[\e[36m\]\w\[\e[m\]\[\e[41m\]\`nonzero_return\`\[\e[m\]\[\e[41m\]\`parse_git_branch\`\[\e[m\] "


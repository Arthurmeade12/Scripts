#!/usr/local/Cellar/bash/5.1.8/bin/bash
echo "Git prompt on"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
if [ -f "/usr/local/opt/bash-git-prompt/share/gitprompt.sh" ]; then
	__GIT_PROMPT_DIR="/usr/local/opt/bash-git-prompt/share"
 	source "/usr/local/opt/bash-git-prompt/share/gitprompt.sh"
fi

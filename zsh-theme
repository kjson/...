if [[ "$TERM" != "dumb" ]] && [[ "$DISABLE_LS_COLORS" != "true" ]]; then
    ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[green]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY=""
    ZSH_THEME_GIT_PROMPT_CLEAN=""
    return_code="%(?..%{$fg[red]%}%? %{$reset_color%})"
    ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} added"
    ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} modified"
    ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} deleted"
    ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[brown]%} renamed"
    ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} unmerged"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} untracked"
    PROMPT='%{$fg[blue]%}[%{$fg[white]%}%D{%F:%T} %{$fg[white]%}%n%{$reset_color%}@%{$fg[white]%}%m%{$reset_color%}:%{$fg[white]%}%~%{$reset_color%}%{$fg[blue]%}]$(git_prompt_info)$(git_prompt_status) %{$reset_color%}
${return_code}→ '
    # RPROMPT='${return_code}$(git_prompt_status)%{$reset_color%}'
    RPROMPT=''
else
    PROMPT='[%n@%m:%~$(git_prompt_info)]
%# '
    ZSH_THEME_GIT_PROMPT_PREFIX=" on"
    ZSH_THEME_GIT_PROMPT_SUFFIX=""
    ZSH_THEME_GIT_PROMPT_DIRTY=""
    ZSH_THEME_GIT_PROMPT_CLEAN=""
    # display exitcode on the right when >0
    return_code="%(?..%? ↵)"
    RPROMPT='${return_code}$(git_prompt_status)'
    ZSH_THEME_GIT_PROMPT_ADDED=" ✚"
    ZSH_THEME_GIT_PROMPT_MODIFIED=" ✹"
    ZSH_THEME_GIT_PROMPT_DELETED=" ✖"
    ZSH_THEME_GIT_PROMPT_RENAMED=" ➜"
    ZSH_THEME_GIT_PROMPT_UNMERGED=" ═"
    ZSH_THEME_GIT_PROMPT_UNTRACKED=" ✭"
fi

# ZSH Git Prompt Plugin
# This is a franensteinian hybrid of:
# - https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/git-prompt/git-prompt.plugin.zsh
# - https://github.com/magicmonty/bash-git-prompt/blob/master/gitstatus.sh


__GIT_PROMPT_DIR="${0:A:h}"

## Hook function definitions
function chpwd_update_git_vars() {
    update_current_git_vars
}

function preexec_update_git_vars() {
    case "$2" in
        git*|hub*|gh*|stg*)
        __EXECUTED_GIT_COMMAND=1
        ;;
    esac
}

function precmd_update_git_vars() {
    if [ -n "$__EXECUTED_GIT_COMMAND" ] || [ ! -n "$ZSH_THEME_GIT_PROMPT_CACHE" ]; then
        update_current_git_vars
        unset __EXECUTED_GIT_COMMAND
    fi
}

chpwd_functions+=(chpwd_update_git_vars)
precmd_functions+=(precmd_update_git_vars)
preexec_functions+=(preexec_update_git_vars)


## Function definitions
function update_current_git_vars() {
    unset _GIT_STATUS

    GITSTATUS=$( LC_ALL=C git status --porcelain --branch 2>/dev/null )
    # if the status is fatal, exit now
    [[ "$?" -ne 0 ]] && return

    GIT_STAGED=0
    GIT_CHANGED=0
    GIT_CONFLICTS=0
    GIT_UNTRACKED=0

    while IFS='' read -r line || [[ -n "$line" ]]; do
      STATUS=${line:0:2}
      case "$STATUS" in
        \#\#) BRANCH_LINE="${line/\.\.\./^}" ;;
        ?M) ((GIT_CHANGED++)) ;;
        U?) ((GIT_CONFLICTS++)) ;;
        \?\?) ((GIT_UNTRACKED++)) ;;
        *) ((GIT_STAGED++)) ;;
      esac
    done <<< "$GITSTATUS"

    IFS="^" read -rA BRANCH_FIELDS <<< "${BRANCH_LINE/\#\# }"
    BRANCH="${BRANCH_FIELDS[0]}"
    remote=
    upstream=

    if [[ "$BRANCH" == *"Initial commit on"* ]]; then
      IFS=" " read -rA FIELDS <<< "$BRANCH"
      BRANCH="${FIELDS[3]}"
      remote="_NO_REMOTE_TRACKING_"
    elif [[ "$BRANCH" == *"no branch"* ]]; then
      tag=$( git describe --exact-match )
      if [[ -n "$tag" ]]; then
        BRANCH="$tag"
      else
        BRANCH="_PREHASH_$( git rev-parse --short HEAD )"
      fi
    else
      if [[ "${#BRANCH_FIELDS[@]}" -eq 1 ]]; then
        remote="_NO_REMOTE_TRACKING_"
      else
        IFS="[,]" read -rA REMOTE_FIELDS <<< "${BRANCH_FIELDS[1]}"
        for REMOTE_FIELD in "${REMOTE_FIELDS[@]}"; do
          if [[ "$REMOTE_FIELD" == *ahead* ]]; then
            num_ahead=${REMOTE_FIELD:6}
          fi
          if [[ "$REMOTE_FIELD" == *behind* ]]; then
            num_behind=${REMOTE_FIELD:7}
          fi
        done
      fi
    fi

    GIT_BRANCH=$BRANCH
    GIT_AHEAD=$num_ahead
    GIT_BEHIND=$num_behind
    _GIT_STATUS=1
}

git_super_status() {
    precmd_update_git_vars
    if [ -n "$_GIT_STATUS" ]; then
      STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_THEME_GIT_PROMPT_BRANCH$GIT_BRANCH%{${reset_color}%}"
      if [ "$GIT_BEHIND" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_BEHIND$GIT_BEHIND%{${reset_color}%}"
      fi
      if [ "$GIT_AHEAD" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD$GIT_AHEAD%{${reset_color}%}"
      fi
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR"
      if [ "$GIT_STAGED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED$GIT_STAGED%{${reset_color}%}"
      fi
      if [ "$GIT_CONFLICTS" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CONFLICTS$GIT_CONFLICTS%{${reset_color}%}"
      fi
      if [ "$GIT_CHANGED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CHANGED$GIT_CHANGED%{${reset_color}%}"
      fi
      if [ "$GIT_UNTRACKED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED%{${reset_color}%}"
      fi
      if [ "$GIT_CHANGED" -eq "0" ] && [ "$GIT_CONFLICTS" -eq "0" ] && [ "$GIT_STAGED" -eq "0" ] && [ "$GIT_UNTRACKED" -eq "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
      fi
      STATUS="$STATUS%{${reset_color}%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
      echo "$STATUS"
    fi
}

# Default values for the appearance of the prompt.
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}%{●%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{✖%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[blue]%}%{✚%G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{↓%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{↑%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{…%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}%{✔%G%}"

# Set the prompt.
RPROMPT='$(git_super_status)'

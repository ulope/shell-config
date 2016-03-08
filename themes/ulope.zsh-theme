# Largely based on oh-my-zsh:themes/dstufft

function vcs_char {
    [ ! -z (../)#.git(N:a:h) ] && echo '±' && return
    [ ! -z (../)#.hg(N:a:h) ] && echo 'Hg' && return
    echo '○'
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo " ⊙ %{$fg[cyan]%}"$(basename $VIRTUAL_ENV)"%{$reset_color%}"
}

function version_info {
    VERSION=$([ ! -z (../)#setup.cfg(N:a) ] && grep -q "bumpversion" (../)#setup.cfg(N:a) && git describe --tags)
    [ ! -z $VERSION ] && echo "%{$FG[202]%} ${VERSION}%{$reset_color%}"
}

VCS_CHAR="$(vcs_char)"

PROMPT='
%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%} %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}$(git_prompt_info)$(virtualenv_info)$(version_info)
$VCS_CHAR '

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[blue]%}$VCS_CHAR %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

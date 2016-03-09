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

PROMPT='
%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%} %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}$(git_super_status)$(version_info)$(virtualenv_info)
$(vcs_char) '

RPROMPT=""

ZSH_THEME_GIT_PROMPT_PREFIX=' %{$fg[blue]%}$(vcs_char) %{$fg[magenta]%}'
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

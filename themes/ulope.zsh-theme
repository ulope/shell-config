# Largely based on oh-my-zsh:themes/dstufft

function vcs_char {
    [ ! -z (../)#.git(N:a:h) ] && echo '±' && return
    [ ! -z (../)#.hg(N:a:h) ] && echo 'Hg' && return
    echo '○'
}

function virtualenv_info {
    if [ $VIRTUAL_ENV ]; then
        echo -n " ⊙ %{$fg[cyan]%}"$(basename $VIRTUAL_ENV)
        if [ -e $VIRTUAL_ENV/lib ]; then
            echo -n "%{$reset_color%}@%{$FG[141]%}"$(echo ${VIRTUAL_ENV}/lib/python* | sed -e "s#.*/lib/python##")
        fi
        if [ -e $VIRTUAL_ENV/lib_pypy ]; then
            echo -n "%{$reset_color%}@%{$FG[141]%}pypy"$(basename ${VIRTUAL_ENV}/lib-python/*)
        fi
        echo "%{$reset_color%}"
    fi
}

function version_info {
    VERSION=$([ ! -z (../)#setup.cfg(N:a) ] && grep -q "bumpversion" (../)#setup.cfg(N:a) && git describe --tags --always 2> /dev/null)
    [ ! -z $VERSION ] && echo "%{$FG[202]%} ${VERSION}%{$reset_color%}"
}

PROMPT='
%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%} %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}$(git_super_status)$(version_info)$(virtualenv_info)
$(vcs_char) '

RPROMPT=""

ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

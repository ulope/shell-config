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
    VERSION_1=$([ ! -z (../)#.bumpversion*.cfg(NY1:a) ] && grep -q "bumpversion" (../)#.bumpversion*.cfg(NY1:a) && git describe --tags --always 2> /dev/null)
    VERSION_2=$([ ! -z (../)#setup.cfg(N:a) ] && grep -q "bumpversion" (../)#setup.cfg(N:a) && git describe --tags --always 2> /dev/null)
    [ ! -z $VERSION_1 ] && echo "%{$FG[202]%} ${VERSION_1}%{$reset_color%}"
    [ ! -z $VERSION_2 ] && echo "%{$FG[202]%} ${VERSION_2}%{$reset_color%}"
}

function task_todos {
    TASK_COUNT_RDY=$(task +READY count 2> /dev/null)
    TASK_COUNT_DUE=$(task +READY +DUE count 2> /dev/null)
    TASK_COUNT_OVRDUE=$(task +READY due.before:today count 2> /dev/null)
    COLOR="027"
    if [[ $TASK_COUNT_OVRDUE -gt 0 ]]; then 
        COLOR="196"
    elif [[ $TASK_COUNT_DUE -gt 0 ]]; then
        COLOR="208"
    fi
    [ $(($TASK_COUNT_RDY + $TASK_COUNT_DUE + $TASK_COUNT_OVRDUE)) -gt 0 ] && echo "%{$FG[$COLOR]%} ->> ${TASK_COUNT_RDY}·${TASK_COUNT_DUE}·${TASK_COUNT_OVRDUE}%{$reset_color%}"
}

PROMPT='
%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%}$(task_todos) %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}$(git_super_status)$(version_info)$(virtualenv_info)
%{$(iterm2_prompt_mark)%}$(vcs_char) '

RPROMPT=""

ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

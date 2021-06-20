# Everyone needs a little color in their lives
if [[ -n ${ZSH_VERSION} ]]; then
    #RED='%F{red}'
    #GREEN='%F{green}'
    #YELLOW='%F{228}'
    #BLUE='%F{blue}'
    ORANGE='%F{202}'
    PURPLE='%F{104}'
    #CYAN='%F{51}'
    #WHITE='%F{15}'
    BLACK='%F{#9d8b70}'
    RED='%F{#d35c5c}'
    GREEN='%F{#b7ba53}'
    YELLOW='%F{#e0ac16}'
    BLUE='%F{#88a4d3}'
    MAGENTA='%F{#bb90e2}'
    CYAN='%F{#6eb958}'
    WHITE='%F{#e4d4c8}'
    NIL='%f'

    # Host name styles
    FULL='%M'
    SHORT='%m'
else
    RED='\[\033[31m\]'
    GREEN='\[\033[32m\]'
    YELLOW='\[\033[33m\]'
    BLUE='\[\033[34m\]'
    PURPLE='\[\033[35m\]'
    CYAN='\[\033[36m\]'
    WHITE='\[\033[37m\]'
    NIL='\[\033[00m\]'

    # Host name styles
    FULL='\H'
    SHORT='\h'
fi

# System => color/hostname map
# UC: username color
# HC: hostname color
# LC: location/cwd color
# VC: pyvenv color
# BC: git branch name color
# HD: hostname display (full or short)
# Defaults
UC=$YELLOW
HC=$BLUE
LC=$CYAN
VC=$PURPLE
BC=$YELLOW
HD=$FULL

# Prompt function (using PROMPT_COMMAND (?))
function set_prompt()
{
    # If logged in as another user, not gonna have all this firing anyway
    # so let's just show the host only and be done with it
    host="${UC}${HD}${NIL}"
    # Special vim-tab-like shortpath (~/folder/directory/foo => ~/f/d/foo)
    _pwd=`pwd | sed "s#$HOME#~#"`
#     if [[ $_pwd == "~" ]]; then
#         _dirname=$_pwd
#     else
#         _dirname = `dirname "$_pwd" `
#         if [[ $_dirname == "/" ]]; then
#             _dirname=""
#         fi
#         _dirname="$_dirname/`basename "$_pwd"`"
#     fi
    _dirname=$_pwd
    cur_path="${LC}${_dirname}${NIL} "
    if [[ -n ${ZSH_VERSION} ]]; then
        myuser="${UC}${USER}@${HC}${FULL}${NIL} "
    else
        myuser="${UC}\u@${HC}${FULL}${NIL} "
    fi
    # Git branch / dirtiness
    # from http://henrik.nyh.se/2008/12/git-dirty-promt#comment-8325834
    if git update-index -q --refresh 2>/dev/null; git diff-index --quiet --cached HEAD --ignore-submodules -- 2>/dev/null && git diff-files --quiet --ignore-submodules 2>/dev/null
        then dirty=""
    else
        dirty="${RED}*${NIL}"
    fi
    _branch=$(git symbolic-ref HEAD 2>/dev/null)
    _branch=${_branch#refs/heads/}  #apparently faster than sed
    branch=""  #need this to clear it when we leave a repo
    if [[ -n $_branch ]]; then
        branch="${NIL}[${BC}${_branch}${dirty}${NIL}]"
    fi
    # Dollar/pound sign
    end="${LC}\$${NIL} "
    # Virtual env
    if [[ $VIRTUAL_ENV != "" ]]
    then
        venv="${VC}(${VIRTUAL_ENV##*/}) "
    else
        venv=""
    fi
    export PS1="${venv}${myuser}${cur_path}${branch}${end}"
}

export PROMPT_COMMAND=set_prompt


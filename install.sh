#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

install_file() {
    local src="$1"
    if [ -z "$2" ]; then
        local dst_base="$HOME"
    else
        local dst_base="${HOME}/${2}"
    fi
    mkdir -p $dst_base
    local dst="${dst_base}/$(basename $1)"

    #echo "Symlinking with src=$src and dst=$dst for arg=$1"
    #echo "Symlinking to $src"
    #echo "synlink destination is in $dst_base"
    #return

    if [[ -f $dst || -d $dst ]]; then
        if [ -L $dst ]; then
            echo "$dst is already a symlink - skipping."
        else
            echo "ERROR!! $dst exists and is not a symlink! please decide which you want to keep"
            exit
        fi
    else
        ln -s $src $dst
    fi
}

install_dir() {
    local dir=$1
    local project=$2
    #echo "install dir $dir in project $project"
    for file in $(ls -a ${project}/${dir} | grep -Pv '^(\.){1,2}$'); do
        local full_path="${project}/${dir}/${file}"
        if [ -d $full_path ]; then
            install_dir ${dir}/${file} $project
        else
            install_file "${SCRIPT_DIR}/${project}/${dir}/${file}" "$dir"
        fi
    done
}

# NOTE: $1 should be absolute path
install_project() {
    local project="$1"
    for file in $(ls -a $project | grep -Pv '^(\.){1,2}$'); do
        if [ -d ${project}/${file} ]; then
            install_dir $file $project
        else
            install_file "${SCRIPT_DIR}/${1}/${file}"
        fi
    done
}

projects=(
    "alacritty"
    "apt"
    "bash"
    "git"
    "i3"
    "i3lock-fancier"
    "matplotlib"
    "python"
    "shell"
    "spotifork"
    "sublime_text3"
    "tcsh"
    "termite"
    "urxvt"
    "vim"
    "vscode"
    "X11"
    "xmidas"
    "zsh"
)

if [[ -z "$1" || "$1" == "all" ]]; then
    echo "installing all projects ($1)"
    for project in ${projects[@]}; do
        echo "processing $project"
        install_project "$project"
    done
else
    project="${1%/}"
    echo "only installing project $project"
    install_project $project
fi

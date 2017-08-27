# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin directories
PATH="$HOME/bin:$HOME/.local/bin:$PATH"

## Set Synaptics touchpad options
export synclient TapButton1=1 TapButton2=3 TapButton3=2
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export MATLAB_JAVA=/usr/lib/jvm/java-8-openjdk-amd64
# PATH=$PATH:$HOME/bin:$JAVA_HOME/bin
# export JRE_HOME
# export PATH

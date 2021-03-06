#!/bin/bash

# Environment support
cygwin=false;
osx=false;
env='linux';
case "`uname`" in 
    CYGWIN*) cygwin=true; env='cygwin' ;;
    Darwin*) osx=true; env='osx' ;;
esac

echo "Install for $env"

# Link dotfiles to $HOME
# pick environment specific override if it exists
# allow an optional second parameter - the "dot directory"
# if the "dot directory" is present, the link will be "HOME/.directory/file"
# if the "dot directory" is NOT present, the link will be "HOME/.file"
link() {
    dotfiles="$HOME/dotfiles"
    if [ $# -gt 1 ]; then
        mkdir -p "$HOME/$2"
        link="$HOME/.$2/$1"
    else
        link="$HOME/.$1"
    fi
    if [ ! -e "$link" ]; then
        if [ -e "$dotfiles/$env/$1" ]; then
            ln -s "$dotfiles/$env/$1" "$link"
        elif [ -e "$dotfiles/$1" ]; then
            ln -s "$dotfiles/$1" "$link"
        fi
    fi
}

# Installs the dotfiles to the home directory
# this is useful if I want to have one command to download and install the dotfiles repo
cd $HOME
if [ ! -d $HOME/dotfiles ] ; then
  git clone git@github.com:gilday/dotfiles.git
fi


echo 'Link dotfiles'

link 'bashrc'
link 'bash_profile'
link 'bash_aliases'
link 'ackrc'
link 'vimrc'
link 'gitconfig'
link 'inputrc'
link 'screenrc'
link 'gradle.properties' 'gradle'
link 'tmux.conf'

echo 'Set color scheme'
if [ ! -e "$HOME/.dircolors" ]; then
    git clone -q git://github.com/seebi/dircolors-solarized "$HOME/dotfiles/packages/dircolors-solarized"
    ln -s "$HOME/dotfiles/packages/dircolors-solarized/dircolors.ansi-dark" "$HOME/.dircolors"
fi
if $centos && [ ! -e "$HOME/dotfiles/packages/gnome-terminal-colors-solarized" ]; then
    git clone -q git://github.com/Anthony25/gnome-terminal-colors-solarized "$HOME/dotfiles/packages/gnome-terminal-colors-solarized"
    echo 'installing shell colors. answer prompts to install colors to gnome terminal profile'
    $HOME/dotfiles/packages/gnome-terminal-colors-solarized/install.sh
fi
if $cygwin && [ ! -e "$HOME/.minttyrc" ]; then
    git clone -q git://github.com/karlin/mintty-colors-solarized "$HOME/dotfiles/packages/mintty-colors-solarized"
    ln -s "$HOME/dotfiles/packages/mintty-colors-solarized/.minttyrc--solarized-dark" "$HOME/.minttyrc"
fi
eval `dircolors ~/.dircolors`


mkdir -p "$HOME/.vim/autoload"
cp "$HOME/dotfiles/autoload/pathogen.vim" "$HOME/.vim/autoload/"
if [ ! -e "$HOME/.vim/bundle" ]; then
    ln -s "$dotfiles/bundle" "$HOME/.vim/bundle"
fi

#$HOME/dotfiles/install-bundles.sh


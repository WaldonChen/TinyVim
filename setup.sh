#!/usr/bin/env bash

help() {
    echo "setup.sh -- setup TinyVim"
    echo "Usage: setup.sh -i|-c|-n"
    echo "    -i --install TinyVim"
    echo "    -c --compress TinyVim"
    echo "    -n --update TinyVim"
}

color_print() {
    printf '\033[0;31m%s\033[0m\n' "$1"
}

logo() {
    color_print '  _____ _                 _         '
    color_print ' /_  _/(_)_____  ___   __(_)___ ___ '
    color_print '  / / / / __ \ \/ / | / / / __ `__ \'
    color_print ' / / / / / / /\  /| |/ / / / / / / /'
    color_print '/_/ /_/_/ /_/ / / |___/_/_/ /_/ /_/ '
    color_print '             /_/                    '
}

compress()
{
    TINYVIM_ROOT=$HOME/.TinyVim
    CONFIG_FILE=${TINYVIM_ROOT}/TinyVim.`date +%Y-%m-%d`.tar.gz

    color_print "Compressing TinyVim configuration..."
    cd $HOME
    tar --exclude="TinyVim.*.tar.gz" \
        -zcf ${CONFIG_FILE}          \
        .vim/ .TinyVim/
}

warn() {
    color_print "$1" >&2
}

die() {
    warn "$1"
    exit 1
}

require() {
    color_print "Checking if git exists..."
    which git || die "No git is found in your system!"
    color_print "Checking if ctags exists..."
    which ctags || warn "No ctags is found in your system!"
}

install() {
    color_print "Cloning TinyVim..."
    cd $HOME
    rm -rf $HOME/.TinyVim
    git clone https://github.com/waldonchen/TinyVim.git $HOME/.TinyVim
    if [ ! -d $HOME/.vim ]; then mkdir $HOME/.vim; fi
    ln -s $HOME/.TinyVim/vimrc $HOME/.vim/vimrc
    ln -s $HOME/.TinyVim/config $HOME/.vim/config
    ln -s $HOME/.TinyVim/script $HOME/.vim/script
    color_print "Installing vim-plug"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    color_print "Installing colortheme..."
    git clone https://github.com/gruvbox-community/gruvbox.git \
        $HOME/.vim/plugged/gruvbox
    color_print "Installing plugins using vim-plug..."
    vim +PlugUpdate +qal
    color_print "TinyVim has been installed. Enjoy it."
}

update() {
    color_print "Updating TinyVim..."
    cd $HOME/.TinyVim
    git pull origin master
    color_print "updating plugins..."
    vim +PlugClean! +PlugUpdate +qal
}

if [ $# -ne 1 ]; then
    help
fi

while getopts ":icn" opts; do
    case $opts in
        i)
            logo
            install
            ;;
        c)
            logo
            compress
            ;;
        n)
            logo
            update
            ;;
        :)
            help;;
        ?)
            help;;
    esac
done

#!/bin/sh

DOT_DIR="$HOME/dotfiles"
DOT_FILES=".screenrc .tmux.conf .emacs.el .latexmkrc"
case $1 in
    install)
        for file in $DOT_FILES
        do
            ln -s $DOT_DIR/$file $HOME/$file
        done

        if [ ! -e $HOME/.emacs.d ]
        then
            mkdir $HOME/.emacs.d
        fi

        # append alias/env files to .bashrc
        BASHRC=~/.bashrc
        sed -i -e "/^# begin dotfiles\/setup.sh/,/^# end dotfiles\/setup.sh/d" $BASHRC
        echo "# begin dotfiles/setup.sh" >> $BASHRC
        echo ". ~/dotfiles/.bashrc_append" >> $BASHRC
        echo "# end dotfiles/setup.sh" >> $BASHRC

        for file in `ls $DOT_DIR/.emacs.d/`
        do
            ln -s $DOT_DIR/.emacs.d/$file $HOME/.emacs.d/$file
        done
        ;;
    clean)
        for file in $DOT_FILES
        do
            rm $HOME/$file
        done
        rm -rf $HOME/.emacs.d/
        ;;
    *)
        echo "usage: $0 [install|clean]"
        ;;
esac


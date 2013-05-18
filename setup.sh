#!/bin/sh

DOTDIR="$HOME/dotfiles"
DOT_FILES=".screenrc .tmux.conf .emacs"
for file in $DOT_FILES
do
	ln -s $DOTDIR/$file $HOME/$file
done

if [ ! -e $HOME/.emacs.d ]
then
	mkdir $HOME/.emacs.d
fi

for file in `ls $HOME/dotfiles/.emacs.d/`
do
	ln -s $DOTDIR/.emacs.d/$file $HOME/.emacs.d/$file
done

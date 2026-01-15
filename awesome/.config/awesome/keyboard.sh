#!/bin/sh

setxkbmap -option caps:super
xcape -e 'Super_L=Escape'
xmodmap -e "keycode 9 = Escape asciitilde"


#!/bin/sh

xkbOutput=`setxkbmap -query`
if [[ $xkbOutput == *"neo"* ]]
then
    setxkbmap de
else
    setxkbmap de neo -option
fi

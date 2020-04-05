#!/bin/sh

# make sure we have pulled in and updated any submodules
git submodule init
git submodule update

# directories to create before stowing the dotfiles
folders=(
    /home/tobias/.config
    /home/tobias/.xmonad
)

# run the stow command for the passed in directory ($2) in location $1
stowit() {
    out=$1
    src=$2
    extra_args=${@:3:99}
    echo "stow -t ${out} ${extra_args} -S ${src}"
    stow -t ${out} ${extra_args} -S ${src}
}

unstowit() {
    out=$1
    src=$2
    echo "stow -t ${out} -D ${src}"
    stow -t ${out} -D ${src} 2> /dev/null
}

echo ""
echo "Stowing home"

unstowit /home home

# create folders
for folder in ${folders[@]}; do
    echo "mkdir -p $folder"
    mkdir -p $folder
done

stowit /home home

echo ""
echo "##### ALL DONE"

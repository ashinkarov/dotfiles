#!/bin/bash

# Copyright (c) 2013 Artem Shinkarov <artyom.shinkaroff@gmail.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# This file is based on the ideas of Muchael Stapelberg you can find here:
# http://code.stapelberg.de/git/configfiles

# Creates links for the configurations file in the directory relative to 
# the script to the dot files in $HOME directory.  Generally, every file
# or directory is linked directly, unless there is an entry in MAPPING
# which indicates where the link should be created.

# Examples:
# For single files and directories you create an entry <xconfig> which
# is going to be as ${HOME}/.<xconfig>  -> ./<xconfig>

# For the files that have entries in the mapping, like:
# <xconfig>    <real/path/to/x>
# will be linked like:   ${HOME}/<real/path/to/x>  -> ./<xconfig>

# If the dotfile exists in $HOME and it is not the link, it will be 
# backed-up in the backup directory.  The name of this directory will
# be printed at the end of execution of the script.  Finally, the dotfile
# will be replaced with symbolic link.

# If the dotfile in $HOME is a link, but it doesn't point to the right
# location, the script will notify about it, and leave the dotfile without
# any changes.



# Full path to the directory where the script lives 
dir=$(cd $(dirname "$0") ; pwd -P)

# Create backup directory in /tmp using config.XX template.
backup_dir=$(mktemp --tmpdir -d config.XXXXXXXXXX)

# Flag indicating if backup directory was used.
backup_done=0



# Write a note on stderr
notify() {
    echo "note: $1" > /dev/stderr
}


# Notify where the backup is located or delete the directory.
output_backup_dir_to() {
    if [ $backup_done -eq 1 ]; then
        notify "configuration is backed-up in $backup_dir" > "$1"
    else
        rm -rf "$backup_dir"
    fi
}

# Write an error message on stderr; print the backup directory path
# or delete it; exit with error.
die() {
    echo "error: $1" > /dev/stderr
    output_backup_dir_to /dev/stderr
    exit -1
}


# For every file in the directory local to the script -- 
#   * check if the name needs mapping
#   * check if the dotfile exists and backup it
#   * check if the dotfile is the right link
#   * replace the non-link dotfile with a link
update_links() {
    for file in $(find $dir -maxdepth 1 \
                  ! -regex ".*\(MAPPING\|README.md\|update.sh\|.git\)" \
                  -printf '%P\n') 
    do
        # Check if we need to use a file from mapping.
        path=$(grep "^$file[ \t]*" "$dir/MAPPING" \
              | sed -e "s/^$file[ \t]*\([^ \t\n][^ \t\t\n]*\)/\1/g")
        if [ -z $path ]; then
            path="${HOME}/.$file"
        else
            path="${HOME}/$path"
            d=$(dirname "$path")
            # make sure that the directory exists
            if [ ! -e "$d" ]; then
                mkdir -p "$d" || die "cannot create '$d'"
            fi
        fi

        # if the path is already a link, check that it is pointing
        # to the right file, if not, notify about it.
        if [ -L "$path" ]; then
            pointto=$(readlink $path)
            if [ ! "x$pointto" = "x$dir/$file" ]; then
                notify "note: $path does not point to $dir/$file!"
            fi
        else
            # $path is not a link, copy existing thing into the backup
            # and link $path with $HOME/.$file
            [ -e "$backup_dir" ] || die "backup $backup_dir does not exist"
            
            # if config file exists -- backup the file, changing 
            # its name accordingly.
            if [ -e "$path" ]; then
	        mv "$path" "$backup_dir/$file"
            	notify "note: backing-up $path"
            	backup_done=1
	    fi

            ln -s "$dir/$file" "$path"
        fi
    done

    # output where is the backup
    output_backup_dir_to /dev/stdout
}


update_links

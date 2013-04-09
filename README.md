# Configuration files for Linux

Repository where I keep the dotfiles for easier migration across different machines.
I got my inspiration from 
[Michael Stapelberg dotfiles](http://code.stapelberg.de/git/configfiles/)
but I made it much more simple.

In essence a file or a directory `x` in the root of this repository represents
according dotfile or dotdirectory which should live in `${HOME}/.x` and should 
have a symbolic link to `x`.

For more complicated cases I use a `MAPPING` file which indicates that a certain
file/directory `x` should live in `${HOME}/.path/to/x`.  The format in the
`MAPPING` is line-based pairs of `<name>` and `<path>` separated by spaces or
tabs.  Currently the files or directories cannot have spaces, otherwise the
parsing will deliver wrong results.

In order to link the dotfiles automatically I use `update.sh` which 
replaces dotfiles in ${HOME} with an according symbolic link.  It back-ups a file
if it is not a symplink and it checks that the symlink is pointing to the right
file.

I do not want to include the update process into bashrc or zshrc, so the working
path would be to checkout the latest version from the git and run `update.sh`
manually.

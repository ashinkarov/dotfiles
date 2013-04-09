# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.
export SACBASE=${HOME}/src
export SAC2CBASE=$SACBASE/sac2c
export PATH=$PATH:/usr/local/bin:${HOME}/bin:$SAC2CBASE/bin
export PATH=$PATH:/sbin:/usr/sbin

export MOZ_DISABLE_PANGO=1

eval $(perl -I ~/perl5/lib/perl5 -Mlocal::lib)
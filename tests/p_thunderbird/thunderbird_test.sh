#!/bin/sh
# Author: Athmane Madjoudj <athmanem@gmail.com>
# Author: Christoph Galuschka <christoph.galuschka@chello.at>

t_Log "Running $0 - basic thunderbird test."

# Only checking for correct output of '-v'
# with respect to different versions on C5 and C6

if (t_GetPkgRel basesystem | grep -q el6)
then
  VERSION="3.1"
else
  VERSION="2.0"
fi

thunderbird -v | grep "${VERSION}"  >/dev/null 2>&1

# If Versions are not dedsired
#thunderbird -v | grep "Thunderbird" >/dev/null 2>&1
# works on both C5 and C6; please choose prefered way

t_CheckExitStatus $?
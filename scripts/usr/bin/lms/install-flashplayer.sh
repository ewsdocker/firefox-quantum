#!/bin/bash
# =========================================================================
# =========================================================================
#
#	install-flashplayer.sh
#	  Run a library script to install/upgrade the current flashplayer
#
# =========================================================================
#
# @author Jay Wheeler.
# @version 0.0.2
# @copyright © 2018, 2019. EarthWalk Software.
# @license Licensed under the GNU General Public License, GPL-3.0-or-later.
# @package ewsdocker/firefox-quantum
# @subpackage install-flashplayer.sh
#
# =========================================================================
#
#	Copyright © 2018, 2019. EarthWalk Software
#	Licensed under the GNU General Public License, GPL-3.0-or-later.
#
#   This file is part of ewsdocker/firefox-quantum.
#
#   ewsdocker/firefox-quantum is free software: you can redistribute 
#   it and/or modify it under the terms of the GNU General Public License 
#   as published by the Free Software Foundation, either version 3 of the 
#   License, or (at your option) any later version.
#
#   ewsdocker/firefox-quantum is distributed in the hope that it will 
#   be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
#   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with ewsdocker/firefox-quantum.  If not, see 
#   <http://www.gnu.org/licenses/>.
#
# =========================================================================
#
#		Version 0.0.1 - November 28, 2018.
#               0.0.2 - February 27, 2019.
#
# =========================================================================
# =========================================================================

# =========================================================================
#
#   Global variables
#
# =========================================================================

declare status=0
declare flashTemp="/flashtemp"
declare startDir

# =========================================================================
#
#   External libraries - must be loaded prior to calling subroutines
#
# =========================================================================

. /usr/local/lib/lms/lmsconDisplay.sh
. /usr/local/lib/lms/lmsInstallFlash.sh

# =========================================================================
#
#	Start application here
#
# =========================================================================

lmscli_optQuiet=${LMSOPT_QUIET}

lmsconDisplay ""
lmsconDisplay "Installing FlashPlayer ${flashplayerName}."
lmsconDisplay ""

startDir="${PWD}"

mkdir ${flashTemp}
cd ${flashTemp}

installFlash "${flashplayerFolder}" "${flashplayerModule}" "${flashplayerName}" "${flashplayerMaster}"
status=$?

lmsconDisplay ""

case ${status} in

	0)  lmsconDisplay "Flash player ${flashplayerName} was successfully installed."
	   	;;

	1)  lmsconDisplay "Missing required parameter."
	    ;;

	2)	lmsconDisplay "Cannot get current player version."
		;;

	3)  lmsconDisplay "Unable to read player master URL: ${flashplayerMaster}"
		;;

	4)	lmsconDisplay "Unable to read archive file: ${flashplayerName}"
		;;

	*)  lmsconDisplay "An unknown error (${status}) has occurred."
	    status=5
		;;
esac

# =========================================================================

cd "${startDir}"
rm -R ${flashTemp}

# =========================================================================
#
#	Application exit
#
# =========================================================================

exit ${status}


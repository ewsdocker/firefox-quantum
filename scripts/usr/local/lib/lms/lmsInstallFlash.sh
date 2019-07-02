#!/bin/bash
# =========================================================================
# =========================================================================
#
#	lmsInstallFlash.sh
#	  library script to install/upgrade the Adobe flashplayer
#
#   adapted from
#     Adobe Flash Player installer/updater for Mozilla Firefox. 
#     Please visit the project's website at: 
#       https://github.com/cybernova/fireflashupdate
#
#     Licensed under the GNU General Public License, GPL-3.0-or-later.
#     Copyright (C) 2018 Andrea Dari (andreadari@protonmail.com)                                    
#
# =========================================================================
#
# @author Jay Wheeler.
# @version 0.0.1
# @copyright © 2018. EarthWalk Software.
# @license Licensed under the GNU General Public License, GPL-3.0-or-later.
# @package ewsdocker/firefox-quantum
# @subpackage lmsInstallFlash.sh
#
# =========================================================================
#
#	Copyright © 2018. EarthWalk Software
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
#		Version 0.0.1 - 2018-11-28.
#
# =========================================================================
# =========================================================================

# =========================================================================
#
#   Global variables
#
# =========================================================================

declare flashplayerName="flash_player_npapi_linux.x86_64.tar.gz"
declare flashplayerMaster="https://fpdownload.macromedia.com/pub/flashplayer/masterversion/masterversion.xml"

declare flashplayerModule="libflashplayer.so"
declare flashplayerFolder="${HOME}/.mozilla/plugins"

# =========================================================================
#
#   installFlash
#
#   Enter:
#       flashDir = Firefox flash installation directory
#       flashModule = Firefox flash module name
#       playerName = Flash player package name
#       playerMaster = URL to the masterversion xml file
#   Exit:
#       0 = no error
#       1 = missing parameter(s)
#       2 = an unknown version of Flashplayer is currently installed
#       3 = unable to download the Flashplayer from Adobe
#       4 = broken tarball
#
# =========================================================================
function installFlash()
{
    local flashDir="${1}"
    local flashModule=${2}

    local playerName=${3}
    local playerMaster="${4}"
    
	[[ -z "${flashDir}" || -z "${flashModule}" ||-z "${playerName}" || -z "${playerMaster}" ]] && return 1

    local currentVersion
    local playerVersion=$(wget -qO- "${playerMaster}" | grep -m1 "NPAPI_linux version" | cut -d \" -f 2 | tr , .)

    [[ -z ${playerVersion}+dummy ]] && return 2

    [[ -e "${flashDir}" ]] || mkdir -p "${flashDir}"

    [[ -r "${flashDir}/${flashModule}" ]] &&
     {
        currentVersion=$(grep -z 'FlashPlayer_' ${flashDir}/${flashModule} | cut -d _ -f 2-5 | tr _ .)
        [[ "${currentVersion}" == "${playerVersion}" ]] && installAction="Replacing" || installAction="Installing"
		lmsconDisplay "${installAction} version ${currentVersion}"
     }

	lmsconDisplay_Block "https://fpdownload.adobe.com/pub/flashplayer/pdc/${playerVersion}/${playerName}"

    wget "https://fpdownload.adobe.com/pub/flashplayer/pdc/${playerVersion}/${playerName}"
    [[ $? -eq 0 ]] || return 3

    tar -xvf ${playerName}
    [[ $? -eq 0 ]] || return 4
	
	mkdir -p ${flashDir}

	cp "${flashModule}" "${flashDir}"
    cp -r usr/* /usr

    chmod 644 ${flashDir}/${flashModule}
    chown root:root ${flashDir}/${flashModule}

    return 0
}

# =========================================================================

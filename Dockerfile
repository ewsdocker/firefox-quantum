# =========================================================================
# =========================================================================
#
#	Dockerfile
#	  Dockerfile for Firefox Quantum.
#
# =========================================================================
#
# @author Jay Wheeler.
# @version 65.0.2-0
# @copyright © 2017-2019. EarthWalk Software.
# @license Licensed under the GNU General Public License, GPL-3.0-or-later.
# @package firefox-quantum
# @subpackage Dockerfile
#
# =========================================================================
#
#	Copyright © 2017-2019. EarthWalk Software
#	Licensed under the GNU General Public License, GPL-3.0-or-later.
#
#   This file is part of ewsdocker/firefox-quantum.
#
#   ewsdocker/debian-libreoffice is free software: you can redistribute 
#   it and/or modify it under the terms of the GNU General Public License 
#   as published by the Free Software Foundation, either version 3 of the 
#   License, or (at your option) any later version.
#
#   ewsdocker/debian-libreoffice is distributed in the hope that it will 
#   be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
#   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with ewsdocker/debian-libreoffice.  If not, see 
#   <http://www.gnu.org/licenses/>.
#
# =========================================================================
# =========================================================================

ARG LIB_NAME="lms-library"
ARG LIB_VERSION="0.1.2"

#ARG LIB_HOST=http://alpine-nginx-pkgcache
#ARG LIB_INSTALL="1"

# =========================================================================

#ARG BUILD_URL=http://alpine-nginx-pkgcache

ARG BUILD_REGISTRY=""
ARG BUILD_REPO=ewsdocker

ARG BUILD_NAME="firefox-quantum" 
ARG BUILD_VERSION="65.0.0-0"
ARG BUILD_VERS_EXT=""
ARG BUILD_VERS_EXT_MOD=""

ARG BUILD_TEMPLATE="gui"

ARG BUILD_CATEGORIES="Network"
ARG BUILD_DESKTOP="Firefox Quantum"
ARG BUILD_ICON="Firefox-esrSmall.png"

# =========================================================================

ARG OPT_QUIET=0
ARG OPT_TIMEOUT=30

# =========================================================================

ARG FIREFOX_RELEASE="65"
ARG FIREFOX_VER="0.2"

# =========================================================================

ARG FROM_REGISTRY=""
ARG FROM_REPO="ewsdocker"
ARG FROM_NAME="ldc-core"
ARG FROM_VERS="dopenjre"
ARG FROM_EXT="-0.1.0-gtk3-jdk11"

ARG FROM_PARENT="${FROM_REPO}/${FROM_NAME}:${FROM_VERS}${FROM_EXT}"

FROM ${FROM_PARENT}

MAINTAINER Jay Wheeler <ewsdocker@gmail.com>
ENV DEBIAN_FRONTEND noninteractive
 
# =========================================================================
# =========================================================================

# =========================================================================
#
#   Re-declare build-args, but don't change any assignments 
#       (makes the settings available inside the build)
#
# =========================================================================

ARG LIB_NAME
ARG LIB_VERSION

ARG LIB_HOST

ARG LIB_INSTALL

ARG FIREFOX_RELEASE
ARG FIREFOX_VER

ARG BUILD_REGISTRY
ARG BUILD_REPO

ARG BUILD_NAME 
ARG BUILD_VERSION
ARG BUILD_VERS_EXT
ARG BUILD_VERS_EXT_MOD

ARG BUILD_TEMPLATE
ARG BUILD_CATEGORIES
ARG BUILD_DESKTOP
ARG BUILD_ICON

ARG FROM_PARENT

ARG FROM_REGISTRY
ARG FROM_REPO
ARG FROM_NAME
ARG FROM_VERS
ARG FROM_EXT

ARG OPT_QUIET
ARG OPT_TIMEOUT

# =========================================================================
#
# wget http://ftp.mozilla.org/pub/firefox/releases/65.0/linux-x86_64/en-US/firefox-65.0.tar.bz2
# wget http://ftp.mozilla.org/pub/firefox/releases/65.0.1/linux-x86_64/en-US/firefox-65.0.1.tar.bz2
# wget http://ftp.mozilla.org/pub/firefox/releases/65.0.2/linux-x86_64/en-US/firefox-65.0.2.tar.bz2
#
# =========================================================================

ENV FFOX_NAME="Firefox" \
    FFOX_RELEASE="${FIREFOX_RELEASE}" \
    FFOX_VERS="${FIREFOX_VER}"

ENV FFOX_PKG="firefox-${FFOX_RELEASE}.${FFOX_VERS}.tar.bz2" \
    FFOX_HOST=${LIB_HOST:-"http://ftp.mozilla.org/pub/firefox/releases/${FFOX_RELEASE}.${FFOX_VERS}/linux-x86_64/en-US"}

ENV FFOX_URL="${FFOX_HOST}/${FFOX_PKG}"

# =========================================================================

ENV \
    LMSOPT_TIMEOUT=${OPT_TIMEOUT:-"30"} \
    LMSOPT_QUIET=${OPT_QUIET:-"0"} \
    \
    LMS_BASE="/usr/local" \
    LMS_HOME= \
    LMS_CONF= \
    \
    LMSINSTALL_LIB=${LIB_INSTALL:-"0"}  \
    \
    LMS_REGISTRY=${BUILD_REGISTRY} \
    LMS_REPO=${BUILD_REPO} \
    \
    LMS_NAME=${BUILD_NAME} \
    LMS_VERSION=${BUILD_VERSION} \
    LMS_VERS_EXT=${BUILD_VERS_EXT}${BUILD_VERS_EXT_MOD} \
	\
    LMS_TEMPLATE=${BUILD_TEMPLATE:-"run"} \
    LMS_CATEGORIES=${BUILD_CATEGORIES} \
    LMS_DESKTOP=${BUILD_DESKTOP} \
    LMS_ICON=${BUILD_ICON} \
    \
    LMS_FROM="${FROM_REPO}:${FROM_VERS}${FROM_EXT}" \
    LMS_PARENT="${FROM_PARENT}" 

ENV LMS_PACKAGE="${LMS_PARENT}, ${FFOX_NAME} ${FFOX_RELEASE}.${FFOX_VERS}"

ENV LMS_RUN_NAME="${LMS_NAME}-${LMS_VERSION}${LMS_VERS_EXT}" \
    LMS_DOCKER_NAME="${LMS_NAME}:${LMS_VERSION}${LMS_VERS_EXT}" 

ENV LMS_DOCKER="${LMS_REPO}/${LMS_DOCKER_NAME}" 

# =========================================================================
# =========================================================================
#
# https://github.com/ewsdocker/lms-utilities/releases/download/lms-utilities-0.1.2/lms-library-0.1.2.tar.gz
#
# =========================================================================
# =========================================================================

ENV LMSLIB_VERS="${LIB_VERSION}" 

ENV LMSLIB_HOST=${LIB_HOST:-"https://github.com/ewsdocker/lms-utilities/releases/download/lms-library-${LMSLIB_VERS}"} \
    LMSLIB_NAME="lms-library-${LMSLIB_VERS}.tar.gz" 

ENV LMSLIB_URL="${LMSLIB_HOST}/${LMSLIB_NAME}"

# =========================================================================

ENV LMSOPT_QUIET=${OPT_QUIET:-"0"}

# =========================================================================

VOLUME /Downloads
VOLUME /source

# =========================================================================

COPY scripts/. /

# =========================================================================

RUN \
 \
 # =========================================================================
 #
 #   Install support libraries and applications
 #
 # =========================================================================
 \
    apt-get -y update \
 && apt-get -y upgrade \
 && apt-get -y install \
               alsa-utils \
               gvfs-bin \
               libavcodec-extra57 \
               libcanberra0 \
               libevent-2.0-5 \
               libevent-pthreads-2.0-5 \
               libgl1 \
               libnspr4 \
               libnss3 \
               libv4l-0 \
               libx11-protocol-perl \
 && apt-get clean all \
 \
 # =========================================================================
 #
 #   Download the latest Firefox
 #
 # =========================================================================
 \
 && cd /opt \
 && wget ${FFOX_URL} \
 && tar -xvf ${FFOX_PKG} \
 && rm ${FFOX_PKG} \  
 \
 # =========================================================================
 #
 #   Setup firefox to run from cli
 #
 # =========================================================================
 \
 && ln -s /opt/firefox/firefox /usr/bin/firefox \
 && chmod 775 /opt/firefox/firefox \
 \
 # =========================================================================
 #
 #   download and install lms-library
 #     If LMSINSTALL_LIB = 1, install a new copy of the library
 #                       = 0, rely on the upstream version
 #
 # =========================================================================
 \
 && if test "${LMSINSTALL_LIB}" = "1"; then cd / ; wget "${LMSLIB_URL}"; tar -xvf "${LMSLIB_NAME}"; rm "${LMSLIB_NAME}"; fi \
 \
 # =========================================================================
 #
 #   create empty directories (COPY does not create empty folders!)
 #
 # =========================================================================
 \
 && mkdir -p /usr/local/share/applications \
 && mkdir -p /usr/local/bin \
 && mkdir -p /usr/bin/lms \
 \
 # =========================================================================
 #
 #   Setup flashplayer installer 
 #       - must not be added before the container runs for 1st time.
 #
 # =========================================================================
 \
 && ln -s /usr/bin/lms/install-flashplayer.sh /usr/bin/lmsInstallFlash \
 && chmod +x /usr/bin/lms/*.sh \
 \
 # =========================================================================
 #
 #   Register Firefox
 #
 # =========================================================================
 \
 && printf "${LMS_DOCKER} (${LMS_PACKAGE}), %s @ %s\n" `date '+%Y-%m-%d'` `date '+%H:%M:%S'` >> /etc/ewsdocker-builds.txt 

# =========================================================================

ENTRYPOINT ["/my_init", "--quiet"]
CMD ["firefox"]

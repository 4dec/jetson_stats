#!/bin/bash
# Copyright (C) 2018, Raffaello Bonghi <raffaello@rnext.it>
# All rights reserved
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright 
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of the copyright holder nor the names of its 
#    contributors may be used to endorse or promote products derived 
#    from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, 
# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

JETSON_FOLDER="/etc/jetson_easy"
JETSON_BIN_FOLDER="/usr/local/bin"

if [ -d "$JETSON_FOLDER" ]; then
    # remove folder
    tput setaf 1
    echo "ERROR Folder $JETSON_FOLDER exist"
    tput sgr0
    exit 0
else
    echo "Installing jetson_easy"
    # Copy folder
    echo "Copy $JETSON_FOLDER"
    sudo mkdir $JETSON_FOLDER
    sudo cp -r * $JETSON_FOLDER
    # Link jetson_release
    echo "Link jetson_release"
    #sudo cp $(pwd)/jetson/jetson_release.sh "$JETSON_BIN_FOLDER/jetson_release"
    sudo ln -s $JETSON_FOLDER/jetson_release.sh $JETSON_BIN_FOLDER/jetson_release

    # Link jetson_swap
    echo "Link jetson_swap"
    #sudo cp $(pwd)/jetson/jetson_release.sh "$JETSON_BIN_FOLDER/jetson_release"
    sudo ln -s $JETSON_FOLDER/jetson_swap.sh $JETSON_BIN_FOLDER/jetson_swap
    
    # Copy the service in /etc/init.d/
    if [ ! -f "/etc/init.d/jetson_performance" ]
    then
        echo "Copy the service in /etc/init.d/"
        sudo cp $JETSON_FOLDER/jetson_performance.sh "/etc/init.d/jetson_performance"
    fi
    # Add symbolic link of jetson_clock
    if [ ! -f $JETSON_FOLDER/jetson_clocks.sh ]
    then
        echo "Link jetson_clock.sh"
        sudo ln -s $HOME/jetson_clocks.sh $JETSON_FOLDER/jetson_clocks.sh
    fi
    # Install the service
    sudo update-rc.d jetson_performance defaults
    # Run the service
    sudo service jetson_performance start
fi

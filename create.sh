#!/usr/bin/env bash

set -e

set_tools() {
    sudo apt-get update && sudo apt-get install -y \
        gcc \
        cmake \
        pkg-config \
        libdbus-1-dev \
        libglib2.0-dev \
    && python3 -m pip install --upgrade pip \
    && sudo apt-get clean \
    && sudo rm -rf /var/lib/apt/lists/*

    pip install -r requirements.txt
}

set_odbc() {
    # if ! [[ "9 10 11 12" == *"$(grep VERSION_ID /etc/os-release | cut -d '"' -f 2 | cut -d '.' -f 1)"* ]];
    # then
    #     echo "Debian $(grep VERSION_ID /etc/os-release | cut -d '"' -f 2 | cut -d '.' -f 1) is not currently supported.";
    #     exit;
    # fi

    # Download the package to configure the Microsoft repo
    curl -sSL -O https://packages.microsoft.com/config/debian/$(grep VERSION_ID /etc/os-release | cut -d '"' -f 2 | cut -d '.' -f 1)/packages-microsoft-prod.deb
    # Install the package
    sudo dpkg -i packages-microsoft-prod.deb
    # Delete the file
    rm packages-microsoft-prod.deb

    sudo apt-get update
    sudo ACCEPT_EULA=Y apt-get install -y msodbcsql18
    # optional: for bcp and sqlcmd
    sudo ACCEPT_EULA=Y apt-get install -y mssql-tools18
    echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
    
    # optional: for unixODBC development headers
    sudo apt-get install -y unixodbc-dev
    # optional: kerberos library for debian-slim distributions
    sudo apt-get install -y libgssapi-krb5-2
    source ~/.bashrc
}

# set_tools
set_odbc
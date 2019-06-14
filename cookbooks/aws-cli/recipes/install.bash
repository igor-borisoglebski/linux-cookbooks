#!/bin/bash -e

function installDependencies()
{
    installPackages 'python'
}

function install()
{
    umask '0022'

    # Clean Up

    initializeFolder "${AWS_CLI_INSTALL_FOLDER_PATH}"

    # Install

    local -r tempFolder="$(getTemporaryFolder)"

    unzipRemoteFile "${AWS_CLI_DOWNLOAD_URL}" "${tempFolder}"
    python "${tempFolder}/awscli-bundle/install" -b '/usr/bin/aws' -i "${AWS_CLI_INSTALL_FOLDER_PATH}"
    chown -R "$(whoami):$(whoami)" "${AWS_CLI_INSTALL_FOLDER_PATH}"
    chmod 755 "${AWS_CLI_INSTALL_FOLDER_PATH}/bin/aws"
    rm -f -r "${tempFolder}"

    # Display Version

    displayVersion "$(aws --version 2>&1)"

    umask '0077'
}

function main()
{
    source "$(dirname "${BASH_SOURCE[0]}")/../../../libraries/util.bash"
    source "$(dirname "${BASH_SOURCE[0]}")/../attributes/default.bash"

    checkRequireLinuxSystem
    checkRequireRootUser

    header 'INSTALLING AWS-CLI'

    installDependencies
    install
    installCleanUp
}

main "${@}"
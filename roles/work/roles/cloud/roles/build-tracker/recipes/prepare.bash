#!/bin/bash -e

function main()
{
    # Load Libraries

    local -r appFolderPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    source "${appFolderPath}/../../../../../../../libraries/util.bash"
    source "${appFolderPath}/../../../../../libraries/util.bash"
    source "${appFolderPath}/../attributes/default.bash"

    # Clean Up

    resetLogs

    # Install Apps

    apt-get update -m

    installPackage 'libkrb5-dev' 'krb5-devel'

    "${appFolderPath}/../../../../../../essential.bash" 'build-tracker' 'centos, root, ubuntu'
    "${appFolderPath}/../../../../../../../cookbooks/data-dog/recipes/install.bash"
    "${appFolderPath}/../../../../../../../cookbooks/mongodb/recipes/install.bash"
    "${appFolderPath}/../../../../../../../cookbooks/node-js/recipes/install.bash" "${CLOUD_NODE_JS_VERSION}" "${CLOUD_NODE_JS_INSTALL_FOLDER}"

    # Config SSH and GIT

    addUserSSHKnownHost "$(whoami)" "$(whoami)" "$(cat "${appFolderPath}/../files/known_hosts")"

    configUserGIT "$(whoami)" "${CLOUD_GIT_USER_NAME}" "${CLOUD_GIT_USER_EMAIL}"
    generateUserSSHKey "$(whoami)"

    # Clean Up

    cleanUpSystemFolders
    cleanUpMess

    # Display Notice

    displayNotice "$(whoami)"
}

main "${@}"
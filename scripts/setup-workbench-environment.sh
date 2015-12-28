#!/bin/bash

initializeWorkingDirAndScriptDir() {
    # Set working directory and remove all symbolic links
    workingDir=`pwd -P`

    # Go the script directory
    cd `dirname $0`
    # If the file itself is a symbolic link (ignoring parent directory links), then follow that link recursively
    # Note that scriptDir=`pwd -P` does not do that and cannot cope with a link directly to the file
    scriptFileBasename=`basename $0`
    while [ -L "$scriptFileBasename" ] ; do
        scriptFileBasename=`readlink $scriptFileBasename` # Follow the link
        cd `dirname $scriptFileBasename`
        scriptFileBasename=`basename $scriptFileBasename`
    done
    # Set script directory and remove other symbolic links (parent directory links)
    scriptDir=`pwd -P`
}
initializeWorkingDirAndScriptDir

mkdir "${scriptDir}/../logs"
touch "${scriptDir}/../logs/git-clone-workbench.log"
touch "${scriptDir}/../logs/git-workbench.log"
touch "${scriptDir}/../logs/mvn-workbench.log"

${scriptDir}/git-clone-workbench.sh | tee -a "${scriptDir}/../logs/git-clone-workbench.log"
${scriptDir}/git-workbench.sh status | tee -a "${scriptDir}/../logs/git-workbench.log"
${scriptDir}/mvn-workbench.sh clean install | tee -a "${scriptDir}/../logs/mvn-workbench.log"
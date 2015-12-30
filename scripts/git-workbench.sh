#!/bin/bash

# Runs a git command on all workbench repositories.

source "$(dirname $0)/utils.sh"

initializeWorkingDirAndScriptDir
workbenchRepositoriesDir="$scriptDir/../.."

if [ $# = 0 ] ; then
    echo
    echo "Usage:"
    echo "  $0 [arguments of git]"
    echo "For example:"
    echo "  $0 fetch"
    echo "  $0 pull --rebase"
    echo "  $0 commit -m\"JIRAKEY-1 Fix typo\""
    echo
    exit 1
fi

startDateTime=`date +%s`

cd "$workbenchRepositoriesDir"

for repository in `cat "${scriptDir}/repository-list.txt"` ; do
    echo
    if [ ! -d "$workbenchRepositoriesDir/$repository" ]; then
        echo "==============================================================================="
        echo "Missing Repository: $repository. SKIPPING!"
        echo "==============================================================================="
    else
        echo "==============================================================================="
        echo "Repository: $repository"
        echo "==============================================================================="
        cd $repository

        git "$@"

        returnCode=$?
        cd ..
        if [ $returnCode != 0 ] ; then
            echo -n "Error executing command for repository ${repository}. Should I continue? (Hit control-c to stop or enter to continue): "
            read ok
        fi
    fi
done

endDateTime=`date +%s`
spentSeconds=`expr $endDateTime - $startDateTime`

echo
echo "Total time: ${spentSeconds}s"
#!/bin/bash

# Run a mvn command on all workbench repositories.

source "$(dirname $0)/utils.sh"

initializeWorkingDirAndScriptDir
workbenchRepositoriesDir="$scriptDir/../.."

if [ $# = 0 ] ; then
    echo
    echo "Usage:"
    echo "  $0 [arguments of mvn]"
    echo "For example:"
    echo "  $0 --version"
    echo "  $0 -DskipTests clean install"
    echo "  $0 -Dfull clean install"
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

        if [ -a $M3_HOME/bin/mvn ] ; then
            $M3_HOME/bin/mvn "$@"
        else
            mvn "$@"
        fi

        returnCode=$?
        cd ..
        if [ $returnCode != 0 ] ; then
            exit $returnCode
        fi
    fi
done

endDateTime=`date +%s`
spentSeconds=`expr $endDateTime - $startDateTime`

echo
echo "Total time: ${spentSeconds}s"
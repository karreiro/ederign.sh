#!/bin/bash

# Run a mvn command on all projects that were passed as parameters.

source "$(dirname $0)/utils.sh"

initializeWorkingDirAndScriptDir
workbenchRepositoriesDir="$scriptDir/../.."

if [ $# = 0 ] ; then
    echo
    echo "Usage:"
    echo "  $0 [projects]"
    echo "For example:"
    echo "  $0 uberfire"
    echo "  $0 uberfire uberfire-extensions"
    echo "  $0 kie-wb-common kie-wb-distributions"
    echo
    exit 1
fi

startDateTime=`date +%s`

cd "$workbenchRepositoriesDir"

for repository in "$@" ; do
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
            $M3_HOME/bin/mvn clean install -DskipTests=true -Dgwt.compiler.skip=true
        else
            mvn clean install -DskipTests=true -Dgwt.compiler.skip=true
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
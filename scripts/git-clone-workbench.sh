#!/bin/bash

# Git clone the forks to workbench repositories

source "$(dirname $0)/utils.sh"

initializeWorkingDirAndScriptDir
workbenchRepositoriesDir="$scriptDir/../.."

startDateTime=`date +%s`

# The gitUrlPrefix differs between committers and anonymous users. Also it differs on forks.
# Committers on blessed gitUrlPrefix="git@github.com:droolsjbpm/"
# Anonymous users on blessed gitUrlPrefix="git://github.com/droolsjbpm/"
cd "${scriptDir}"
droolsjbpmGitUrlPrefix=`git remote -v | grep --regex "^origin.*(fetch)$"`
droolsjbpmGitUrlPrefix=`echo ${droolsjbpmGitUrlPrefix} | sed 's/^origin\s*//g' | sed 's/ederign\.sh.*//g'`

cd "$workbenchRepositoriesDir"

# additinal Git options can be passed simply as params to the script
# example: --depth 1 (creates a shallow clone with that depth)
additionalGitOptions="$@"

for repository in `cat "${scriptDir}/repository-list.txt"` ; do
    echo
    if [ -d $repository ] ; then
        echo "==============================================================================="
        echo "This directory already exists: $repository"
        echo "==============================================================================="
    else
        echo "==============================================================================="
        echo "Repository: $repository"
        echo "==============================================================================="
        gitUrlPrefix=${droolsjbpmGitUrlPrefix}
        if [ "${repository}" == "kie-eap-modules" ]; then
            # prefix is different for kie-eap-modules repo as it is under jboss-integration org. unit
            gitUrlPrefix=`echo ${droolsjbpmGitUrlPrefix} | sed 's/droolsjbpm/jboss\-integration/g'`
        fi
        echo -- prefix ${gitUrlPrefix} --
        echo -- repository ${repository} --
        echo -- ${gitUrlPrefix}${repository}.git -- ${repository} --
        if [ "x${additionalGitOptions}" != "x" ]; then
            echo -- additional Git options: ${additionalGitOptions} --
        fi
        git clone ${additionalGitOptions} ${gitUrlPrefix}${repository}.git ${repository}

        returnCode=$?
        if [ $returnCode != 0 ] ; then
            exit $returnCode
        fi
    fi
done

echo
echo Disk size:

for repository in `cat "${scriptDir}/repository-list.txt"` ; do
    du -sh $repository
done

endDateTime=`date +%s`
spentSeconds=`expr $endDateTime - $startDateTime`

echo
echo "Total time: ${spentSeconds}s"
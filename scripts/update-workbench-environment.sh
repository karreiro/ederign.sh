#!/bin/bash

source "$(dirname $0)/utils.sh"

initializeWorkingDirAndScriptDir

mkdir "${scriptDir}/../logs"
touch "${scriptDir}/../logs/update-workbench-environment.log"

${scriptDir}/git-workbench.sh status | tee -a "${scriptDir}/../logs/update-workbench-environment.log"
${scriptDir}/git-workbench.sh checkout master | tee -a "${scriptDir}/../logs/update-workbench-environment.log"
${scriptDir}/git-workbench.sh fetch upstream | tee -a "${scriptDir}/../logs/update-workbench-environment.log"
${scriptDir}/git-workbench.sh merge upstream/master | tee -a "${scriptDir}/../logs/update-workbench-environment.log"

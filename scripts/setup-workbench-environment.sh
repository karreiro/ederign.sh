#!/bin/bash

source "$(dirname $0)/utils.sh"

initializeWorkingDirAndScriptDir

mkdir "${scriptDir}/../logs"
touch "${scriptDir}/../logs/git-clone-workbench.log"
touch "${scriptDir}/../logs/git-workbench.log"
touch "${scriptDir}/../logs/mvn-workbench.log"

${scriptDir}/git-clone-workbench.sh | tee -a "${scriptDir}/../logs/git-clone-workbench.log"
${scriptDir}/git-workbench.sh status | tee -a "${scriptDir}/../logs/git-workbench.log"
#${scriptDir}/mvn-workbench.sh clean install | tee -a "${scriptDir}/../logs/mvn-workbench.log"
${scriptDir}/mvn-workbench.sh clean install -DskipTests=true -Dgwt.compiler.skip=true | tee -a "${scriptDir}/../logs/mvn-workbench.log"
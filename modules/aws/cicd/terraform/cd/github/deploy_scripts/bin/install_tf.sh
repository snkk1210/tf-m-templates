#!/usr/bin/bash

####################################
# This script is used by CodeBuild #
####################################

set -eux

TFVERSION="1.7.3"

git clone https://github.com/tfutils/tfenv.git $HOME/.tfenv
ln -s $HOME/.tfenv/bin/* /usr/local/bin
tfenv install ${TFVERSION} && tfenv use ${TFVERSION}
terraform version

#!/bin/bash
# simple script to pull the the relevant repos and populate the cache

function cache_warmup() {
  echo "making the cache"
  mkdir -p cache
  clone_or_update https://github.com/civicrm/civicrm-buildkit.git cache/civicrm-buildkit
  echo "warming up cache"
  cache/civicrm-buildkit/bin/civibuild cache-warmup
  echo "done"
}

###############################################################################
## usage: clone_or_update <repo URL> <local path>

function clone_or_update() {
  REPOSRC=$1
  LOCALREPO=$2
  if [ ! -d "$LOCALREPO/.git" ]
  then
    echo "cloning $REPOSRC into $LOCALREPO"
    git clone $REPOSRC $LOCALREPO
  else
    echo "pulling $REPOSRC within $LOCALREPO"
    pushd $LOCALREPO
    git pull $REPOSRC
    popd
  fi
}

###############################################################################

cache_warmup

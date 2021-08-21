#!/usr/bin/env bash
set -ex
git rt
git apply "$(dirname "$(realpath "$0")")"/jitsi.patch
npm_config_package_lock_only= nix shell ~/cfg#{nodejs_latest,gnumake,python2} -c npm i
nix shell ~/cfg#{nodejs_latest,gnumake,python2} -c make compile deploy source-package
scp jitsi-meet.tar.bz2 kwbauson.com:cfg
git rt

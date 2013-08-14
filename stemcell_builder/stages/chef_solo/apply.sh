#!/usr/bin/env bash
#
# Copyright (c) 2009-2012 VMware, Inc.

set -e

base_dir=$(readlink -nf $(dirname $0)/../..)
source $base_dir/lib/prelude_apply.bash

run_in_chroot $chroot "curl -L https://www.opscode.com/chef/install.sh | sudo bash"

run_in_chroot $chroot "chef-solo -v"

# In the bosh-stemcell vagrant VM run:
# sudo chown vagrant:vagrant /mnt
# cd /mnt
# wget http://releases.ubuntu.com/lucid/ubuntu-10.04.4-server-amd64.iso
# cd /bosh
# bundle install
# UBUNTU_ISO=/mnt/ubuntu-10.04.4-server-amd64.iso JOB_NAME='foo' CANDIDATE_BUILD_NUMBER=892 bundle exec rake ci:stemcell:chef_in_chroot
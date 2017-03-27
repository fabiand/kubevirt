#!/bin/bash
set -ex

cluster/vagrant/sync_config.sh

make all DOCKER_TAG=devel

for VM in `vagrant status | grep "running (libvirt)" | cut -d " " -f1`; do
  vagrant rsync $VM # if you do not use NFS
  vagrant ssh $VM -c "cd /vagrant && export DOCKER_TAG=devel && sudo -E hack/build-docker.sh"
done

export KUBECTL="cluster/kubectl.sh --core"

cluster/deploy.sh

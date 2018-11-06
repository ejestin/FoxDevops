Docker
=========

A role to install Docker on an EC2 instance.
Tasks:
  - Remove docker
  - Add-repo https://download.docker.com/linux/centos/docker-ce.repo
  - Install docker-ce-17.03.3.ce-1.el7.x86_64 docker-ce-selinux-17.03.3.ce-1.el7.noarch
  - Systemctl start & enable docker
  - Add user to 'docker' group
  - restart docker service
  - verify if docker is installed

Requirements
------------

EC2 instance with python installed.

Author Information
------------------

Created by Lucas Fauchille for the devops challenge by FoxIntelligence

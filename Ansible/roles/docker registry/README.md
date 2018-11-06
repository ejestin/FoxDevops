Docker Registry
=========

A role which has to be launched on the Docker Swarm Manager.
Create a local registry and push each image to it.

Tasks:
- Create the registry if not already present
- For each image
  - Create the directory on the instance
  - Copy the code in place
  - Build image and get its ID
  - Tag the image previously built
  - Push the image to the registry

Requirements
------------

Docker installed on the machine // Docker role launched on this machine.
Docker Swarm instanciated by the first Manager.

Author Information
------------------

Created by Lucas Fauchille for the devops challenge by FoxIntelligence

# DevOps Engineer - Technical Test - FoxIntelligence

![Work Smarter not Harder](http://greatperformersacademy.com/images/images/Articles_images/10-ways-work-smarter-not-harder.jpg)

This is my revision of Lucas Fauchille's response to the technical test to apply for a *DevOps Engineer* role at [*Foxintelligence*](https://foxintelligence.fr/jobs.html)
It was itself based on [this](https://hackernoon.com/setup-docker-swarm-on-aws-using-ansible-terraform-daa1eabbc27d) written by the author of this test.
He did a way better job than what i would do from scratch so i figured it would be best to improve on his solution (but most of it was really good)
For more info please see the original : [here](https://github.com/Lfaufau/FoxDevops)

## Usage

```shell
terraform init
export TF_VAR_IPADDR=$(curl ipecho.net/plain; echo)
export TF_VAR_KEYNAME="name of a keypair in your aws ec2"
export AWS_ACCESS_KEY_ID="your"
export AWS_SECRET_ACCESS_KEY="own"
export AWS_DEFAULT_REGION="account"
export BACKEND_AWS_ACCESS_KEY_ID="provided by"
export BACKEND_AWS_SECRET_ACCESS_KEY="FoxIntelligence"
terraform plan
terraform apply (insert yes when asked)
cd Ansible
ansible-playbook install.yml
````

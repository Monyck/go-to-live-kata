#!/usr/bin/env bash
source setup.cfg

if [ -f $AWS_KEYPAIR_PATH ]; then
	echo "The keypair already exist. You can specify a different name to create a new keypair"
	echo "or use a keypair that you already own. This choise is NOT automatic for security reason!"
	exit 1
else
	touch $AWS_KEYPAIR_PATH
	aws ec2 create-key-pair --key-name $AWS_KEYPAIR_NAME --query 'KeyMaterial' --output text > $AWS_KEYPAIR_PATH
    chmod 600 $AWS_KEYPAIR_PATH
fi

if [[ $AWS_VPC == 'no' ]]; then
	aws ec2 create-security-group --group-name $AWS_WP_SG --description "Vagrant Test" > /dev/null 2>&1
	aws ec2 authorize-security-group-ingress --group-name $AWS_WP_SG --protocol tcp --port 22 --cidr 93.34.199.182/32 > /dev/null 2>&1
	aws ec2 authorize-security-group-ingress --group-name $AWS_WP_SG --protocol tcp --port 80 --cidr 93.34.199.182/32 > /dev/null 2>&1
fi

if [[ -z $AWS_WP_EI ]]; then
    AWS_WP_EI=$(aws ec2 allocate-address --output text | cut -d$'\t' -f3)
fi
export AWS_WP_EI

# Let's go!
vagrant up --provider=aws

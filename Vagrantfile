# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant on AWS 

Vagrant.require_version '>= 1.8.0'

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu_aws"
  config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "puppet", "/vagrant/puppet", rsync__excludes: ".git", create: true
  config.vm.provider :aws do |aws, override|
    aws.keypair_name = ENV['AWS_KEYPAIR_NAME']
    override.ssh.private_key_path = ENV['AWS_KEYPAIR_PATH']
    override.nfs.functional = false
    aws.instance_type = ENV['AWS_TYPE']
    aws.security_groups = ENV['AWS_WP_SG']
    aws.access_key_id = ENV['AWS_KEY']
    aws.secret_access_key = ENV['AWS_SECRET']
    aws.ami = "ami-f95ef58a"
    aws.region = "eu-west-1"
    override.ssh.username = "ubuntu"
    aws.tags = {
      'Name' => 'Vagrant Kata WP',
     }
    aws.block_device_mapping = [{ 'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => 8 }]
    aws.elastic_ip = ENV['AWS_WP_EI']
  end
     
  config.vm.provision :shell, :path => "puppet/shell/initial_setup.sh"

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.facter = {
      'vhost_name' => ENV['FACT_VHOST'],
      'wp_ver' => ENV['FACT_WP_VER'],
      'wpuser_pw' => ENV['FACT_WP_PW'],
      'root_my_pw' => ENV['FACT_MY_PW'],
      'importdb_file' => ENV['FACT_IMPORT_DB']
    }
    puppet.options = ["--verbose"]
  end
end
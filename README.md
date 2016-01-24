# Go to live! kata

This project goal is to run a single command and to go online with a Wordpress site.

### Prerequisites:
  - [Vagrant, latest version] (currently 1.8.1; Ubuntu 14.04 repo version is too old and not working well with the AWS plugin)
  - [Vagrant AWS plugin]
  - [Awscli], already working (its configuration is beyond the scope of this guide)

> Note: this code creates AWS resources. Charges may apply. Be careful.

### Assumptions

* all infrastructure resources have to be created
* if you own a DNS zone, you can manage it with Route53, but it's out of scope
* I choose default values for some variables (AMI, type, region etc.). They can virtually all be parametrized
* some code is commented - some variables require you to know what you are doing. For any doubt, ask well!
* the Puppet modules obviously have not been written from scratch. I used [Example42 Puppet modules] by my dear friend Alessandro Franceschi
* to demonstrate the functionality of the code, I decided to import a test database (it's an optional feature)

### Setup

Before you start, please take a look at the setup.cfg file and set all variables; they are mandatory.

### Installation

You just have to run the script:

```sh
$ bash run_setup.sh
```

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)


   [Vagrant, latest version]: <https://www.vagrantup.com/downloads.html>
   [Vagrant AWS plugin]: <https://github.com/mitchellh/vagrant-aws>
   [Awscli]: <https://aws.amazon.com/it/cli/>
   [Example42 Puppet modules]: <https://github.com/example42/puppet-modules>

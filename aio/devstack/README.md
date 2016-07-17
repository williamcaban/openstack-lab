LAB CONFIG (WORK IN PROGRESS)
=============================


NOTES
-----

DevStack is a series of scripts used to quickly bring up an OpenStack environment. It is used as a development environment and as the basis for much of the OpenStack project’s functional testing. This should never be use to deploy a production OpenStack implementation.

DevStack Project Documentation
http://docs.openstack.org/developer/devstack/

Details for deploying an OpenStack All-In-One 
http://docs.openstack.org/developer/devstack/guides/single-machine.html

STEPS
-----

Using CentOS 7 (1511) base installation, when using DevStack, an OpenStack deployment compatible with the basic labs should look like this:


1. Disable firewalld and Network Manager

	```bash
	systemctl disable firewalld
	systemctl stop firewalld 
	systemctl disable NetworkManager
	systemctl stop NetworkManager
	```

2. Setup the static IP '/etc/sysconfig/network-scripts/ifcfg-enp0s3' file (or the equivalent in your environment)

	```console

	DEVICE=enp0s3        
	TYPE=Ethernet        
	BOOTPROTO=static     
	IPADDR=192.168.77.25   
	NETMASK=255.255.255.0 
	GATEWAY=192.168.77.1 
	DNS1=8.8.8.8 
	ONBOOT=yes

	```

3. Enable network services and start it. 

	```console

	systemctl enable network
	systemctl start network
	# restart to work around bug with VirtualBox
	systemctl restart network

	```

4. Update packages with the latest patches

	```console

	yum -y update

	```

5. Create a 'stack' user and assign sudo privileges

	```console

	adduser stack
	echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

	```

6. Install GIT and download the DevStack script from upstream project

	```console

	sudo yum install -y git
	git clone https://git.openstack.org/openstack-dev/devstack
	cd devstack

	```

7. Create a 'local.conf' compatible with the lab environment:

	```

	[[local|localrc]]
	FLOATING_RANGE=192.168.77.0/24
	FIXED_RANGE=10.11.12.0/24
	FIXED_NETWORK_SIZE=256
	FLAT_INTERFACE=enp0s3
	ADMIN_PASSWORD=MyLabAdmin
	DATABASE_PASSWORD=c8fed1a0533f4f98
	RABBIT_PASSWORD=c8fed1a0533f4f98
	SERVICE_PASSWORD=c8fed1a0533f4f98

	```
		* NOTE: This will NOT install all the projects required by some exercises. Consider this a work-in-progress.

8. Execute the installation script:

	```console

	./stack.sh

	```


THIS IS FOR LAB!
================

Please, remember this configuration is intended as a personal Lab setup. THIS CONFIGURATIONS ARE **NOT** INTENDED FOR PROOF-OF-CONCEPTS NEITHER THEY REPRESENT A GOOD GOOD PRACTICE DESIGN.


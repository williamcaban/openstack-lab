OPENSTACK AIO USING THE RDO PROJECT
===================================

The RDO Project is an OpenStack community for CentOS/Fedora/RHEL users. Their website is https://www.rdoproject.org/

The All-in-One node installation is base in RDO quickstart tailored to our particular needs and making sure it works the first time. We will be using CentOS7 (1511) for our lab.


DEFAULT LAB CONFIGURATION
=========================

The default lab configuration setting are the following:

```bash

#######################################
# Global Variables (Settings)
#######################################

ADMINPASSWORD="MyLabAdmin"
DEMOPASSWORD=$ADMINPASSWORD

IFDEV=`ip route | grep default | cut -d' ' -f5 `  # Autodetect interface with default route 
YOURIPADDR="192.168.77.25"
YOURNETMASK="255.255.255.0"
YOURGATEWAY="192.168.77.1"
YOURDNS1="8.8.8.8"
YOURHOSTNAME="openstack-aio"
FLOATRANGE="192.168.77.0/24"

# IFDEV="enp0s3" for packstack answer file
# Defaults for Lab Environment
PACKSTACKANSWER="packstack-answers-20160702-demo1.txt"

# Openstack Client CLI (python virtual environment)
OPENSTACKCLIDIR="openstack-cli"

```


CREATING YOUR OPENSTACK AIO
===========================

The 'setup-aio.sh' script is a prescriptive deployment of the OpenStack Mitaka release compatible with the class exercises. It is used to generate the same base OpenStack installation (including credentials and IPs).

1. Download the setup script 'setup-aio.sh' from this repository.

	```console
	curl -O https://gitlab.com/williamcaban/openstack-lab/raw/master/aio/packstack/setup-aio.sh
	```

	Note: If you want to customize the script to match your environment, open the file and edit the corresponding global variables.


2. Execute the setup script to get the installation menu:

	```console

	# ./setup-aio.sh
	WELCOME TO OPENSTACK AIO LABSETUP
	1) Setup Prerequisites
	2) Install OpenStack AIO w/Heat and SSL (selfsign)
	3) Install OpenStack AIO from packstack-answers file
	4) Install OpenStack Client from PIP (using python virtual environment)
	5) Quit
	Pick an option:

	```

3. Start with option #1 to setup the prerequisites at the VM. The steps of this option are:

	Prerequisites:
	- Minimum VM Specs: 1xCPU 4GB RAM 10GB HDD 1 NIC
	- Install CentOS 7 (1511) base with English locale
	- Disable firewalld and NetworkManager
	- Setup a static IP address
	- Enable the 'network' service

		Note: Should you see an error "Failed to execute operation: Access denied" during the execution of the 'disable' command, then your firewalld or NetworkManager service might not be running. Continue with the rest of the commands.

	- Install EPEL repo
	- Update CentOS packages
	- Install Packstack tool

4. Once the prerequisites are completed, proceed with Option #2.
	Note: This step may take over an hour, depending in your bandwidth. During this step the packstack tool will download, install and configure the OpenStack environment using the latest stable RPMs of the particular release.

5. Once completed, select Option #5 to quit the installation script.

TESTING YOUR OPENSTACK AIO
==========================

Testing OpenStack Client
------------------------
During the installation, packstack, will generate resource files. You should see 'keystonerc_admin' in your directory. Source the file to test the OpenStack Client.

```bash

~]# ls -1
keystonerc_admin
keystonerc_demo
packstack-answers-20160716-215713.txt
packstackca
setup-aio.sh

~]# . keystonerc_admin
~(keystone_admin)]# glance image-list
+--------------------------------------+--------+
| ID                                   | Name   |
+--------------------------------------+--------+
| fbd71ab2-aaa6-4b02-b6f5-67406b97062a | cirros |
+--------------------------------------+--------+
~(keystone_admin)]#

~(keystone_admin)]# openstack endpoint list
+----------------------------------+-----------+---------------+---------------+
| ID                               | Region    | Service Name  | Service Type  |
+----------------------------------+-----------+---------------+---------------+
| f3268547842f4de6986b600660ac09ba | RegionOne | keystone      | identity      |
| 8566fa8963eb4e8384d08c121cc6d889 | RegionOne | gnocchi       | metric        |
| 0f6906de794f46c6a74dd59cc342ca3b | RegionOne | novav3        | computev3     |
| 41d4e2f1ad354db68dfbbb53ab0f36c4 | RegionOne | cinder        | volume        |
| 97246fea992f4e40a7b630aff9eba9a0 | RegionOne | nova          | compute       |
| 1ff716c986434c8fbba9642d67f16b48 | RegionOne | neutron       | network       |
| 8637b25745dd495198cb75508c318174 | RegionOne | Image Service | image         |
| dc25aeaf71dc4b94bae6a20f60b0ab77 | RegionOne | ceilometer    | metering      |
| 08d13d7acdbf4d7ea64f2780828c3e78 | RegionOne | cinderv2      | volumev2      |
| d7839823db914284b87e9fda3f56fbb9 | RegionOne | cinderv3      | volumev3      |
| c1888e4baa3f4d9786d9962e9bfa4f6e | RegionOne | heat          | orchestration |
| 2c3c2c19bd584896b8103e1f8ad5f4fa | RegionOne | aodh          | alarming      |
| 557363e46aa94baba741b6990862d208 | RegionOne | swift         | object-store  |
+----------------------------------+-----------+---------------+---------------+
~(keystone_admin)]#

~(keystone_admin)]# openstack endpoint show f3268547842f4de6986b600660ac09ba        # Note: Choose one of the endpoints IDs 
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| adminurl     | http://192.168.77.25:35357/v2.0  |
| enabled      | True                             |
| id           | f3268547842f4de6986b600660ac09ba |
| internalurl  | http://192.168.77.25:5000/v2.0   |
| publicurl    | http://192.168.77.25:5000/v2.0   |
| region       | RegionOne                        |
| service_id   | 37d554b8a8de411fb51034d93bbb33e0 |
| service_name | keystone                         |
| service_type | identity                         |
+--------------+----------------------------------+
~(keystone_admin)]#

```

Testing OpenStack Dashboard
---------------------------

You may access the OpenStack dashboard at https://192.168.77.25/ (or your instance IP)

The default credentials are:

- User Name: admin
- Password: MyLabAdmin

Note: If you modified the configuration and don't remember the credentials, look for the OS_USERNAME and OS_PASSWORD at the 'keystonerc_admin' file.

```console

~(keystone_admin)]# cat keystonerc_admin
unset OS_SERVICE_TOKEN
export OS_USERNAME=admin
export OS_PASSWORD=MyLabAdmin
export OS_AUTH_URL=http://192.168.77.25:5000/v2.0
export PS1='[\u@\h \W(keystone_admin)]\$ '

export OS_TENANT_NAME=admin
export OS_REGION_NAME=RegionOne
~(keystone_admin)]#

```

THIS IS FOR LAB!
================

Please, remember this configuration is intended as a personal Lab setup. THIS CONFIGURATIONS ARE **NOT** INTENDED FOR PROOF-OF-CONCEPTS NEITHER THEY REPRESENT A GOOD PRACTICE DESIGN.



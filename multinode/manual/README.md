====================================
MANUAL LAB CONFIG (WORK IN PROGRESS)
====================================

This lab will guide the student during a manual configuration of the OpenStack Lab environment.

Minimum Specs
-------------

Control Nodes (3x):
- 1x CPU
- 2x GB RAM
- 1x 10GB HDD
- 4x NIC

Compute Nodes (3x):
- 2x CPU
- 2x GB RAM
- 1x 10 GB HDD
- 4x NIC

Storage Nodes (3x):
- 1x CPU
- 2x GB RAM
- 3x 10GB
- 4x NIC


Logical configuration diagram:

```console

	===========+======================= (external/provider network)
	           |
	       +---------+
	       | Control |
	+------|  Nodes  |-+
	|      |   ***   | |-+
	|      +---------+ | |
	|        |   ***   | +============= (API/dashboard network)
	|        +---------+ |
	|          +---+-----+
	|              |
	|              |
	|       ===+===+=================== (data network)
	|          |
	|          |
	|     +----+----+
	+-----| Compute |-+
	|     |  Nodes  | |-+
	|     |  *KVM   | | |
	|     +---------+ | |
	|       +---------+ |
	|        +----+-----+
	|             |
	|       ===+==+==================== (storage network)
	|          |
	|          |
	|     +----+----+
	+-----| Storage |-+
	|     |  Nodes  | |-+
	|     |  *Ceph  | | |
	|     +---------+ | |
	|       +---------+ |
	|        +----+-----+
	|             |
	|       ======+==================== (storage sync network)
    |
    |
    +---------------------------------- (OOB Management)
    |
    |

```

Sample NIC distribution:

| NIC  | Description                       |
|:----:|-----------------------------------|
| eth0 | OOB Management (all nodes)        |
| eth1 | Data (control and compute nodes)  |
| eth2 | API & Dashboard (control nodes)   |
| eth3 | External/Provider (control nodes) |

Required VRRP IPs:

- VIP for External API & Dashboard
- VIP for Internal API & Dashboard



Prerequisites
-------------

1. Disable firewalld and Network Manager

```console

systemctl disable firewalld
systemctl stop firewalld 
systemctl disable NetworkManager
systemctl stop NetworkManager

```

2. Setup the static OOB Management IP for every node. Create the '/etc/sysconfig/network-scripts/ifcfg-enp0s3' file (or the equivalent in your environment)

Note: Replace the '<VARIABLE>' for the correct value.

```console
# OOB Management
DEVICE=enp0s3        
TYPE=Ethernet        
BOOTPROTO=static     
IPADDR=<OOB_IPADDRESS>   
NETMASK=<OBB_NETMASK>
GATEWAY=<OBB_GATEWAY> 
DNS1=<OOB_DNS> 
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
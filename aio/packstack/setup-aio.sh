#!/bin/bash
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

#######################################
# *** DO NOT EDIT BEYOND THIS POINT ***
#######################################

set_static_ip(){
    # Yes! There are better ways to do this. Use your favorite one!
    echo -e "# SETUP STATIC IP \n\
DEVICE=$IFDEV        \n\
TYPE=Ethernet        \n\
BOOTPROTO=static     \n\
IPADDR=$YOURIPADDR   \n\
NETMASK=$YOURNETMASK \n\
GATEWAY=$YOURGATEWAY \n\
DNS1=$YOURDNS1       \n\
ONBOOT=yes " > /etc/sysconfig/network-scripts/ifcfg-$IFDEV

}

set_hostname(){
    echo $YOURHOSTNAME > /etc/hostname
}

test_reachability() {
    if ping -c 2 $YOURGATEWAY &> /dev/null
    then
        echo "Great!! We can ping the target device. Assuming Internet connectivity."
    else
        echo -e "#####\nWARNING!!!!\n We can not ping the default gateway. Make sure your network is working."
        # Will not break because we don't necessarily need to go outside in a lab context.
        # Script will only display a notification.
        sleep 3 ; echo -e "#####\nIGNORING WARNING!!! Script will Continue."
    fi
}

setup_prereq(){
    # Disable Firewall (it may generate error if not present)
    systemctl disable firewalld
    systemctl stop firewalld 
    systemctl disable NetworkManager
    systemctl stop NetworkManager

    set_static_ip
    set_hostname

    systemctl enable network
    systemctl start network
    # restart to work around bug with VirtualBox
    systemctl restart network

    test_reachability

    echo "Installing EPEL and OpenStack Repo"
    yum -y install epel-release centos-release-openstack-mitaka
    yum -y update
    yum -y install openstack-packstack
}

install_aio_from_file(){
    echo "NOTE: THIS INSTALLATION MAY TAKE OVER AN HOUR (It depends on your Internet bandwidth)"
    sleep 3
    packstack --answer-file=$PACKSTACKANSWER
}

install_aio_from_cli(){
    # Enable Heat and SSL
    echo "NOTE: THIS INSTALLATION MAY TAKE OVER AN HOUR (It depends on your Internet bandwidth)"
    sleep 3 ; echo "Starting installation..."
    packstack --allinone --default-password=c8fed1a0533f4f98 \
    --os-heat-install=y \
    --ntp-servers=pool.ntp.org \
    --nagios-install=n \
    --ssl-cacert-selfsign=y \
    --os-horizon-ssl=y \
    --keystone-admin-passwd=$ADMINPASSWORD \
    --keystone-demo-passwd=$DEMOPASSWORD \
    --cinder-volumes-size=10G \
    --os-neutron-l3-ext-bridge=br-ex \
    --os-neutron-ovs-bridge-mappings=extnet:br-ex \
    --os-neutron-ovs-bridge-interfaces=br-ex:$IFDEV \
    --os-neutron-ml2-type-drivers=vxlan \
    --os-neutron-ml2-tenant-network-types=vxlan \
    --os-neutron-ml2-vni-ranges=5000:50000 \
    --provision-demo-floatrange=$FLOATRANGE \
    --provision-tempest-floatrange=$FLOATRANGE
}

create_dir_structure() {
    mkdir -p ${OPENSTACKCLIDIR}/{heat,images,keys}
}

create_virtual_environment() {
    cd ${OPENSTACKCLIDIR}
    virtualenv --no-site-packages .
    source bin/activate
    pip install python-openstackclient
    pip install python-heatclient
    pip install functools32
    pip install funcsigs
}

install_openstal_cli(){
    echo "Sorry! This function is currently disabled. (Work in progress)"

    #This might need dev packages
    #yum -y install python-virtualenv python-pip

    #create_dir_structure
    #create_virtual_environment 
}

menu() {
    title="WELCOME TO OPENSTACK AIO LABSETUP"
    prompt="Pick an option:"
    options=("Setup Prerequisites" \
        "Install OpenStack AIO w/Heat and SSL (selfsign)" \
        "Install OpenStack AIO from packstack-answers file" \
        "Install OpenStack Client from PIP (using python virtual environment)")

    echo $title
    PS3="$prompt "
    select opt in "${options[@]}" "Quit"; do
        case "$REPLY" in
            1 ) echo "Executing $opt"; setup_prereq ;;
            2 ) echo "Executing $opt"; install_aio_from_cli ;;
            3 ) echo "Executing $opt"; install_aio_from_file ;;
            4 ) echo "Executing $opt"; install_openstal_cli ;;

            $(( ${#options[@]}+1 )) ) echo "Goodbye!"; break ;;
            * ) echo "Invalid option. Try again."; continue ;;
        esac
    done
}

# Invoke menu function
menu


#
# END OF FILE
#
ABOUT THIS PROJECT
==================

This repo is intended to be used as part of the lab environments for my OpenStack classes. You are welcomed to try any of these configurations yourself. They should work for anyone interested in setting up an OpenStack lab environment.


The main directory structure is the following:

```console
+
├── README.md                                       # This README file
├── aio                                             # All-in-One -- single node deployment
│   ├── devstack                                    # Included for demo purposes (refer to class material)
│   │   └── README.md
│   └── packstack                                   # AIO configuration using RDO Project
│       └── README.md
└── multinode                                       # Multi nodes deployments
    ├── manual                                      # Manual configuration of OpenStack (using distro RPM)
    │   └── README.md
    └── packstack
        └── README.md                               # Adding compute nodes

```


NOTES
=====

These are prescriptive configurations intendend for lab environment in some of my classes. These configurations may not fit your need.


ABOUT THIS PROJECT
==================

This repo is intended to be used as part of the lab environments for my OpenStack classes. You are welcomed to try any of these configurations yourself. They should work for anyone interested in setting up an OpenStack lab environment.


The main directory structure is the following:

```console
.
├── README.md
├── aio                                             # All-in-One -- single node deployment
│   ├── devstack                                    # Included for demo purposes (refer to class material)
│   │   └── README.md
│   ├── manual                                      # Manual configuration of OpenStack (using distro RPM)
│   │   └── README.md
│   └── packstack                                   # AIO configuration using RDO Project
│       └── README.md
└── multinode
    ├── manual
    │   └── README.md
    └── packstack
        └── README.md

```


NOTES
=====

These are prescriptive configurations intendend for lab environment in some of my classes. These configurations may not fit your need.


# uds-package-metallb

A Zarf Package containing a standalone version of [MetalLB](https://metallb.org/) to act as a standalone load-balancer or be a pre-req to UDS Core.

## Prerequisites

This package requires a Zarf-initialized kubernetes cluster to be installed.  This repo uses UDS to create a K3d cluster and initialize it via a bundle.

## Using

### Deploy

Deploy this package by first determining what IP addresses you are able to use:

```shell
$ ip addr
1: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 12:34:56:78:90:ab brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.10/24 brd 10.0.0.255 scope global noprefixroute
       valid_lft forever preferred_lft forever
    inet6 1234::5678:90ab:cdef:1234/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```

Then deploy the package specifying the ingress IP addresses that you would like to use:

```shell
$ zarf package deploy oci://ghcr.io/defenseunicorns/packages/metallb:<version> \
    --set IP_ADDRESS_POOL=10.0.0.32/27 \
    --confirm
```

Or, in the case of using this package in concert with UDS Core:

```shell
$ zarf package deploy oci://ghcr.io/defenseunicorns/packages/metallb:<version> \
    --set IP_ADDRESS_ADMIN_INGRESSGATEWAY=10.0.0.32 \
    --set IP_ADDRESS_TENANT_INGRESSGATEWAY=10.0.0.33 \
    --set IP_ADDRESS_PASSTHROUGH_INGRESSGATEWAY=10.0.0.34 \
    --confirm
```

> [!NOTE]
>   - This package can be used inside of bundles (see `bundle/`)
>   - The IP addresses used here are placeholders. You can use whatever values you want that work for your environment.
>   - Package versions can be found [here](https://github.com/defenseunicorns/uds-package-metallb/pkgs/container/packages%2Fmetallb)
>   - If you also want a 4th default IPAddressPool you can additionally set the `IP_ADDRESS_POOL` variable too. It should be an IP range, not a single address unlike the other variables which are single address. Ranges can be specified in either CIDR notation or "StartAddress-EndAddress" notation.

## Known Issues

This package is meant as a simple way to get MetalLB working for smaller clusters and doesn't support many of the more advanced options that MetalLB has.

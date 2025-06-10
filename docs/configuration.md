# Configuration

MetalLB in this package is configured through [MetalLB UDS package](https://github.com/uds-packages/metallb/) as well as a UDS configuration chart that supports the following:

## UDS Exemption Optional Component

Since MetalLB needs to be deployed before UDS Core, and it requires some rootful/privileged permissions to function, there is an optional zarf component that contains a UDS Exemption for the speaker pod - `metallb-uds-exemption`.

On initial deployment this component cannot be deployed since the UDS Exemption CRD is not installed yet. However, it is required for every subsequent deployment of MetalLB since without it UDS Core will not allow the speaker pod to schedule.

# Configuration

MetalLB in this package is configured through [MetalLB UDS package](https://github.com/uds-packages/metallb/) as well as a UDS configuration chart that supports the following:

## UDS Exemption Optional Component

Since MetalLB needs to be deployed before UDS Core, and it requires some rootful/privileged permissions to function, there is a zarf component that contains a UDS Exemption for the speaker pod - `metallb-uds-exemption`.

On initial deployment this exemption cannot be deployed since the UDS Exemption CRD is not installed yet. However, once the cluster has the uds-exemption CRD installed, the exemption will be deployed automatically.

Additionally, if users apply the exemption as part of another chart or Zarf package, the exemption in this package can be disabled entirely by setting `exemptionEnabled` to `"false"` in the `exemption` chart.

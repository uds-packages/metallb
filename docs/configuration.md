# Configuration

MetalLB in this package is configured through [MetalLB UDS package](https://github.com/uds-packages/metallb/) as well as a UDS configuration chart that supports the following:

## Test Bundle

The test bundle uses `bundle/bundle.uds.hcl`. Set `CLI_FEATURES=NextMode=true`
for direct bundle commands. The repository tasks configure this automatically.

Set network-specific addresses in `bundle/config.uds.hcl`:

```hcl
variables = {
  ip_address_pool = "172.21.1.240-172.21.1.250"
  ip_address_passthrough_ingressgateway = "172.21.1.239"
}
```

Use addresses available on your cluster's network. Alternatively, set both
`ip_address_admin_ingressgateway` and `ip_address_tenant_ingressgateway` instead of
`ip_address_pool`. The optional `interface` variable selects the nodes' network interface.
The defaults in `bundle/defaults.uds.hcl` are empty strings; supply addresses before deploying.
`bundle/values/metallb.yaml` maps these variables to the package's `addresspools` values.


## Gateway Pool Service Eligibility

The `addresspools.adminIngress` and `addresspools.tenantIngress` IPAddressPools restrict allocation to their corresponding Istio gateway namespace and `app` label by default. Set `namespace` to `null` to allow Services in any namespace, or `matchLabels` to `null` to allow Services with any labels. You can remove either restriction independently or both together.

For example, these package values allow the tenant ingress pool to allocate to Services in any namespace with any labels:

```yaml
addresspools:
  tenantIngress:
    namespace: null
    matchLabels: null
```

## UDS Exemption Optional Component

Since MetalLB needs to be deployed before UDS Core, and it requires some rootful/privileged permissions to function, there is a zarf component that contains a UDS Exemption for the speaker pod - `metallb-uds-exemption`.

On initial deployment before the UDS Exemption CRD exists, the chart omits the exemption resource. Upgrade the exemption chart after UDS Core installs the CRD to create the resource; `uds run dev` performs this step.

Additionally, if users apply the exemption as part of another chart or Zarf package, the exemption in this package can be disabled entirely by setting `exemptionEnabled` to `false` in the `exemption` chart.

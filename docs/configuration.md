# Configuration

MetalLB in this package is configured through [MetalLB UDS package](https://github.com/uds-packages/metallb/) as well as a UDS configuration chart that supports the following:

## Table of Contents

- [Package Signature Verification](#package-signature-verification)
- [Test Bundle](#test-bundle)
- [Gateway Pool Service Eligibility](#gateway-pool-service-eligibility)
- [UDS Exemption Optional Component](#uds-exemption-optional-component)

## Package Signature Verification

See [Verify a Package](../README.md#verify-a-package) in the README for the first signed releases and package source paths. Replace `<version>` and `<flavor>` with your package version and flavor. For signed releases, configure the settings below to avoid signature verification failures during bundle creation.

### CLI Next — `bundle.uds.hcl`

```hcl
package "metallb" {
  source = "oci://ghcr.io/uds-packages/metallb:<version>-<flavor>"

  signature_verification {
    keyless {
      certificate_identity    = "https://github.com/uds-packages/metallb/.github/workflows/release.yaml@refs/heads/main"
      certificate_oidc_issuer = "https://token.actions.githubusercontent.com"
    }
  }
}
```

### Classic — `uds-bundle.yaml`

```yaml
packages:
  - name: metallb
    repository: ghcr.io/uds-packages/metallb
    ref: <version>-<flavor>
    keylessVerification:
      certificateIdentity: https://github.com/uds-packages/metallb/.github/workflows/release.yaml@refs/heads/main
      certificateOIDCIssuer: https://token.actions.githubusercontent.com
```

## Test Bundle

Tasks default to `NEXT_MODE=true` and use [`bundle/bundle.uds.hcl`](../bundle/bundle.uds.hcl).
Set package values in [`metallb.yaml`](../bundle/values/metallb.yaml).

Set network-specific IP addresses and options in
[`bundle/config.uds.hcl`](../bundle/config.uds.hcl).

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

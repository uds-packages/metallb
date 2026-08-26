# UDS Package MetalLB

Details about the MetalLB package and requirements of [badging](https://github.com/defenseunicorns/uds-common/blob/main/docs/uds-packages/requirements/uds-package-requirements.md) that may not yet be met.

<!-- Recommendation is to provide sufficient details for a package maintainer to quickly understand why an integration is or is not implemented, when the implementation is outside the bounds of a normal scenario.-->

<!--
Example: "The Upstream implementation of APP_XYZ does not expose a metrics endpoint, issue [#123](https://upstream.project/issue/123) has been opened to track this feature request."
-->

## Exemption Required for Speaker Pod

Given that MetalLB operates in the host namespace and needs to manipulate network interfaces, it requires elevated privileges. The speaker pod must be exempted from the following policies to allow pod scheduling:

```yaml
- RestrictHostPorts
- DropAllCapabilities
- RestrictHostPorts
- RequireNonRootUser
- DisallowHostNamespaces
- RestrictCapabilities
```

## Validation Webhook Failure Policy

MetalLB's validating admission webhook uses `failurePolicy: Ignore`. The MetalLB chart and this package's IPAddressPool and L2Advertisement resources are deployed together, so a transient period without a ready endpoint for the newly created webhook Service can otherwise reject package installation or upgrade.

When the webhook is available, it continues to validate all matching resources. If it is unavailable, Kubernetes accepts the resource without webhook validation. This is an intentional tradeoff because this package owns its default MetalLB configuration. Administrators who apply MetalLB configuration from separate packages should account for the possibility that a resource can be admitted during a webhook outage.

See https://defense-unicorns.slack.com/archives/C029NJU2S4B/p1787699421554469 and [#151](https://github.com/uds-packages/metallb/issues/151)

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

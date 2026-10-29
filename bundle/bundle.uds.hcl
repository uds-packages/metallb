# Copyright 2026 Defense Unicorns
# SPDX-License-Identifier: AGPL-3.0-or-later OR LicenseRef-Defense-Unicorns-Commercial

uds {
  bundle_api_version = "uds.dev/v1alpha1"
}

metadata {
  name        = "metallb-test"
  description = "A UDS Bundle for MetalLB"
  version     = "dev"
}

package "init" {
  source = "oci://ghcr.io/zarf-dev/packages/init:v0.88.0"

  signature_verification {
    keyless {
      certificate_identity_regexp = "https://github.com/zarf-dev/zarf/.github/workflows/release.yml@refs/tags/v\\d+\\.\\d+.\\d+"
      certificate_oidc_issuer     = "https://token.actions.githubusercontent.com"
    }
  }
}

package "core-crds" {
  source     = "oci://ghcr.io/defenseunicorns/packages/uds/core-crds:1.16.0-upstream"
  depends_on = [package.init]

  signature_verification {
    keyless {
      certificate_identity_regexp = "^https://github\\.com/defenseunicorns/uds-core/\\.github/workflows/publish\\.yaml@refs/tags/v[0-9]+\\.[0-9]+\\.[0-9]+$"
      certificate_oidc_issuer     = "https://token.actions.githubusercontent.com"
    }
  }
}

package "metallb" {
  source       = "../zarf-package-metallb-${sys.arch}-dev.tar.zst"
  depends_on   = [package.core-crds]
  values_files = ["values/metallb.yaml"]

  # The local package under test is unsigned; remote dependencies are verified.
  signature_verification {
    verify = false
  }
}

package "core-base" {
  source              = "oci://ghcr.io/defenseunicorns/packages/uds/core-base:1.16.0-upstream"
  depends_on          = [package.metallb]
  optional_components = ["istio-passthrough-gateway"]

  signature_verification {
    keyless {
      certificate_identity_regexp = "^https://github\\.com/defenseunicorns/uds-core/\\.github/workflows/publish\\.yaml@refs/tags/v[0-9]+\\.[0-9]+\\.[0-9]+$"
      certificate_oidc_issuer     = "https://token.actions.githubusercontent.com"
    }
  }
}

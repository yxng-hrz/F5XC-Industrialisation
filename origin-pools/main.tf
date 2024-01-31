resource "volterra_origin_pool" "origin-pool" {
  port                   = var.f5xc_origin_pool_port
  name                   = var.f5xc_origin_pool_name
  no_tls                 = var.f5xc_origin_pool_no_tls
  namespace              = var.f5xc_namespace
  health_check_port      = var.f5xc_origin_pool_health_check_port != "" ? var.f5xc_origin_pool_health_check_port : null
  endpoint_selection     = var.f5xc_origin_pool_endpoint_selection
  same_as_endpoint_port  = var.f5xc_origin_pool_same_as_endpoint_port
  loadbalancer_algorithm = var.f5xc_origin_pool_loadbalancer_algorithm

  dynamic "healthcheck" {
    for_each = var.f5xc_origin_pool_healthcheck_names
    content {
      name = healthcheck.value
    }
  }

  dynamic "origin_servers" {
    for_each = {for k, v in var.f5xc_origin_pool_origin_servers : k => v if v != null}

    content {
      labels = var.f5xc_origin_pool_labels
      dynamic "public_ip" {
        for_each = contains(keys(origin_servers), "public_ip") ? [1] : []
        content {
          ip = public_ip.value.ip
        }
      }

      dynamic "public_name" {
        for_each = contains(keys(origin_servers), "public_name") ? [1] : []
        content {
          dns_name = public_name.value.dns_name
        }
      }

      dynamic "private_name" {
        for_each = contains(keys(origin_servers), "private_name") ? [1] : []
        content {
          dns_name        = private_name.value.dns_name
          inside_network  = private_name.value.inside_network
          outside_network = private_name.value.outside_network

          dynamic "site_locator" {
            for_each = contains(keys(private_name.value), "site_locator") ? [1] : []
            content {
              dynamic "site" {
                for_each = contains(keys(site_locator.value), "site") ? [1] : []
                content {
                  tenant    = site.value.tenant
                  namespace = site.value.namespace
                  name      = site.value.name
                }
              }
              dynamic "virtual_site" {
                for_each = contains(keys(site_locator.value), "virtual_site") ? [1] : []
                content {
                  tenant    = virtual_site.value.tenant
                  namespace = virtual_site.value.namespace
                  name      = virtual_site.value.name
                }
              }
            }
          }
        }
      }

      dynamic "private_ip" {
        for_each = contains(keys(origin_servers), "private_ip") ? [1] : []
        content {
          ip              = private_ip.value.ip
          inside_network  = private_ip.value.inside_network
          outside_network = private_ip.value.outside_network

          dynamic "site_locator" {
            for_each = contains(keys(private_ip.value), "site_locator") ? [1] : []
            content {

              dynamic "site" {
                for_each = contains(keys(site_locator.value), "site") ? [1] : []
                content {
                  tenant    = site.value.tenant
                  namespace = site.value.namespace
                  name      = site.value.name
                }
              }
              dynamic "virtual_site" {
                for_each = contains(keys(site_locator.value), "virtual_site") ? [1] : []
                content {
                  tenant    = virtual_site.value.tenant
                  namespace = virtual_site.value.namespace
                  name      = virtual_site.value.name
                }
              }
            }
          }
        }
      }
    }
  }

  dynamic "use_tls" {
    for_each = var.f5xc_origin_pool_no_tls == false ? [1] : []
    content {
      skip_server_verification = var.f5xc_origin_pool_tls_skip_server_verification
      disable_sni              = var.f5xc_origin_pool_tls_disable_sni
      sni                      = var.f5xc_origin_pool_tls_disable_sni == false ? var.f5xc_origin_pool_tls_sni : null
      use_host_header_as_sni   = var.f5xc_origin_pool_tls_use_host_header_as_sni
      volterra_trusted_ca      = var.f5xc_origin_pool_tls_volterra_trusted_ca
      tls_config {
        default_security = var.f5xc_origin_pool_tls_default_security
        medium_security  = var.f5xc_origin_pool_tls_medium_security
        low_security     = var.f5xc_origin_pool_tls_low_security
      }
    }
  }
}

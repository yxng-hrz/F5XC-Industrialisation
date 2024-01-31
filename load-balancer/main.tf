resource "volterra_http_loadbalancer" "lb" {
  name                            = var.f5xc_http_lb_name
  namespace                       = var.f5xc_namespace
  labels                          = var.f5xc_labels
  description                     = var.f5xc_http_lb_description
  advertise_on_public_default_vip = var.f5xc_http_lb_advertise_on_public_default_vip
  do_not_advertise                = var.f5xc_http_lb_do_not_advertise
  disable_api_definition          = var.f5xc_http_lb_disable_api_definition
  disable_ip_reputation           = var.f5xc_http_lb_disable_ip_reputation
  disable_rate_limit              = var.f5xc_http_lb_disable_rate_limit
  disable_waf                     = var.f5xc_http_lb_disable_waf
  disable_bot_defense             = var.f5xc_http_lb_disable_bot_defense
  service_policies_from_namespace = var.f5xc_http_lb_service_policies_from_namespace
  no_service_policies             = var.f5xc_http_lb_no_service_policies
  user_id_client_ip               = var.f5xc_http_lb_user_id_client_ip
  no_challenge                    = var.f5xc_http_lb_no_challenge
  domains                         = var.f5xc_http_lb_domains
  round_robin                     = var.f5xc_http_lb_round_robin
  least_active                    = var.f5xc_http_lb_least_active
  random                          = var.f5xc_http_lb_random
  source_ip_stickiness            = var.f5xc_http_lb_source_ip_stickiness
  add_location                    = var.f5xc_http_lb_add_location

  dynamic "advertise_on_public" {
    for_each = var.f5xc_http_lb_advertise_on_public_ip_name != "" && var.f5xc_http_lb_advertise_on_public_default_vip == false ? [1] : []
    content {
      public_ip {
        tenant    = var.f5xc_tenant
        namespace = var.f5xc_namespace
        name      = var.f5xc_http_lb_advertise_on_public_ip_name
      }
    }
  }

  dynamic "api_rate_limit" {
    for_each = var.f5xc_http_lb_disable_rate_limit == false ? [1] : []
    content {
      no_ip_allowed_list = var.f5xc_http_lb_api_rate_limit_no_ip_allowed_list
      dynamic "server_url_rules" {
        for_each = var.f5xc_http_lb_rate_limit_server_url_rules
        content {
          any_domain      = server_url_rules.value.any_domain
          specific_domain = server_url_rules.value.specific_domain
          base_path       = server_url_rules.value.base_path
          inline_rate_limiter {
            threshold           = server_url_rules.value.inline_rate_limiter.threshold
            unit                = server_url_rules.value.inline_rate_limiter.unit
            use_http_lb_user_id = server_url_rules.value.inline_rate_limiter.use_http_lb_user_id
          }
        }
      }
    }
  }

  dynamic "http" {
    for_each = var.f5xc_lb_type == var.f5xc_lb_type_http ? [1] : []
    content {
      dns_volterra_managed = var.f5xc_http_lb_dns_volterra_managed
      port                 = var.f5xc_http_lb_port
    }
  }

  dynamic "https" {
    for_each = var.f5xc_lb_type == var.f5xc_lb_type_https ? [1] : []
    content {
      http_redirect         = var.f5xc_http_lb_http_redirect
      add_hsts              = var.f5xc_http_lb_add_hsts
      port                  = var.f5xc_http_lb_port
      default_header        = {}
      enable_path_normalize = {}
    }
  }

  dynamic "https_auto_cert" {
    for_each = var.f5xc_lb_type == var.f5xc_lb_type_custom_https_auto_cert ? [1] : []
    content {
      http_redirect = var.f5xc_http_lb_auto_cert_http_redirect
      add_hsts      = var.f5xc_http_lb_auto_cert_add_hsts
      port          = var.f5xc_http_lb_auto_cert_http_port
      tls_config {
        default_security = var.f5xc_http_lb_auto_cert_tls_config_high_security
        medium_security  = var.f5xc_http_lb_auto_cert_tls_config_medium_security
        low_security     = var.f5xc_http_lb_auto_cert_tls_config_low_security
      }
      no_mtls               = var.f5xc_http_lb_auto_cert_no_mtls
      default_header        = var.f5xc_http_lb_auto_cert_default_header
      enable_path_normalize = var.f5xc_http_lb_auto_cert_enable_path_normalize
    }
  }

  dynamic "default_route_pools" {
    for_each = var.f5xc_http_lb_default_route_pools
    content {
      pool {
        tenant    = default_route_pools.value.pool.tenant
        namespace = default_route_pools.value.pool.namespace
        name      = default_route_pools.value.pool.name
      }
      weight           = default_route_pools.value.weight
      priority         = default_route_pools.value.priority
      endpoint_subsets = default_route_pools.value.endpoint_subsets
    }
  }
//  dynamic "enable_ddos_detection" {
//    content {
//      enable_auto_mitigation = true
//    }
//  }
}

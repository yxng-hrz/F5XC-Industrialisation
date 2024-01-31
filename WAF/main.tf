
resource "volterra_app_firewall" "waf1" {

  name                     = "ara-acmecorp-waf1"
  // --- Labels = {KeyName = Value}
  labels = { 
    label-name = "value"
    }
    namespace = var.f5_xc_namespace
    description = "Politique WAF 01"
    blocking = true
    detection_settings {
      signature_selection_setting {
        default_attack_type_settings = true
        high_medium_low_accuracy_signatures = true 
        }
        enable_suppression= true
        stage_new_signatures {
          staging_period = 7
          }
        enable_threat_campaigns = true
          default_violation_settings = true
          }
          bot_protection_setting {
            good_bot_action         = "IGNORE"
            malicious_bot_action    = "BLOCK"
            suspicious_bot_action   = "REPORT"
            }
            allow_all_response_codes = true
            default_anonymization  = true
            use_default_blocking_page = true
            }

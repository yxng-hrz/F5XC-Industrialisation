# Sample of Credential file

# Fichier certificat p12
variable "f5_xc_api_p12_file" {
  type    = string  
  default = "./cred/api-creds.p12"
}
        
variable "f5_xc_api_url" {
    type    = string
    default = "https://MYTENANT.console.ves.volterra.io/api"
}
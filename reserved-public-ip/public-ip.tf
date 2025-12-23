#
# reserved-public-ip/public-ip.tf
#

resource "oci_core_public_ip" "ipsec_reserved-public-ip" {    
    compartment_id = var.root_compartment
    display_name = "ipsec_public-ip"
    lifetime = "RESERVED"
}
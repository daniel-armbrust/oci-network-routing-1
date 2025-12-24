#
# reserved-public-ip/public-ip.tf
#

resource "oci_core_public_ip" "reserved-public-ip" {    
    compartment_id = var.root_compartment
    display_name = "reserved-public_public-ip"
    lifetime = "RESERVED"
}
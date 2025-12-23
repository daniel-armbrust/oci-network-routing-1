#
# reserved-public-ip/output.tf
#

output "ipsec_reserved-public-ip_id" {
    value = oci_core_public_ip.ipsec_reserved-public-ip.id
}

output "ipsec_reserved-public-ip" {
    value = oci_core_public_ip.ipsec_reserved-public-ip.ip_address
}
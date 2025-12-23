#
# vcn-fw-interno/output.tf
#

output "subnprv-lan_id" {
    value = oci_core_subnet.subnprv-lan_vcn-fw-interno.id
}

output "subnpub-internet_id" {
    value = oci_core_subnet.subnpub-internet_vcn-fw-interno.id
}

output "drg-attch_id" {
    value = oci_core_drg_attachment.drg-interno-attch_vcn-fw-interno.id
}
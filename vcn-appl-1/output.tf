#
# vcn-appl-1/output.tf
#

output "subnprv-1_id" {
    value = oci_core_subnet.subnprv-1_vcn-appl-1.id
}

output "drg-attch_id" {
    value = oci_core_drg_attachment.drg-interno-attch_vcn-appl-1.id
}
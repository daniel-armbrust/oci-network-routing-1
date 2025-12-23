#
# vcn-fw-interno/vcn.tf
#

resource "oci_core_vcn" "vcn-fw-interno" {
    compartment_id = var.root_compartment
    cidr_blocks = ["${var.vcn_cidr}"]
    display_name = "vcn-fw-interno"
    dns_label = "vcnfwinterno"
}
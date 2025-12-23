#
# vcn-appl-1/vcn.tf
#

resource "oci_core_vcn" "vcn-appl-1" {
    compartment_id = var.root_compartment
    cidr_blocks = ["${var.vcn_cidr}"]
    display_name = "vcn-appl-1"
    dns_label = "vcnappl1"
}
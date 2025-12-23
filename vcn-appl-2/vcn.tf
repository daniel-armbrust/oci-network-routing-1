#
# vcn-appl-2/vcn.tf
#

resource "oci_core_vcn" "vcn-appl-2" {
    compartment_id = var.root_compartment
    cidr_blocks = ["${var.vcn_cidr}"]
    display_name = "vcn-appl-2"
    dns_label = "vcnappl2"
}
#
# vcn-fw-interno/subnet.tf
#

# Sub-rede Privada LAN
resource "oci_core_subnet" "subnprv-lan_vcn-fw-interno" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-fw-interno.id
    dhcp_options_id = oci_core_dhcp_options.dhcp-options_vcn-fw-interno.id
    route_table_id = oci_core_route_table.rt_subnprv-lan_vcn-fw-interno.id
    security_list_ids = [oci_core_security_list.secl-1_subnprv-lan_vcn-fw-interno.id]

    display_name = "fw-interno_subnprv-lan"
    dns_label = "subnprvlan"
    cidr_block = "${var.subnprv_cidr}"
    prohibit_public_ip_on_vnic = true
}

# Sub-rede Publica INTERNET
resource "oci_core_subnet" "subnpub-internet_vcn-fw-interno" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-fw-interno.id
    dhcp_options_id = oci_core_dhcp_options.dhcp-options_vcn-fw-interno.id
    route_table_id = oci_core_route_table.rt_subnpub-internet_vcn-fw-interno.id
    security_list_ids = [oci_core_security_list.secl-1_subnpub-internet_vcn-fw-interno.id]

    display_name = "fw-interno_subnpub-internet"
    dns_label = "subnprvinet"
    cidr_block = "${var.subnpub_cidr}"
    prohibit_public_ip_on_vnic = false
}
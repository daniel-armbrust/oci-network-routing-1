#
# vcn-publica/routetable.tf
#

# Route Table - Sub-rede Publica #1 (subnpub-1)
resource "oci_core_route_table" "rt_subnpub-1_vcn-publica" {   
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-publica.id
    display_name = "rt_subnpub-1"   

    # Internet Gateway
    route_rules {
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"        
        network_entity_id = oci_core_internet_gateway.igw_vcn-publica.id        
    }
}
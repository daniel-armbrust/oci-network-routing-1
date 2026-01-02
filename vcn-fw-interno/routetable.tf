#
# vcn-fw-interno/routetable.tf
#

# Route Table - Sub-rede Privada LAN
resource "oci_core_route_table" "rt_subnprv-appl_vcn-fw-interno" {   
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-fw-interno.id
    display_name = "rt_subnprv-appl"   

    # Service Gateway
    route_rules {
        destination = "all-gru-services-in-oracle-services-network"
        destination_type = "SERVICE_CIDR_BLOCK"        
        network_entity_id = oci_core_service_gateway.sgw_vcn-fw-interno.id        
    }

    # DRG
    route_rules {
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
        network_entity_id = var.drg_id     
    }
}

# VCN Route Table - TO-FIREWALL
resource "oci_core_route_table" "vcn-fw-interno_rt" {   
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-fw-interno.id
    display_name = "vcn-firewall_rt"

    // Rota para o NLB do Firewall Interno
    route_rules {
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"   
        network_entity_id = var.nlb_fw-interno_ip_id
    }
}
#
# drg-interno-remotepeering.tf
#

resource "oci_core_remote_peering_connection" "drg-interno_rpc" {
    compartment_id = var.root_compartment
    drg_id = oci_core_drg.drg-interno.id      
    
    display_name = "rpc_drg-externo"
    peer_region_name = "sa-saopaulo-1"
    peer_id = oci_core_remote_peering_connection.drg-externo_rpc.id
}

# Import Route Distribution
resource "oci_core_drg_route_distribution" "drg-interno_rpc_imp-rt-dst" {
    drg_id = oci_core_drg.drg-interno.id
    distribution_type = "IMPORT"
    display_name = "import-routes_rpc"
}

# DRG Route Table
resource "oci_core_drg_route_table" "drg-interno_rpc_rt" {  
    drg_id = oci_core_drg.drg-interno.id
    display_name = "rpc_rt"
   
    import_drg_route_distribution_id = oci_core_drg_route_distribution.drg-interno_rpc_imp-rt-dst.id
}

# Route Rules para a REDE DE BACKUP
resource "oci_core_drg_route_table_route_rule" "drg-interno_rpc_rt-routerule-1" {
    drg_route_table_id = oci_core_drg_route_table.drg-interno_rpc_rt.id
    
    // REDE DE BACKUP
    destination = "${local.vcn-onpremises_rede-backup-cidr}"
    destination_type = "CIDR_BLOCK"

    next_hop_drg_attachment_id = "${data.oci_core_drg_attachments.drg-interno_rpc-attch.drg_attachments[0].id}"

    depends_on = [
        oci_core_drg_attachment_management.drg-interno_rpc-attch
    ]
}

# Anexa a tabela de roteamento ao Remote Peering.
resource "oci_core_drg_attachment_management" "drg-interno_rpc-attch" {
  compartment_id = var.root_compartment
  drg_id = oci_core_drg.drg-interno.id
  display_name = "rpc_attch"

  attachment_type = "REMOTE_PEERING_CONNECTION"  
  network_id = oci_core_remote_peering_connection.drg-interno_rpc.id
  drg_route_table_id = oci_core_drg_route_table.drg-interno_rpc_rt.id
}
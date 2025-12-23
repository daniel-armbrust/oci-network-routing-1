#
# vcn-appl-1/drg.tf
#

# DRG - Import Route Distribution
resource "oci_core_drg_route_distribution" "drg-interno_vcn-appl-1_imp-rt-dst" {
    drg_id = var.drg_id
    distribution_type = "IMPORT"
    display_name = "import-routes_vcn-appl-1"
}

# DRG - Import Route Distribution Statement #1
resource "oci_core_drg_route_distribution_statement" "drg-interno_vcn-appl-1_imp-rt-dst_stm-1" {
    drg_route_distribution_id = oci_core_drg_route_distribution.drg-interno_vcn-appl-1_imp-rt-dst.id
    
    action = "ACCEPT"

    match_criteria {
        match_type = "DRG_ATTACHMENT_ID" 
        drg_attachment_id = var.vcn-appl-2_drg-attch_id                    
    }

    priority = 1
}

# DRG - Import Route Distribution Statement #3
resource "oci_core_drg_route_distribution_statement" "drg-interno_vcn-appl-1_imp-rt-dst_stm-3" {
    drg_route_distribution_id = oci_core_drg_route_distribution.drg-interno_vcn-appl-1_imp-rt-dst.id
    
    action = "ACCEPT"

    match_criteria {
        match_type = "DRG_ATTACHMENT_TYPE"      
        attachment_type = "REMOTE_PEERING_CONNECTION"         
    }

    priority = 2
}

# DRG Route Table
resource "oci_core_drg_route_table" "drg-interno-rt_vcn-appl-1" {  
    drg_id = var.drg_id
    display_name = "drg-attch-rt_vcn-appl-1"
   
    import_drg_route_distribution_id = oci_core_drg_route_distribution.drg-interno_vcn-appl-1_imp-rt-dst.id
}

# DRG Attachment
resource "oci_core_drg_attachment" "drg-interno-attch_vcn-appl-1" {
    drg_id = var.drg_id
    display_name = "drg-attch_vcn-appl-1"

    network_details {
        id = oci_core_vcn.vcn-appl-1.id
        type = "VCN"                
    }

    drg_route_table_id = oci_core_drg_route_table.drg-interno-rt_vcn-appl-1.id
}
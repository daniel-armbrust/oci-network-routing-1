#
# nlb/output.tf
#

data "oci_core_private_ips" "nlb_fw-interno-1_private-ip" {    
    ip_address = var.nlb_fw-interno_ip  
    subnet_id = var.fw-interno_subnet_id
    ip_state = "AVAILABLE"

    depends_on = [
        oci_network_load_balancer_network_load_balancer.nlb_fw-interno
    ]    
}

data "oci_core_private_ips" "nlb_fw-interno_private-ip" {
    ip_address = var.nlb_fw-interno_ip
    ip_state = "AVAILABLE"
    subnet_id = var.fw-interno_subnet_id
}

output "nlb_fw-interno_private-ip_id" {
    value = data.oci_core_private_ips.nlb_fw-interno_private-ip.private_ips[0].id
}
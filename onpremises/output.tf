#
# onpremises/output.tf
#

data "oci_core_private_ips" "vm-onpremises_ipsec-ip" {    
    ip_address = var.vm-ipsec_ip  
    subnet_id = oci_core_subnet.subnpub-internet_vcn-onpremises.id
    ip_state = "AVAILABLE"

    depends_on = [
        oci_core_instance.vm-ipsec 
    ]    
}
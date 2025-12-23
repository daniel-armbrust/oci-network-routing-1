#
# vm-firewall/fw-interno-1.tf
#

# FW-INTERNO-1
resource "oci_core_instance" "fw-interno-1" {
    compartment_id = var.root_compartment
    availability_domain = var.availability_domain    
    display_name = "fw-interno-1"

    shape = "VM.Standard.A1.Flex" 

    shape_config {
        baseline_ocpu_utilization = "BASELINE_1_1"
        memory_in_gbs = 4
        ocpus = 3
    }

    source_details {
        source_id = var.os_image_id
        source_type = "image"
        boot_volume_size_in_gbs = 100
    }  

    agent_config {
        is_management_disabled = false
        is_monitoring_disabled = false

        plugins_config {
            desired_state = "ENABLED"
            name = "Bastion"
        }
    }

    metadata = {
        ssh_authorized_keys = file("./ssh-keys/ssh-key.pub")
        user_data = base64encode(file("./vm-firewall/scripts/firewall-init.sh"))
    }

    extended_metadata = {       
       "vnic-lan-ip" = "${var.fw-interno-1_lan-ip}"
       "vnic-lan-ip-gw" = "${var.fw-interno-1_lan-ip-gw}"
       "vnic-externo-ip" = "${var.fw-interno-1_externo-ip}" 
       "vnic-externo-ip-gw" = "${var.fw-interno-1_externo-ip-gw}"
       "vnic-internet-ip" = "${var.fw-interno-1_internet-ip}"
       "vnic-internet-ip-gw" = "${var.fw-interno-1_internet-ip-gw}"
       "vcn-appl-1_cidr" =  "${var.vcn-appl-1_cidr}"
       "vcn-appl-2_cidr" = "${var.vcn-appl-2_cidr}"
       "onpremises-cidr" = "${var.onpremises_cidr}"
       "onpremises-rede-app-cidr" = "${var.onpremises_rede-app_cidr}"
       "onpremises-rede-backup_cidr" = "${var.onpremises_rede-backup_cidr}"
       "onpremises-ip-nat" = "${var.onpremises_ip-nat}"
    }

    # VNIC LAN
    create_vnic_details {
        display_name = "fw-interno-1_vnic-lan"
        hostname_label = "fwinterno1lan"
        private_ip = var.fw-interno-1_lan-ip         
        subnet_id = var.subnprv-lan_id
        skip_source_dest_check = true
        assign_public_ip = false
        assign_ipv6ip = false
    }
}

# VNIC VCN-EXTERNO FW-INTERNO-2
resource "oci_core_vnic_attachment" "fw-interno-1_vnic-externo" {  
    display_name = "vnic-externo"
    instance_id = oci_core_instance.fw-interno-1.id
      
    create_vnic_details {    
        display_name = "fw-interno-1_vnic-externo"    
        hostname_label = "fwinterno1ext"
        private_ip = var.fw-interno-1_externo-ip               
        subnet_id = var.subnprv-externo_id 
        skip_source_dest_check = true
        assign_public_ip = false
        assign_ipv6ip = false 
    }    

    depends_on = [
        oci_core_instance.fw-interno-1
    ]   
}

# VNIC INTERNET
resource "oci_core_vnic_attachment" "fw-interno-1_vnic-internet" {  
    display_name = "vnic-internet"
    instance_id = oci_core_instance.fw-interno-1.id
      
    create_vnic_details {    
        display_name = "fw-interno-1_vnic-internet"    
        hostname_label = "fwinterno1inet"
        private_ip = var.fw-interno-1_internet-ip               
        subnet_id = var.subnpub-internet_id
        skip_source_dest_check = true
        assign_public_ip = true
        assign_ipv6ip = false 
    }    

    depends_on = [
        oci_core_instance.fw-interno-1
    ]   
}
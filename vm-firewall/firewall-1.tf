#
# vm-firewall/firewall-1.tf
#

resource "oci_core_instance" "firewall-1" {
    compartment_id = var.root_compartment
    availability_domain = var.availability_domain    
    display_name = "firewall-1"

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
       "vnic-appl-ip" = "${var.firewall-1_appl-ip}"
       "vnic-appl-ip-gw" = "${var.firewall-1_appl-ip-gw}"
       "vnic-externo-ip" = "${var.firewall-1_externo-ip}" 
       "vnic-externo-ip-gw" = "${var.firewall-1_externo-ip-gw}"
       "vnic-internet-ip" = "${var.firewall-1_internet-ip}"
       "vnic-internet-ip-gw" = "${var.firewall-1_internet-ip-gw}"
       "vcn-appl-1_cidr" =  "${var.vcn-appl-1_cidr}"
       "vcn-appl-2_cidr" = "${var.vcn-appl-2_cidr}"
       "onpremises-rede-app-cidr" = "${var.onpremises_rede-app_cidr}"
       "onpremises-rede-backup_cidr" = "${var.onpremises_rede-backup_cidr}"
    }

    # VNIC LAN
    create_vnic_details {
        display_name = "vnic-appl"
        hostname_label = "fw1"
        private_ip = var.firewall-1_appl-ip         
        subnet_id = var.subnprv-appl_id
        skip_source_dest_check = true
        assign_public_ip = false
        assign_ipv6ip = false
    }
}

# VNIC Externa
resource "oci_core_vnic_attachment" "firewall-1_vnic-externo" {  
    display_name = "vnic-externo"
    instance_id = oci_core_instance.firewall-1.id
      
    create_vnic_details {    
        display_name = "vnic-externo"    
        hostname_label = "fw1ext"
        private_ip = var.firewall-1_externo-ip               
        subnet_id = var.subnprv-externo_id 
        skip_source_dest_check = true
        assign_public_ip = false
        assign_ipv6ip = false 
    }    

    depends_on = [
        oci_core_instance.firewall-1
    ]   
}

# VNIC INTERNET
resource "oci_core_vnic_attachment" "firewall-1_vnic-internet" {  
    display_name = "vnic-internet"
    instance_id = oci_core_instance.firewall-1.id
      
    create_vnic_details {    
        display_name = "vnic-internet"    
        hostname_label = "fw1int"
        private_ip = var.firewall-1_internet-ip               
        subnet_id = var.subnpub-internet_id
        skip_source_dest_check = true
        assign_public_ip = true
        assign_ipv6ip = false 
    }    

    depends_on = [
        oci_core_instance.firewall-1
    ]   
}
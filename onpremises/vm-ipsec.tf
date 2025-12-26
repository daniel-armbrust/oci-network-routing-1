#
# onpremises/vm-ipsec.tf
#

resource "oci_core_instance" "vm-ipsec" {
    compartment_id = var.root_compartment
    availability_domain = var.availability_domain    
    display_name = "vm-ipsec"

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
        user_data = base64encode(file("./onpremises/scripts/vm-onpremises-init.sh"))
    }

    extended_metadata = {     
       # OCID do Compartimento
       "compartment-id" = "${var.root_compartment}"
       
       # IP Público Reservado
       "pub-ip-id" = "${var.reserved-public-ip_id}"
       "pub-ip" = "${var.vm-ipsec_public-ip}"
       
       # ASN
       "oracle-asn" = "${var.ipsec-onpremises_asn}"
       "onpremises-asn" = "${var.ipsec_oracle_asn}"

       # Tunnel #1
       "tunnel-1-bgp-ip" = "${var.ipsec_tunnel-1_bgp_ip}"
       "tunnel-1-oci-ip" = "${var.ipsec_tunnel-1_oci_ip}"
       "tunnel-1-oci-pubip" = "${var.ipsec_tunnel-1_oci-public-ip}"
       "tunnel-1-shared-secret" = "${var.ipsec_tunnel-1_shared-secret}"

       # Tunnel #2
       "tunnel-2-bgp-ip" = "${var.ipsec_tunnel-2_bgp_ip}"
       "tunnel-2-oci-ip" = "${var.ipsec_tunnel-2_oci_ip}"
       "tunnel-2-oci-pubip" = "${var.ipsec_tunnel-2_oci-public-ip}"
       "tunnel-2-shared-secret" = "${var.ipsec_tunnel-2_shared-secret}"

       # Internet 
       "internet-cidr" = "${var.vm-ipsec_internet_cidr}"
       "internet-ip" = "${var.vm-ipsec_internet-ip}"
       "internet-ip-gw" = "${var.vm-ipsec_internet-ip-gw}"

       # Rede das Aplicações
       "rede-app-cidr" = "${var.vm-ipsec_rede-app_cidr}"
       "rede-app-ip" = "${var.vm-ipsec_rede-app-ip}"
       "rede-app-ip-gw" = "${var.vm-ipsec_rede-app-ip-gw}"
       
       # Rede de Backup
       "rede-backup-cidr" = "${var.vm-ipsec_rede-backup_cidr}"
       "rede-backup-ip" = "${var.vm-ipsec_rede-backup-ip}"
       "rede-backup-ip-gw" = "${var.vm-ipsec_rede-backup-ip-gw}"
    }

    # VNIC - Internet
    create_vnic_details {
        display_name = "vnic-internet"
        hostname_label = "vnicinet"
        private_ip = var.vm-ipsec_internet-ip       
        subnet_id = oci_core_subnet.subnpub-internet_vcn-onpremises.id
        skip_source_dest_check = true
        assign_public_ip = true
        assign_ipv6ip = false
    }
}

# VNIC - Rede das Aplicações
resource "oci_core_vnic_attachment" "vm-ipsec_vnic-rede-app" {  
    display_name = "vnic-rede-app"
    instance_id = oci_core_instance.vm-ipsec.id
      
    create_vnic_details {    
        display_name = "vnic-rede-app"    
        hostname_label = "vnicapp"
        private_ip = var.vm-ipsec_rede-app-ip               
        subnet_id = oci_core_subnet.subnprv-rede-app_vcn-onpremises.id
        skip_source_dest_check = true
        assign_public_ip = false
        assign_ipv6ip = false 
    }    

    depends_on = [
        oci_core_instance.vm-ipsec
    ]   
}

# VNIC - Rede de Backup
resource "oci_core_vnic_attachment" "vm-ipsec_vnic-rede-backup" {  
    display_name = "vnic-rede-backup"
    instance_id = oci_core_instance.vm-ipsec.id
      
    create_vnic_details {    
        display_name = "vnic-rede-backup"    
        hostname_label = "vnicbackup"
        private_ip = var.vm-ipsec_rede-backup-ip       
        subnet_id = oci_core_subnet.subnprv-rede-backup_vcn-onpremises.id
        skip_source_dest_check = true
        assign_public_ip = false
        assign_ipv6ip = false 
    }    

    depends_on = [
        oci_core_instance.vm-ipsec
    ]   
}
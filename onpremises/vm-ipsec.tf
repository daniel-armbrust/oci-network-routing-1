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
        user_data = base64encode(file("./onpremises/scripts/ipsec-init.sh"))
    }

    # VNIC INTERNET
    create_vnic_details {
        display_name = "vm-ipsec_vnic-internet"
        hostname_label = "vmipsecinet"
        private_ip = var.vm-ipsec_ip       
        subnet_id = oci_core_subnet.subnpub-internet_vcn-onpremises.id
        skip_source_dest_check = true
        assign_public_ip = true
        assign_ipv6ip = false
    }
}
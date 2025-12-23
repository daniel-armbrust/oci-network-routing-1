#
# main.tf
#

# VCN de Aplicação #1 (vcn-appl-1)
module "vcn-appl-1" {
    source = "./vcn-appl-1"
    root_compartment = var.root_compartment

    vcn_cidr = local.vcn-appl-1_cidr
    subnprv_cidr = local.vcn-appl-1_subnprv-1_cidr
    vcn-appl-2_drg-attch_id = module.vcn-appl-2.drg-attch_id
    vcn-fw-interno_drg-attch_id = module.vcn-fw-interno.drg-attch_id
    
    drg_id = oci_core_drg.drg-interno.id
    sgw_all_oci_services = local.gru_all_oci_services

    drg-interno-attch_vcn-fw-interno_id = "${data.oci_core_drg_attachments.drg-interno-attch_vcn-fw-interno.drg_attachments[0].id}"
}

# VCN de Aplicação #2 (vcn-appl-2)
module "vcn-appl-2" {
    source = "./vcn-appl-2"
    root_compartment = var.root_compartment

    vcn_cidr = local.vcn-appl-2_cidr
    subnprv_cidr = local.vcn-appl-2_subnprv-1_cidr
    vcn-appl-1_drg-attch_id = module.vcn-appl-1.drg-attch_id
    vcn-fw-interno_drg-attch_id = module.vcn-fw-interno.drg-attch_id

    drg_id = oci_core_drg.drg-interno.id
    sgw_all_oci_services = local.gru_all_oci_services

    drg-interno-attch_vcn-fw-interno_id = "${data.oci_core_drg_attachments.drg-interno-attch_vcn-fw-interno.drg_attachments[0].id}"  
}

# VCN do Firewall Interno (vcn-fw-interno)
module "vcn-fw-interno" {
    source = "./vcn-fw-interno"
    root_compartment = var.root_compartment

    vcn_cidr = local.vcn-fw-interno_cidr
    subnprv_cidr = local.vcn-fw-interno_subnprv-1_cidr
    subnpub_cidr = local.vcn-fw-interno_subnpub-1_cidr
    vcn-appl-1_drg-attch_id = module.vcn-appl-1.drg-attch_id
    vcn-appl-2_drg-attch_id = module.vcn-appl-2.drg-attch_id
    
    drg_id = oci_core_drg.drg-interno.id
    sgw_all_oci_services = local.gru_all_oci_services

    # OCID do Endereço IP do Network Load Balancer do Firewall Interno.
    nlb_fw-interno_ip_id = module.nlb.nlb_fw-interno_private-ip_id

    # Meu endereço IP Publico.
    meu_ip-publico = local.meu_ip-publico    
}

# VCN do Firewall Externo (vcn-fw-externo)
module "vcn-fw-externo" {
    source = "./vcn-fw-externo"
    root_compartment = var.root_compartment

    vcn_cidr = local.vcn-fw-externo_cidr
    subnprv_cidr = local.vcn-fw-externo_subnprv-1_cidr
    drg_id = oci_core_drg.drg-externo.id
    sgw_all_oci_services = local.gru_all_oci_services
}

# VCN Publica (vcn-publica)
module "vcn-publica" {
    source = "./vcn-publica"
    root_compartment = var.root_compartment

    vcn_cidr = local.vcn-publica_cidr
    subnpub_cidr = local.vcn-publica_subnpub-1_cidr
}

module "vm-firewall" {
    source = "./vm-firewall"
    root_compartment = var.root_compartment    
    availability_domain = local.ads.gru_ad1_name
    os_image_id = local.compute_image_id.gru.ol96-arm

    # VCNs CIDRs.
    vcn-appl-1_cidr = local.vcn-appl-1_cidr
    vcn-appl-2_cidr = local.vcn-appl-2_cidr
    vcn-fw-externo_cidr = local.vcn-fw-externo_cidr

    # OCID das Sub-redes das VCNs INTERNO, EXTERNO e PUBLICA (internet outbound).
    subnprv-lan_id = module.vcn-fw-interno.subnprv-lan_id
    subnprv-externo_id = module.vcn-fw-externo.subnprv-1_id
    subnpub-internet_id = module.vcn-fw-interno.subnpub-internet_id

    # On-premises
    onpremises_cidr = local.vcn-onpremises_cidr
    onpremises_rede-app_cidr = local.vcn-onpremises_subnprv-rede-app_cidr
    onpremises_rede-backup_cidr = local.vcn-onpremises_subnprv-rede-backup_cidr
    onpremises_ip-nat = local.vcn-onpremises_ip-nat

    #---------------------#
    # FIREWALL INTERNO #1 #
    #---------------------#

    # Firewall Interno #1 - IP LAN e IP do Gateway da Sub-rede.
    fw-interno-1_lan-ip = local.fw-interno-1_lan-ip
    fw-interno-1_lan-ip-gw = local.vcn-fw-interno_subnprv-1_ip-gw

    # Firewall Interno #1 - IP EXTERNO e IP do Gateway da Sub-rede.
    fw-interno-1_externo-ip = local.fw-interno-1_externo-ip
    fw-interno-1_externo-ip-gw = local.vcn-fw-externo_subnprv-1_ip-gw

    # Firewall Interno #1 - IP INTERNET e IP do Gateway da Sub-rede.
    fw-interno-1_internet-ip = local.fw-interno-1_internet-ip
    fw-interno-1_internet-ip-gw = local.vcn-publica_subnpub-1_ip-gw    

    #---------------------#
    # FIREWALL INTERNO #2 #
    #---------------------#

    # Firewall Interno #2 - IP LAN e IP do Gateway da Sub-rede.
    fw-interno-2_lan-ip = local.fw-interno-2_lan-ip
    fw-interno-2_lan-ip-gw = local.vcn-fw-interno_subnprv-1_ip-gw

    # Firewall Interno #2 - IP EXTERNO e IP do Gateway da Sub-rede.
    fw-interno-2_externo-ip = local.fw-interno-2_externo-ip
    fw-interno-2_externo-ip-gw = local.vcn-fw-externo_subnprv-1_ip-gw

    # Firewall Interno #2 - IP INTERNET e IP do Gateway da Sub-rede.
    fw-interno-2_internet-ip = local.fw-interno-2_internet-ip
    fw-interno-2_internet-ip-gw = local.vcn-publica_subnpub-1_ip-gw    
}

module "vm-appl" {
    source = "./vm-appl"
    root_compartment = var.root_compartment    
    availability_domain = local.ads.gru_ad1_name
    os_image_id = local.compute_image_id.gru.ol96-arm

    # Endereço IP e Sub-rede ID da VM de Aplicação APPL-1
    appl-1_ip = local.appl-1_ip
    appl-1_subnprv_id = module.vcn-appl-1.subnprv-1_id

    # Endereço IP e Sub-rede ID da VM de Aplicação APPL-2
    appl-2_ip = local.appl-2_ip
    appl-2_subnprv_id = module.vcn-appl-2.subnprv-1_id
}

# Network Load Balancers
module "nlb" {
    source = "./nlb"
    root_compartment = var.root_compartment

    # Endereço IP do Network Load Balancer do Firewall Interno.
    nlb_fw-interno_ip = local.nlb_fw-interno_ip

    # OCID da Sub-rede Privada do Firewall Interno.
    fw-interno_subnet_id = module.vcn-fw-interno.subnprv-lan_id
    
    # Endereço IP LAN do Firewall Interno.
    fw-interno-1_lan-ip = local.fw-interno-1_lan-ip 
    fw-interno-2_lan-ip = local.fw-interno-2_lan-ip
   
    depends_on = [
        module.vm-firewall
    ]
}

# Reserva da Endereço IP Publico
module "reserved-public-ip" {
    source = "./reserved-public-ip"
    root_compartment = var.root_compartment
}

# Reserva da Endereço IP Publico
module "vpn-ipsec" {
    source = "./vpn-ipsec"
    root_compartment = var.root_compartment
    drg_id = oci_core_drg.drg-interno.id

    cpe_ip = module.reserved-public-ip.ipsec_reserved-public-ip
    onpremises_vm-ipsec_ip = local.vm-onpremises_ipsec-ip

    ipsec-onpremises_asn = local.ipsec-onpremises_asn
    ipsec-onpremises_bgp_ip-1 = local.ipsec-onpremises_bgp_ip-1
    ipsec-onpremises_oci_ip-1 = local.ipsec-onpremises_oci_ip-1
    ipsec-onpremises_bgp_ip-2 = local.ipsec-onpremises_bgp_ip-2
    ipsec-onpremises_oci_ip-2 = local.ipsec-onpremises_oci_ip-2
}

# VCN On-Premises
module "onpremises" {
    source = "./onpremises"
    root_compartment = var.root_compartment
    availability_domain = local.ads.gru_ad1_name
    os_image_id = local.compute_image_id.gru.ol96-arm

    vcn_cidr = local.vcn-onpremises_cidr
    subnpub-internet_cidr = local.vcn-onpremises_subnpub-internet-cidr 
    subnprv-rede-app_cidr = local.vcn-onpremises_subnprv-rede-app_cidr
    subnprv-rede-backup_cidr = local.vcn-onpremises_subnprv-rede-backup_cidr
    sgw_all_oci_services = local.gru_all_oci_services

    # VM IPSec
    vm-ipsec_ip = local.vm-onpremises_ipsec-ip
    vm-ipsec_public-ip = module.reserved-public-ip.ipsec_reserved-public-ip
    vm-ipsec_public-ip_id = module.reserved-public-ip.ipsec_reserved-public-ip_id
    
    # Meu endereço IP Publico.
    meu_ip-publico = local.meu_ip-publico    
}
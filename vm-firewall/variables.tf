#
# vm-firewall/variables.tf
#

variable "root_compartment" {
    description = "Compartimento raiz onde os recursos serão criados."
    type = string  
}

variable "availability_domain" {
    description = "Nome do Availability Domain."
    type = string
}

variable "os_image_id" {
    description = "ID da imagem do Sistema Operacional."
    type = string
}

#------#
# VCNs #
#------#

variable "vcn-fw-interno_cidr" {
    description = "VCN-FIREWALL-INTERNO CIDR."
    type = string
}

variable "vcn-fw-externo_cidr" {
    description = "VCN-FIREWALL-INTERNO CIDR."
    type = string
}

variable "vcn-appl-1_cidr" {
    description = "VCN-APPL-1 CIDR."
    type = string
}

variable "vcn-appl-2_cidr" {
    description = "VCN-APPL-2 CIDR."
    type = string
}

#--------------------#
# OCID das Sub-redes #
#--------------------#

variable "subnprv-appl_id" {
    description = "ID da Sub-rede Appl."
    type = string
}

variable "subnprv-externo_id" {
    description = "ID da Sub-rede EXTERNO."
    type = string
}

variable "subnpub-internet_id" {
    description = "ID da Sub-rede INTERNET."
    type = string
}

#-------------#
# FIREWALL #1 #
#-------------#

variable "firewall-1_appl-ip" {
    description = "Endereço IP APPL do Firewall #1."
    type = string
}

variable "firewall-1_appl-ip-gw" {
    description = "Endereço IP do Gateway APPL do Firewall #1."
    type = string
}

variable "firewall-1_externo-ip" {
    description = "Endereço IP EXTERNO do Firewall #1."
    type = string
}

variable "firewall-1_externo-ip-gw" {
    description = "Endereço IP do Gateway EXTERNO do Firewall #1."
    type = string
}

variable "firewall-1_internet-ip" {
    description = "Endereço IP INTERNET do Firewall #1."
    type = string
}

variable "firewall-1_internet-ip-gw" {
    description = "Endereço IP do Gateway de INTERNET do Firewall #1."
    type = string
}

#-------------#
# FIREWALL #2 #
#-------------#

variable "firewall-2_appl-ip" {
    description = "Endereço IP APPL do Firewall #2."
    type = string
}

variable "firewall-2_appl-ip-gw" {
    description = "Endereço IP do Gateway APPL do Firewall #2."
    type = string
}

variable "firewall-2_externo-ip" {
    description = "Endereço IP EXTERNO do Firewall #2."
    type = string
}

variable "firewall-2_externo-ip-gw" {
    description = "Endereço IP do Gateway EXTERNO do Firewall #2."
    type = string
}

variable "firewall-2_internet-ip" {
    description = "Endereço IP INTERNET do Firewall #2."
    type = string
}

variable "firewall-2_internet-ip-gw" {
    description = "Endereço IP do Gateway de INTERNET do Firewall #2."
    type = string
}

#-------------#
# On-Premises #
#-------------#

variable "onpremises_internet_cidr" {
    description = "CIDR da Rede On-premises Internet."
    type = string
}

variable "onpremises_rede-app_cidr" {
    description = "CIDR da Rede On-premises das Aplicações."
    type = string
}

variable "onpremises_rede-backup_cidr" {
    description = "CIDR da Rede On-premises de Backup."
    type = string
}
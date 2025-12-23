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

variable "vcn-appl-1_cidr" {
    description = "VCN-APPL-1 CIDR."
    type = string
}

variable "vcn-appl-2_cidr" {
    description = "VCN-APPL-2 CIDR."
    type = string
}

variable "vcn-fw-externo_cidr" {
    description = "VCN-FW-EXTERNO CIDR."
    type = string
}

#--------------------#
# OCID das Sub-redes #
#--------------------#

variable "subnprv-lan_id" {
    description = "ID da Sub-rede LAN."
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

#---------------------#
# FIREWALL INTERNO #1 #
#---------------------#

variable "fw-interno-1_lan-ip" {
    description = "Endereço IP LAN do Firewall Interno #1."
    type = string
}

variable "fw-interno-1_lan-ip-gw" {
    description = "Endereço IP do Gateway LAN do Firewall Interno #1."
    type = string
}

variable "fw-interno-1_externo-ip" {
    description = "Endereço IP EXTERNO do Firewall Interno #1."
    type = string
}

variable "fw-interno-1_externo-ip-gw" {
    description = "Endereço IP do Gateway EXTERNO do Firewall Interno #1."
    type = string
}

variable "fw-interno-1_internet-ip" {
    description = "Endereço IP INTERNET do Firewall Interno #1."
    type = string
}

variable "fw-interno-1_internet-ip-gw" {
    description = "Endereço IP do Gateway de INTERNET do Firewall Interno #1."
    type = string
}

#---------------------#
# FIREWALL INTERNO #2 #
#---------------------#

variable "fw-interno-2_lan-ip" {
    description = "Endereço IP LAN do Firewall Interno #2."
    type = string
}

variable "fw-interno-2_lan-ip-gw" {
    description = "Endereço IP do Gateway LAN do Firewall Interno #2."
    type = string
}

variable "fw-interno-2_externo-ip" {
    description = "Endereço IP EXTERNO do Firewall Interno #2."
    type = string
}

variable "fw-interno-2_externo-ip-gw" {
    description = "Endereço IP do Gateway EXTERNO do Firewall Interno #2."
    type = string
}

variable "fw-interno-2_internet-ip" {
    description = "Endereço IP INTERNET do Firewall Interno #2."
    type = string
}

variable "fw-interno-2_internet-ip-gw" {
    description = "Endereço IP do Gateway de INTERNET do Firewall Interno #2."
    type = string
}

#-------------#
# On-Premises #
#-------------#

variable "onpremises_cidr" {
    description = "CIDR da Rede On-premises."
    type = string
}

variable "onpremises_rede-app_cidr" {
    description = "IDR da Rede On-premises das Aplicações"
    type = string
}

variable "onpremises_rede-backup_cidr" {
    description = "CIDR da Rede On-premises de Backup."
    type = string
}

variable "onpremises_ip-nat" {
    description = "Endereço IP NAT que vem do On-premises."
    type = string
}
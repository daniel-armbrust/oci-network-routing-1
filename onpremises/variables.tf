#
# onpremises/variables.tf
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

variable "sgw_all_oci_services" {
    description = "All GRU Services In Oracle Services Network."
    type = string
}

variable "vcn_cidr" {
    type = string
}

variable "subnpub-internet_cidr" {
    description = "Sub-rede Publica."
    type = string
}

variable "subnprv-rede-app_cidr" {
    description = "Sub-rede privada das VMs de Aplicação On-premises."
    type = string
}

variable "subnprv-rede-backup_cidr" {
    description = "Sub-rede privada da Rede de Backup On-premises."
    type = string
}

variable "meu_ip-publico" {
    description = "Meu endereço IP Publico."
    type = string
}

variable "vm-ipsec_ip" {
    description = "Endereço IP Privado da VM-IPSEC On-premises."
    type = string
}

variable "vm-ipsec_public-ip" {
    description = "Endereço IP Publico Reservado da VM-IPSEC On-premises."
    type = string
}

variable "vm-ipsec_public-ip_id" {
    description = "OCID do Endereço IP Publico Reservado da VM-IPSEC On-premises."
    type = string
}
#
# vcn-fw-interno/variables.tf
#

variable "root_compartment" {
    description = "Compartimento raiz onde os recursos serão criados."
    type = string  
}

variable "drg_id" {
    description = "OCID do DRG."
    type = string  
}

variable "sgw_all_oci_services" {
    description = "All GRU Services In Oracle Services Network."
    type = string
}

variable "nlb_fw-interno_ip_id" {
    description = "OCID do IP privado do Network Load Balancer."
    type = string
}

variable "meu_ip-publico" {
    description = "Meu endereço IP Público"
    type = string
}

variable "vcn-appl-1_drg-attch_id" {
    type = string
}

variable "vcn-appl-2_drg-attch_id" {
    type = string
}

variable "vcn_cidr" {
    type = string
}

variable "subnprv_cidr" {
    type = string
}

variable "subnpub_cidr" {
    type = string
}
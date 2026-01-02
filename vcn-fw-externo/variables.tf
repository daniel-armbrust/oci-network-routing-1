#
# vcn-fw-externo/variables.tf
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

variable "vcn_cidr" {
    type = string
}

variable "subnprv-externo_cidr" {
    type = string
}

variable "nlb_fw-externo_ip_id" {
    description = "OCID do IP privado do Network Load Balancer."
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
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

variable "subnprv_cidr" {
    type = string
}
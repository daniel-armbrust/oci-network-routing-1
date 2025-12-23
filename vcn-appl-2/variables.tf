#
# vcn-appl-2/variables.tf
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

variable "drg-interno-attch_vcn-fw-interno_id" {
    description = "DRG-INTERNO VCN-FW-INTERNO Attachment ID."
    type = string
}

variable "vcn-appl-1_drg-attch_id" {
    description = "DRG Attachment ID da VCN-APPL-1."
    type = string
}

variable "vcn-fw-interno_drg-attch_id" {
    description = "DRG Attachment ID da VCN-FW-INTERNO."
    type = string
}

variable "vcn_cidr" {
    description = "VCN CIDR."
    type = string
}

variable "subnprv_cidr" {
    description = "Sub-rede Privada CIDR."
    type = string
}
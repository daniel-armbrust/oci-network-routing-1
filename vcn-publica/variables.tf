#
# vcn-publica/variables.tf
#

variable "root_compartment" {
    description = "Compartimento raiz onde os recursos serão criados."
    type = string  
}

variable "vcn_cidr" {
    type = string
}

variable "subnpub_cidr" {
    type = string
}
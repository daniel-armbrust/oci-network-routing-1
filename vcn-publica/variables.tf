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

variable "subnpub-internet_cidr" {
    type = string
}

variable "meu_ip-publico" {
    description = "Meu endereço IP Público"
    type = string
}
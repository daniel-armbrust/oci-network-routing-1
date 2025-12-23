#
# nlb/variables.tf
#

variable "root_compartment" {
    description = "Compartimento raiz onde os recursos serão criados."
    type = string  
}

variable "fw-interno-1_lan-ip" {
    description = "Endereço IP LAN do Firewall Interno #1."
    type = string
}

variable "fw-interno-2_lan-ip" {
    description = "Endereço IP LAN do Firewall Interno #2."
    type = string
}

variable "nlb_fw-interno_ip" {
    description = "Endereço IP do NLB do Firewall Interno."
    type = string
}

variable "fw-interno_subnet_id" {
    description = "ID da Sub-rede do Firewall Interno."
    type = string
}
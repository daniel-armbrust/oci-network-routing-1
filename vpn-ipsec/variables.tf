#
# vpn-ipsec/variables.tf
#

variable "root_compartment" {
    description = "Compartimento raiz onde os recursos serão criados."
    type = string  
}

variable "cpe_ip" {
    description = "Endereço IP Público do CPE."
    type = string  
}

variable "cpe_private-ip" {
    description = "Endereço IP Privado do CPE."
    type = string
}

variable "drg_id" {
    description = "OCID do DRG."
    type = string  
}

#-----#
# ASN #
#-----#

variable "ipsec-onpremises_asn" {
    description = "On-premises BGP ASN."
    type = string
}

variable "ipsec-onpremises_bgp_ip-1" {
    description = "Endereço IP cliente #1."
    type = string
}

variable "ipsec-onpremises_oci_ip-1" {
    description = "Endereço IP OCI #1."
    type = string
}

variable "ipsec-onpremises_bgp_ip-2" {
    description = "Endereço IP cliente #2."
    type = string
}

variable "ipsec-onpremises_oci_ip-2" {
    description = "Endereço IP OCI #2."
    type = string
}
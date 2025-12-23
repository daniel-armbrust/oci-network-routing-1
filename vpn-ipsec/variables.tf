#
# vpn-ipsec/variables.tf
#

variable "root_compartment" {
    description = "Compartimento raiz onde os recursos serão criados."
    type = string  
}

variable "cpe_ip" {
    description = "Endereço IP do CPE."
    type = string  
}

variable "drg_id" {
    description = "OCID do DRG."
    type = string  
}

variable "onpremises_vm-ipsec_ip" {
    description = "Endereço IP Privado da VM On-premises IPSec."
    type = string
}

variable "ipsec-onpremises_asn" {
    description = "BGP ASN."
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
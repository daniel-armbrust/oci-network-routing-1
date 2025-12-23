#
# vpn-ipsec/output.tf
#

data "oci_core_ipsec_connection_tunnels" "onpremises_ipsec_tunnels" {
   ipsec_id = oci_core_ipsec.onpremises_ipsec.id
}
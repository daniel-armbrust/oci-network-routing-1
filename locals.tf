#
# locals.tf
#

locals {    
   # My Public IP Address
   meu_ip-publico = data.external.retora_meu_ip-publico.result.meu_ip-publico
   
   # VCN-APPL-1
   vcn-appl-1_cidr = "10.50.0.0/16"
   vcn-appl-1_subnprv-1_cidr = "10.50.10.0/24"
   appl-1_ip = "10.50.10.10"  # Endereço IP da VM de Aplicação APPL-1
   
   # VCN-APPL-2
   vcn-appl-2_cidr = "10.60.0.0/16"
   vcn-appl-2_subnprv-1_cidr = "10.60.10.0/24"
   appl-2_ip = "10.60.10.10"  # Endereço IP da VM de Aplicação APPL-2

   # VCN-FW-INTERNO
   vcn-fw-interno_cidr = "10.70.0.0/16"
   vcn-fw-interno_subnprv-1_cidr = "10.70.10.0/24"
   vcn-fw-interno_subnprv-1_ip-gw = "10.70.10.1"
   vcn-fw-interno_subnpub-1_cidr = "10.70.20.0/24"
   vcn-fw-interno_subnpub-1_ip-gw = "10.70.20.1"

   # VCN-FW-EXTERNO
   vcn-fw-externo_cidr = "10.80.0.0/16"
   vcn-fw-externo_subnprv-1_cidr = "10.80.30.0/24"
   vcn-fw-externo_subnprv-1_ip-gw = "10.80.30.1"

   # VCN-PUBLICA
   vcn-publica_cidr = "10.90.0.0/16"
   vcn-publica_subnpub-1_cidr = "10.90.20.0/24"
   vcn-publica_subnpub-1_ip-gw = "10.90.20.1"

   # Firewall INTERNO #1 IPs
   fw-interno-1_lan-ip = "10.70.10.20"
   fw-interno-1_internet-ip = "10.70.20.30"
   fw-interno-1_externo-ip = "10.80.30.40"
  
   # Firewall INTERNO #2 IPs
   fw-interno-2_lan-ip  = "10.70.10.21"
   fw-interno-2_internet-ip = "10.70.20.31"
   fw-interno-2_externo-ip = "10.80.30.41"
   
   # Rede On-premises
   vcn-onpremises_cidr = "172.16.0.0/16"
   vcn-onpremises_subnpub-internet-cidr = "172.16.100.0/24"
   vcn-onpremises_subnprv-rede-app_cidr = "172.16.200.0/24"
   vcn-onpremises_subnprv-rede-backup_cidr = "172.16.150.0/24"
   
   # IP NAT On-premises
   vcn-onpremises_ip-nat = "172.16.200.10" 

   # VM On-premises IPSec
   vm-onpremises_ipsec-ip = "172.16.100.10"

   # Site-To-Site VPN
   ipsec-onpremises_asn = "64515"
   ipsec-onpremises_bgp_ip-1 = "192.168.0.1/30"
   ipsec-onpremises_oci_ip-1 = "192.168.0.2/30"
   ipsec-onpremises_bgp_ip-2 = "192.168.0.5/30"
   ipsec-onpremises_oci_ip-2 = "192.168.0.6/30"
   
   # Network Load Balancer do Firewall INTERNO #1 IP
   nlb_fw-interno_ip = "10.70.10.100"

   # Service Gateway
   gru_all_oci_services = lookup(data.oci_core_services.gru_all_oci_services.services[0], "id")
   gru_oci_services_cidr_block = lookup(data.oci_core_services.gru_all_oci_services.services[0], "cidr_block")   
   
   # Region Names
   # See: https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm
   region_names = {
      "gru" = "sa-saopaulo-1"
   }

   # GRU Object Storage Namespace
   objectstorage_ns = data.oci_objectstorage_namespace.objectstorage_ns.namespace

   # Availability Domains
   ads = {
      gru_ad1_id = data.oci_identity_availability_domains.gru_ads.availability_domains[0].id
      gru_ad1_name = data.oci_identity_availability_domains.gru_ads.availability_domains[0].name
   }
 
   # Fault Domains
   fds = {
      gru_fd1_id = data.oci_identity_fault_domains.gru_fds.fault_domains[0].id,
      gru_fd1_name = data.oci_identity_fault_domains.gru_fds.fault_domains[0].name,

      gru_fd2_id = data.oci_identity_fault_domains.gru_fds.fault_domains[1].id,
      gru_fd2_name = data.oci_identity_fault_domains.gru_fds.fault_domains[1].name,

      gru_fd3_id = data.oci_identity_fault_domains.gru_fds.fault_domains[2].id,
      gru_fd3_name = data.oci_identity_fault_domains.gru_fds.fault_domains[2].name          
   }

   #
   # See: https://docs.oracle.com/en-us/iaas/images/
   #
   compute_image_id = {
      "gru" = {
         "ol96-arm" = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaaeiryb62ld5b2vrzqtf53zt5nbuwiv7d4nxuavggkfza5yjhqpfwa"
      }
   }
}
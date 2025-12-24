#!/bin/bash

# https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/libreswan.htm

ipsec_pub_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/ipsec-pub-ip`"

tunnel_1_oci_pubip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-1-oci-pubip`"
tunnel_1_shared_secret="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-1-shared-secret`"

tunnel_2_oci_pubip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-2-oci-pubip`"
tunnel_2_shared_secret="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-2-shared-secret`"

cat <<EOF >/etc/ipsec.d/oci-ipsec.conf
conn oracle-tunnel-1
     left=${ipsec_pub_ip}
     leftid=${ipsec_pub_ip}
     right=${tunnel_1_oci_pubip}
     authby=secret
     leftsubnet=0.0.0.0/0 
     rightsubnet=0.0.0.0/0
     auto=start
     mark=5/0xffffffff # Needs to be unique across all tunnels
     vti-interface=vti1
     vti-routing=no
     ikev2=no # To use IKEv2, change to ikev2=insist
     ike=aes_cbc256-sha2_384;modp1536
     phase2alg=aes_gcm256;modp1536
     encapsulation=yes
     ikelifetime=28800s
     salifetime=3600s
conn oracle-tunnel-2
     left=${ipsec_pub_ip}
     leftid=${ipsec_pub_ip}
     right=${tunnel_2_oci_pubip}
     authby=secret
     leftsubnet=0.0.0.0/0
     rightsubnet=0.0.0.0/0
     auto=start
     mark=6/0xffffffff # Needs to be unique across all tunnels
     vti-interface=vti2
     vti-routing=no
     ikev2=no # To use IKEv2, change to ikev2=insist
     ike=aes_cbc256-sha2_384;modp1536
     phase2alg=aes_gcm256;modp1536
     encapsulation=yes
     ikelifetime=28800s
     salifetime=3600s
EOF

cat <<EOF >/etc/ipsec.d/oci-ipsec.secrets
${ipsec_pub_ip} ${tunnel_1_oci_pubip}: PSK "${tunnel_1_shared_secret}"
${ipsec_pub_ip} ${tunnel_2_oci_pubip}: PSK "${tunnel_2_shared_secret}"
EOF

# Habiltia e inicia o serviço de VPN.
systemctl enable ipsec
systemctl start ipsec

exit 0
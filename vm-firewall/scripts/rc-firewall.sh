#!/bin/bash

# Configuração das interfaces de rede
/usr/bin/oci-network-config configure

# Tabela de Rotas da Internet
if [ -z "`grep internet /etc/iproute2/rt_tables`" ]; then
   echo '500 internet' >> /etc/iproute2/rt_tables
fi

# Tabela de Rotas da Rede Externa
if [ -z "`grep externo /etc/iproute2/rt_tables`" ]; then
   echo '600 externo' >> /etc/iproute2/rt_tables
fi

# VNIC LAN 
vnic_appl_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vnic-appl-ip`"
vnic_appl_ip_gw="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vnic-appl-ip-gw`"
vnic_appl_iface="`ip -o -f inet addr show | grep "$vnic_appl_ip" | awk '{print $2}'`"

# VNIC INTERNET
vnic_internet_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vnic-internet-ip`"
vnic_internet_ip_gw="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vnic-internet-ip-gw`"
vnic_internet_iface="`ip -o -f inet addr show | grep "$vnic_internet_ip" | awk '{print $2}'`"

# VNIC EXTERNO
vnic_externo_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vnic-externo-ip`"
vnic_externo_ip_gw="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vnic-externo-ip-gw`"
vnic_externo_iface="`ip -o -f inet addr show | grep "$vnic_externo_ip" | awk '{print $2}'`"

# VCNs CIDRs
vcn_appl_1_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vcn-appl-1_cidr`"
vcn_appl_2_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vcn-appl-2_cidr`"

# Rede On-Premises
onpremises_internet_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/onpremises-internet-cidr`"
onpremises_rede_app_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/onpremises-rede-app-cidr`"
onpremises_rede_backup_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/onpremises-rede-backup_cidr`"

# Parâmetros do Kernel
echo 1 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding

echo 0 > /proc/sys/net/ipv4/conf/$vnic_appl_iface/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/$vnic_internet_iface/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/$vnic_externo_iface/rp_filter

echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter

#------------#
# Roteamento #
#------------#

# Rota default para a Internet
ip route add default via $vnic_internet_ip_gw dev $vnic_internet_iface table internet

# Rota default para a Rede Externa.
ip route add default via $vnic_externo_ip_gw dev $vnic_externo_iface table externo

# Policy Route das regras "marcadas" com o valor 3000 (Firewall Acessa a Internet).
ip rule add from $vnic_appl_ip fwmark 3000 lookup internet priority 3000

# Policy Route das regras "marcadas" com o valor 3050 (VCNs acessam a Internet).
ip rule add fwmark 3050 table internet

# Policy Route das regras "marcadas" com o valor 3060 (Firewall Acessa a Rede Externa).
ip rule add fwmark 3060 table externo

# Rota para as redes On-Premises.
ip route add $onpremises_internet_cidr via $vnic_externo_ip dev $vnic_externo_iface
ip route add $onpremises_rede_app_cidr via $vnic_externo_ip dev $vnic_externo_iface
ip route add $onpremises_rede_backup_cidr via $vnic_externo_ip dev $vnic_externo_iface

#-----------------#
# Regras IPTables #
#-----------------#

iptables -t filter -F
iptables -t filter -X
iptables -t filter -Z

iptables -t mangle -F
iptables -t mangle -X
iptables -t mangle -Z

iptables -t nat -F
iptables -t nat -X
iptables -t nat -Z

# Evita que o range link-local seja roteado para a Internet
iptables -t mangle -A OUTPUT -o $vnic_appl_iface -s $vnic_appl_ip -d 169.254.0.0/16 -j RETURN

# NAT para a INTERNET
iptables -t nat -A POSTROUTING -o $vnic_internet_iface -j MASQUERADE

# Permite que o firewall tenha acesso à Internet.
iptables -t mangle -A OUTPUT -o $vnic_appl_iface -s $vnic_appl_ip -d 0.0.0.0/0 -j MARK --set-mark 3000
iptables -t mangle -A OUTPUT -o $vnic_appl_iface -s $vnic_appl_ip -d 0.0.0.0/0 -j RETURN

# Permite que o firewall acesse as VCNs de Aplicação.
iptables -t mangle -A OUTPUT -d $vcn_appl_1_cidr -j RETURN
iptables -t mangle -A OUTPUT -d $vcn_appl_2_cidr -j RETURN

# Permite que o firewall acesse as Redes do On-premises.
iptables -t mangle -A OUTPUT -d $onpremises_cidr -j RETURN
iptables -t mangle -A OUTPUT -d $onpremises_cidr_rede_backup -j RETURN

# Permite que as VCNs acessem a Internet.
iptables -t mangle -A PREROUTING -i $vnic_appl_iface -s $vcn_appl_1_cidr -d 0.0.0.0/0 -j MARK --set-mark 3050  
iptables -t mangle -A PREROUTING -i $vnic_appl_iface -s $vcn_appl_1_cidr -d 0.0.0.0/0 -j RETURN
iptables -t mangle -A PREROUTING -i $vnic_appl_iface -s $vcn_appl_2_cidr -d 0.0.0.0/0 -j MARK --set-mark 3050  
iptables -t mangle -A PREROUTING -i $vnic_appl_iface -s $vcn_appl_2_cidr -d 0.0.0.0/0 -j RETURN

exit 0
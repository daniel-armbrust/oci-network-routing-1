#!/bin/bash

compartment_id="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/compartment-id`"
pub_ip_id="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/pub-ip-id`"
pub_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/pub-ip`"

instance_id="`oci compute instance list --compartment-id $compartment_id --all --display-name "vm-ipsec" --lifecycle-state "RUNNING" --raw-output --query 'data[].id' | tr -d '[]" \n'`"
vnic_id="`oci compute instance list-vnics --instance-id $instance_id --query "data[?\"display-name\"=='vnic-internet']" --raw-output | tr -d '[]" \n'`"
vnic_private_ip_id="`oci network private-ip list --all --vnic-id $vnic_id --raw-output | tr -d '[]" \n'`"
vnic_public_ip_id="`oci network public-ip get --private-ip-id $vnic_private_ip_id`"

# Exclui o Endereço IP Público da VNIC primária.
# NOTA: Essa operação é necessária para permitir a adição do Endereço IP Público Reservado à VNIC.
oci network public-ip delete --public-ip-id $vnic_public_ip_id --force

# Atribui o Endereço IP Público Reservado à VNIC primária.
oci network public-ip update --public-ip-id $pub_ip_id -private-ip-id $vnic_private_ip_id --force

exit 0
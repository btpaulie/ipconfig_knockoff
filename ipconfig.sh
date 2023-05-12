#!/bin/bash

interfaces=$(ip -o link show | awk -F': ' '{print $2}')

for interface in $interfaces; do
    echo "Interface: $interface"
    ip -o addr show dev $interface | awk '{print "  IP Address: "$4}'
    ip -o addr show dev $interface | awk '{print "  Subnet Mask: "$6}'
    ip -o route show dev $interface | awk '/default/{print "  Default Gateway: "$3}'
    resolv_conf="/run/systemd/resolve/resolv.conf"
    if [ -f "$resolv_conf" ]; then
        dns_servers=$(grep nameserver "$resolv_conf" | awk '{print $2}')
        echo "  DNS Servers:"
        for server in $dns_servers; do
            echo "    $server"
        done
    fi
    echo
done


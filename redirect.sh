#!/bin/sh
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8877
iptables -A FORWARD -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -p udp --sport 53 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination SERVER_IP_ADDRESS
iptables -P FORWARD DROP



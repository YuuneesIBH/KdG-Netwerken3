#!/bin/bash
# iptables configuratie script

# 1. Flush alle chains (INPUT/OUTPUT/FORWARD)
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD

# 2. Verwijder user-defined chains en counters
iptables -X
iptables -Z

# 3. Zet default policies op DROP
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# 4. Sta IPv4 ICMP (ping) toe met rate limiting
iptables -A INPUT -p icmp -m limit --limit 1/s --limit-burst 5 -j ACCEPT
iptables -A INPUT -p icmp -j LOG --log-prefix "ICMP IPTABLES: "
iptables -A OUTPUT -p icmp -j ACCEPT

# 5. Sta uitgaand HTTP verkeer toe (poort 80)
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT

# 6. Sta binnenkomende antwoorden op HTTP toe (poort 80, ephemeral sourceports)
iptables -A INPUT -p tcp --sport 80 --dport 1025:65535 -j ACCEPT

# 7. Log en sta DNS (UDP/53) toe
iptables -A OUTPUT -p udp --dport 53 -j LOG --log-prefix "UDP IPTABLES: "
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -j ACCEPT

# 8. Toon regels
iptables -L -n -v

# 9. Blokkeer IPv6 pings (ICMPv6)
ip6tables -F
ip6tables -P INPUT DROP
ip6tables -P OUTPUT ACCEPT
ip6tables -A INPUT -p icmpv6 -j DROP
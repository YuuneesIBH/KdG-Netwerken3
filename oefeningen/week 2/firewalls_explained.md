# Firewalls Explained - iptables Configuration Guide

## Overzicht

Dit document behandelt de configuratie van firewalls met iptables in Linux. Een firewall is een systeem dat regels oplegt tussen twee of meer netwerken om ongewenst verkeer te blokkeren en gewenst verkeer toe te laten.

## Wat is een Firewall?

Een firewall is een beveiliging die ervoor zorgt dat er geen ongewenst verkeer naar het interne netwerk kan komen. Het werkt als een hindernis tussen het Internet en uw lokale netwerk.

### Firewall Technieken

1. **Toegangslijsten (ACL's)** - Bepalen welk verkeer toegelaten wordt
2. **Application Wrappers** - Extra beveiliging rond netwerkservices  
3. **Proxies** - Onderscheppen en controleren van verkeer

## iptables Basis

### Belangrijke Chains

- **INPUT**: Voor binnenkomend verkeer
- **OUTPUT**: Voor uitgaand verkeer  
- **FORWARD**: Voor doorgestuurd verkeer

### Basis Commando's

```bash
# Bekijken huidige regels
iptables -L -n -v

# Alle regels wissen
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD

# Counters resetten
iptables -Z

# User-defined chains verwijderen
iptables -X

# Default policies instellen
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
```

## Protocollen

### TCP Verkeer

TCP is een betrouwbaar, verbindingsgericht protocol. Verbindingen beginnen met een SYN pakket.

```bash
# HTTP verkeer toestaan (poort 80)
iptables -A INPUT -p tcp --sport 80 --dport 1025:65535 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT

# SSH verkeer toestaan (poort 22)
iptables -A INPUT -p tcp --sport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
```

### UDP Verkeer

UDP is onbetrouwbaar maar efficiënt. Vooral gebruikt voor DNS.

```bash
# DNS verkeer toestaan (poort 53)
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -j ACCEPT
```

### ICMP Verkeer

ICMP wordt gebruikt voor statusberichten zoals ping.

```bash
# ICMP toestaan met rate limiting
iptables -A INPUT -p icmp -m limit --limit 1/s --limit-burst 5 -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT

# ICMP redirect blokkeren
iptables -A INPUT -p icmp --icmp-type redirect -j DROP
```

## Praktische Configuratie

### Basis Firewall Script

```bash
#!/bin/bash
# iptables configuratie script

# 1. Flush alle chains
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
iptables -A OUTPUT -p icmp -j ACCEPT

# 5. Sta uitgaand HTTP verkeer toe (poort 80)
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --sport 80 --dport 1025:65535 -j ACCEPT

# 6. DNS (UDP/53) met logging
iptables -A OUTPUT -p udp --dport 53 -j LOG --log-prefix "UDP IPTABLES: "
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -j ACCEPT

# 7. Blokkeer IPv6 pings
ip6tables -F
ip6tables -P INPUT DROP
ip6tables -P OUTPUT ACCEPT
ip6tables -A INPUT -p icmpv6 -j DROP

# 8. Toon regels
iptables -L -n -v
```

## Geavanceerde Functies

### Stateful Filtering

Stateful filtering houdt verbindingen bij in een statustabel:

```bash
# Nieuwe uitgaande verbindingen toestaan
iptables -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT

# Alleen gevestigde binnenkomende verbindingen toestaan
iptables -A INPUT -p tcp -m state --state ESTABLISHED -j ACCEPT
```

### Rate Limiting

Bescherming tegen DoS aanvallen:

```bash
# Bescherming tegen SYN flood
iptables -A INPUT -p tcp --syn -m limit --limit 1/s -j ACCEPT

# Bescherming tegen ping flood
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
```

### Logging

```bash
# UDP DNS requests loggen
iptables -A OUTPUT -p udp --dport 53 -j LOG --log-prefix "UDP IPTABLES: "

# ICMP paketten loggen
iptables -A INPUT -p icmp -j LOG --log-prefix "ICMP IPTABLES: "

# Logs bekijken
tail -f /var/log/messages
```

## Oefeningen en Praktijk

### Basis Testen

1. **Netwerkverbinding testen**:
   ```bash
   ping 192.168.64.12
   ```

2. **DNS lookup testen**:
   ```bash
   nslookup www.kdg.be
   ```

3. **Poorten scannen**:
   ```bash
   nmap -sT -O 192.168.1.1
   ```

### Met Nemesis

Nemesis kan gebruikt worden om custom pakketten te genereren voor firewall testing:

```bash
# ICMP pakketten versturen
nemesis-icmp -d enp0s1 -S 192.168.128.24 -D 192.168.128.3

# DNS request met nemesis
nemesis-dns -r -d enp0s1 -S 192.168.128.24 -D 192.168.128.24 -q www.kdg.be
```

## Security Best Practices

### IP Spoofing Voorkomen

```bash
# Blokkeer pakketten met eigen IP als bron van buitenaf
iptables -A INPUT -s 192.168.1.0/24 -j DROP
iptables -A INPUT -s 127.0.0.0/8 -j DROP
```

### Source Routing Uitschakelen

```bash
# In het script of via sysctl
echo 0 > /proc/sys/net/ipv4/conf/all/accept_source_route
```

### Minimum Services

- Alleen noodzakelijke poorten openen
- Regelmatig logs controleren
- Sterke authenticatie gebruiken
- Systeem up-to-date houden

## Troubleshooting

### Logs Controleren

```bash
# Firewall logs bekijken
sudo tail -f /var/log/messages | grep IPTABLES

# Kernel logs
sudo dmesg | grep -i firewall
```

### Verbinding Problemen

```bash
# Actieve verbindingen bekijken
netstat -tulpn

# iptables regels met packet counters
iptables -L -n -v
```

### Debug Mode

```bash
# Alle verkeer loggen (tijdelijk voor debug)
iptables -A INPUT -j LOG --log-prefix "DEBUG INPUT: "
iptables -A OUTPUT -j LOG --log-prefix "DEBUG OUTPUT: "
```

## Belangrijke Poorten

| Poort | Protocol | Service |
|-------|----------|---------|
| 20    | TCP      | FTP Data |
| 21    | TCP      | FTP Control |
| 22    | TCP      | SSH |
| 23    | TCP      | Telnet |
| 25    | TCP      | SMTP |
| 53    | UDP/TCP  | DNS |
| 80    | TCP      | HTTP |
| 443   | TCP      | HTTPS |
| 3389  | TCP      | RDP |

## Conclusie

Een goed geconfigureerde firewall is essentieel voor netwerkbeveiliging. Door gebruik te maken van iptables kunnen we granulaire controle uitoefenen over netwerkverkeer. Belangrijk is om:

- Altijd met een restrictive policy (DROP) te beginnen
- Alleen noodzakelijke services toe te staan
- Logging te implementeren voor monitoring
- Regelmatig de configuratie te testen en bij te werken

Voor productieomgevingen wordt aangeraden om ook stateful filtering, rate limiting en geavanceerde logging te implementeren.
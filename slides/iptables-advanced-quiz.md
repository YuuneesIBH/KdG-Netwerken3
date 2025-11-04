# IPTables Advanced Quiz - 20 Moeilijke Vragen

## Vraag 1
**Sta established en related verbindingen toe op INPUT chain:**

- A) `iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT`
- B) `iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT`
- C) `iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT`
- D) `iptables -A INPUT -m conntrack --state ESTABLISHED,RELATED -j ACCEPT`

**Antwoord: A of B** (beide correct, maar A is standaard syntax)
**Flags:** `-m state` = match module state, `--state` = statussen, `-j ACCEPT` = jump naar ACCEPT

---

## Vraag 2
**Blokkeer alle ICMP echo requests (ping) maar sta antwoorden toe:**

- A) `iptables -A INPUT -p icmp --icmp-type echo-request -j DROP`
- B) `iptables -A INPUT -p icmp --icmp-type 8 -j DROP`
- C) `iptables -A INPUT -p icmp --icmp-type echo-reply -j DROP`
- D) `iptables -I INPUT -p icmp --icmp-type 0 -j DROP`

**Antwoord: A of B** (type 8 = echo-request, type 0 = echo-reply)
**Flags:** `-p icmp` = protocol ICMP, `--icmp-type` = specifiek ICMP type

---

## Vraag 3
**Sta SSH toe maar alleen van subnet 192.168.1.0/24:**

- A) `iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 22 -j ACCEPT`
- B) `iptables -A INPUT -p tcp --source 192.168.1.0/24 --dport 22 -j ACCEPT`
- C) `iptables -A INPUT -p tcp -d 192.168.1.0/24 --sport 22 -j ACCEPT`
- D) `iptables -A INPUT -p tcp -s 192.168.1.0/24 --sport 22 -j ACCEPT`

**Antwoord: A of B** (-s = --source)
**Flags:** `-s` = source IP, `-d` = destination IP, `--dport` = destination port, `--sport` = source port

---

## Vraag 4
**Rate limiting voor SSH (max 3 verbindingen per minuut):**

- A) `iptables -A INPUT -p tcp --dport 22 -m limit --limit 3/min -j ACCEPT`
- B) `iptables -A INPUT -p tcp --dport 22 -m recent --update --seconds 60 --hitcount 3 -j DROP`
- C) `iptables -A INPUT -p tcp --dport 22 -m limit --limit 3/minute -j ACCEPT`
- D) `iptables -A INPUT -p tcp --dport 22 -m connlimit --connlimit-above 3 -j DROP`

**Antwoord: A** (basic rate limiting)
**Flags:** `-m limit` = limit module, `--limit` = rate, `-m recent` = recent module voor tracking

---

## Vraag 5
**NAT voor uitgaand verkeer via interface eth0:**

- A) `iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE`
- B) `iptables -t nat -A PREROUTING -o eth0 -j MASQUERADE`
- C) `iptables -t nat -A POSTROUTING -i eth0 -j MASQUERADE`
- D) `iptables -t filter -A POSTROUTING -o eth0 -j MASQUERADE`

**Antwoord: A**
**Flags:** `-t nat` = NAT table, `-o` = output interface, `-i` = input interface, `POSTROUTING` = na routing

---

## Vraag 6
**Port forwarding: externe poort 8080 → interne 192.168.1.10:80:**

- A) `iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 192.168.1.10:80`
- B) `iptables -t nat -A POSTROUTING -p tcp --dport 8080 -j DNAT --to-destination 192.168.1.10:80`
- C) `iptables -t nat -A PREROUTING -p tcp --sport 8080 -j DNAT --to-destination 192.168.1.10:80`
- D) `iptables -t nat -A PREROUTING -p tcp --dport 8080 -j SNAT --to-source 192.168.1.10:80`

**Antwoord: A**
**Flags:** `PREROUTING` = voor routing, `DNAT` = destination NAT, `SNAT` = source NAT

---

## Vraag 7
**Blokkeer alle verbindingen van IP 10.0.0.5:**

- A) `iptables -A INPUT -s 10.0.0.5 -j DROP`
- B) `iptables -I INPUT -s 10.0.0.5 -j DROP`
- C) `iptables -A INPUT -s 10.0.0.5 -j REJECT`
- D) `iptables -A OUTPUT -d 10.0.0.5 -j DROP`

**Antwoord: A of B** (B heeft voorrang door -I)
**Flags:** `-A` = append (achteraan), `-I` = insert (vooraan), `DROP` = stil weggooien, `REJECT` = afwijzen met bericht

---

## Vraag 8
**Log alle gedropte pakketten met prefix "DROPPED:":**

- A) `iptables -A INPUT -j LOG --log-prefix "DROPPED: " --log-level 4`
- B) `iptables -A INPUT -j LOG --log-prefix "DROPPED:" --log-level info`
- C) `iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "DROPPED: "`
- D) `iptables -N LOGGING && iptables -A LOGGING -j LOG --log-prefix "DROPPED: "`

**Antwoord: C** (beste praktijk met rate limiting)
**Flags:** `--log-prefix` = prefix tekst, `--log-level` = syslog level, `-N` = nieuwe chain maken

---

## Vraag 9
**Sta alleen NEW en ESTABLISHED SSH verbindingen toe:**

- A) `iptables -A INPUT -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT`
- B) `iptables -A INPUT -p tcp --dport 22 -m state --state ESTABLISHED -j ACCEPT`
- C) `iptables -A OUTPUT -p tcp --sport 22 -m state --state NEW,ESTABLISHED -j ACCEPT`
- D) `iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT`

**Antwoord: A**
**Flags:** `NEW` = nieuwe verbinding, `ESTABLISHED` = bestaande verbinding

---

## Vraag 10
**Blokkeer alle verbindingen behalve van localhost:**

- A) `iptables -A INPUT ! -s 127.0.0.1 -j DROP`
- B) `iptables -A INPUT -s 127.0.0.1 -j ACCEPT && iptables -A INPUT -j DROP`
- C) `iptables -A INPUT ! -i lo -j DROP`
- D) `iptables -A INPUT -i lo -j ACCEPT && iptables -A INPUT -j DROP`

**Antwoord: D** (meest correcte aanpak)
**Flags:** `!` = NOT operator, `-i lo` = loopback interface

---

## Vraag 11
**Sta FTP data verbindingen toe (passieve mode):**

- A) `iptables -A INPUT -p tcp --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT`
- B) `iptables -A INPUT -p tcp --sport 20 -m state --state ESTABLISHED,RELATED -j ACCEPT`
- C) `iptables -A INPUT -p tcp --dport 21 -j ACCEPT`
- D) `iptables -A INPUT -m helper --helper ftp -j ACCEPT`

**Antwoord: A** (passieve FTP gebruikt hoge poorten)
**Flags:** `--dport 1024:65535` = poort range, `RELATED` = gerelateerde verbindingen

---

## Vraag 12
**Verwijder regel 5 uit INPUT chain:**

- A) `iptables -D INPUT 5`
- B) `iptables -R INPUT 5`
- C) `iptables -X INPUT 5`
- D) `iptables -F INPUT 5`

**Antwoord: A**
**Flags:** `-D` = delete, `-R` = replace, `-X` = delete chain, `-F` = flush chain

---

## Vraag 13
**Maak nieuwe chain genaamd "BADGUYS" en gebruik deze:**

- A) `iptables -N BADGUYS && iptables -A INPUT -j BADGUYS`
- B) `iptables -A BADGUYS && iptables -A INPUT -j BADGUYS`
- C) `iptables -N BADGUYS && iptables -I INPUT -j BADGUYS`
- D) `iptables -X BADGUYS && iptables -A INPUT -j BADGUYS`

**Antwoord: A**
**Flags:** `-N` = new chain, `-X` = delete chain

---

## Vraag 14
**Blokkeer SYN flood attacks:**

- A) `iptables -A INPUT -p tcp --syn -m limit --limit 1/s --limit-burst 3 -j ACCEPT`
- B) `iptables -A INPUT -p tcp --syn -m limit --limit 100/s -j DROP`
- C) `iptables -A INPUT -p tcp --tcp-flags SYN,ACK,FIN,RST SYN -j DROP`
- D) `iptables -A INPUT -p tcp --syn -m recent --set --name SYNFLOOD`

**Antwoord: A** (rate limiting van SYN packets)
**Flags:** `--syn` = SYN flag, `--limit-burst` = burst grootte

---

## Vraag 15
**Sta DNS queries toe (UDP en TCP):**

- A) `iptables -A OUTPUT -p udp --dport 53 -j ACCEPT`
- B) `iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT`
- C) `iptables -A OUTPUT -p udp --dport 53 -j ACCEPT && iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT`
- D) `iptables -A INPUT -p udp --sport 53 -j ACCEPT`

**Antwoord: C** (DNS gebruikt beide)
**Flags:** UDP voor queries, TCP voor zone transfers

---

## Vraag 16
**Blokkeer invalid packets:**

- A) `iptables -A INPUT -m state --state INVALID -j DROP`
- B) `iptables -A INPUT -m conntrack --ctstate INVALID -j DROP`
- C) `iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP`
- D) `iptables -A INPUT -m state --state NEW,INVALID -j DROP`

**Antwoord: A of B** (beide correct)
**Flags:** `INVALID` = ongeldige packets buiten state tracking

---

## Vraag 17
**MAC adres filtering - alleen MAC 00:11:22:33:44:55:**

- A) `iptables -A INPUT -m mac --mac-source 00:11:22:33:44:55 -j ACCEPT`
- B) `iptables -A INPUT -m mac --mac 00:11:22:33:44:55 -j ACCEPT`
- C) `iptables -A FORWARD -m mac --mac-source 00:11:22:33:44:55 -j ACCEPT`
- D) `iptables -A INPUT --mac 00:11:22:33:44:55 -j ACCEPT`

**Antwoord: A**
**Flags:** `-m mac` = MAC module, `--mac-source` = bron MAC

---

## Vraag 18
**Time-based rule - alleen overdag (9-17u):**

- A) `iptables -A INPUT -m time --timestart 09:00 --timestop 17:00 -j ACCEPT`
- B) `iptables -A INPUT -m time --timestart 09:00:00 --timestop 17:00:00 -j ACCEPT`
- C) `iptables -A INPUT -m time --hours 09:00-17:00 -j ACCEPT`
- D) `iptables -A INPUT -m time --time 09:00-17:00 -j ACCEPT`

**Antwoord: A**
**Flags:** `-m time` = time module, `--timestart/--timestop` = tijd range

---

## Vraag 19
**Multiport regel - sta meerdere services toe (80,443,8080):**

- A) `iptables -A INPUT -p tcp -m multiport --dports 80,443,8080 -j ACCEPT`
- B) `iptables -A INPUT -p tcp --dport 80,443,8080 -j ACCEPT`
- C) `iptables -A INPUT -p tcp -m multiport --ports 80,443,8080 -j ACCEPT`
- D) `iptables -A INPUT -p tcp --dports 80,443,8080 -j ACCEPT`

**Antwoord: A**
**Flags:** `-m multiport` = multiport module, `--dports` = meerdere destination ports

---

## Vraag 20
**TTL manipulatie - set TTL naar 64:**

- A) `iptables -t mangle -A POSTROUTING -j TTL --ttl-set 64`
- B) `iptables -t filter -A OUTPUT -j TTL --ttl-set 64`
- C) `iptables -t mangle -A OUTPUT -j TTL --ttl-inc 64`
- D) `iptables -t nat -A POSTROUTING -j TTL --ttl-set 64`

**Antwoord: A**
**Flags:** `-t mangle` = mangle table, `--ttl-set` = zet TTL, `--ttl-inc` = verhoog TTL

---

## Korte Uitleg Belangrijkste Flags

### Chain Operaties:
- **-A** (append) = voeg regel toe aan einde
- **-I** (insert) = voeg regel toe aan begin
- **-D** (delete) = verwijder regel
- **-F** (flush) = verwijder alle regels
- **-N** (new) = maak nieuwe chain
- **-X** (delete) = verwijder chain
- **-P** (policy) = zet default policy

### Match Criteria:
- **-s / --source** = bron IP
- **-d / --destination** = doel IP
- **-p** = protocol (tcp/udp/icmp)
- **-i** = input interface
- **-o** = output interface
- **--sport** = source port
- **--dport** = destination port

### Targets:
- **-j ACCEPT** = sta door
- **-j DROP** = gooi weg (stil)
- **-j REJECT** = weiger (met ICMP)
- **-j LOG** = log pakket
- **-j MASQUERADE** = masquerading NAT
- **-j DNAT** = destination NAT
- **-j SNAT** = source NAT

### Modules (-m):
- **state** = connection state tracking
- **conntrack** = connection tracking (nieuwer)
- **limit** = rate limiting
- **recent** = recent connection tracking
- **multiport** = meerdere poorten
- **mac** = MAC adres filtering
- **time** = tijd-gebaseerde regels

### Tables (-t):
- **filter** = default, filtering
- **nat** = NAT operaties
- **mangle** = pakket manipulatie
- **raw** = connection tracking bypass

---

## Antwoordsleutel
1. A/B | 2. A/B | 3. A/B | 4. A | 5. A | 6. A | 7. A/B | 8. C | 9. A | 10. D
11. A | 12. A | 13. A | 14. A | 15. C | 16. A/B | 17. A | 18. A | 19. A | 20. A
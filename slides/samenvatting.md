# Netwerken 3 - Volledige Samenvatting

## 📡 LAN-WAN Verbindingen

### Basis Concepten
- **LAN** (Local Area Network): Beperkt gebied (kantoor/school)
- **WAN** (Wide Area Network): Groot geografisch gebied, verbindt LAN's
- **Router**: Verbindt LAN met WAN

### Router Types
- **Cisco**: Professioneel, veel opties
- **ADSL**: Thuisnetwerk (modem + router)
- **PC Router**: Softwarematig (pfSense)

### Firewall
- Beveiligt via regels (IP, poorten)
- Hardware (firewall box) of Software (PC firewall)

---

## 🔒 Proxy Servers

### Traditionele Proxy
- Stuurt verzoeken LAN → Internet
- Poort **8080**, browser moet ingesteld
- DNS niet intern nodig

### Transparante Proxy
- Onzichtbaar voor clients
- Poort 80 → 8080 intern
- Browser hoeft NIET ingesteld
- DNS draait intern

### NAT (Network Address Translation)
- Vertaalt interne → externe IP's
- Meerdere computers delen 1 publiek IP

### NAPT (Network Address Port Translation) / Masquerading
- NAT + poortnummers
- Meerdere verbindingen via 1 publiek IP

### Port Forwarding
- WAN toegang tot interne LAN server

### HTTP Accelerator / Reverse Proxy
- Front-end voor interne webservers
- Statische pagina's uit cache
- Dynamische pagina's van server

---

## 📊 OSI-Lagen

| Laag | Eenheid | Poorten |
|------|---------|---------|
| Applicatie/Presentatie/Sessie | DATA | - |
| Transport | SEGMENT | Client >1024, Server <1024 |
| Netwerk | PAKKET | IP via DNS |
| Datalink | FRAME | MAC via ARP |
| Fysisch | BITS | - |

**Belangrijke Poorten:**
- HTTP: 80, HTTPS: 443, FTP: 21, SSH: 22, DNS: 53

**Voor volledig pakket nodig:**
1. Client: Poortnr (>1024), IP (DHCP/Fixed), MAC (NIC)
2. Server: Poortnr (<1024), IP (DNS), MAC (ARP)

---

## 🖥️ VyOS - Open Source Router

### Basis
- Debian-based, CLI zoals JunOS
- Ondersteunt: RIPv2, OSPF, BGP, NAT, DHCP, Firewall

### CLI Modi
**Operational Mode ($)**: Status opvragen
```bash
show interfaces
show ip route
```

**Configuration Mode (#)**: Instellingen wijzigen
```bash
configure
set interfaces ethernet eth0 address dhcp
commit
save
```

### Belangrijke Commando's
- `delete`: Regel verwijderen (niet `no` zoals Cisco)
- `compare`: Verschillen bekijken
- `rollback`: Terugdraaien
- `run`: Operator commando in config mode

### Configuratie Opslaan
- Standaard: `/opt/vyos/etc/config/config.boot`
- FTP: `save ftp://user:pass@ip/file`

---

## 🔥 Firewalls

### TCP Verbinding
1. **SYN** → Client vraagt verbinding
2. **SYN-ACK** ← Server bevestigt
3. **ACK** → Client bevestigt

**Stoppen:** FIN of RST

### Stateful Firewall
- Bijhouden status elke verbinding
- Sequence numbers tracken
- Timeout per verbinding

### Standaard TCP/IP Pakket
**Bron:** IP (DHCP/Fixed), Poort (>1023), MAC (NIC)  
**Doel:** IP (DNS), Poort (<1023), MAC (ARP binnen LAN, Gateway buiten LAN)

### FTP Modi
- **Actief**: Server poort 20 → Client
- **Passief**: Client → Server random poort

### DNS Poorten
- **UDP 53**: Client aanvragen
- **TCP 53**: Zone transfers

### Anti-Spoofing Regels
- ICMP redirect blokkeren
- Source routing blokkeren

### Cisco Reflexive ACL
```cisco
ip access-list extended UITGAAND
permit tcp any any reflect TCPVERKEER
ip access-list extended INKOMEND
evaluate TCPVERKEER
```

### iptables Stateful
```bash
iptables -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT
```
**RELATED**: Laat ICMP foutberichten door

---

## 📡 High Speed Modems

### Transmissie Types
- **Asynchroon**: Start/Stop bits, Pariteit
- **Synchroon**: Synchronisatiebits (01111110)

### Multiplexing
- **FDM** (Frequency Division): Bandbreedte opdelen in frequenties, guardband nodig
- **TDM** (Time Division): Om de beurt volledig kanaal
- **STDM** (Statistical TDM): Ongebruikt kanaal skippen
- **WDM** (Wavelength Division): Glasvezel, verschillende golflengten
  - **CWDM**: max 8 kanalen
  - **DWDM**: 16 kanalen (160 Gbit/s)

### Verbindingen
- **Simplex**: 1 richting (radio)
- **Half Duplex**: 2 richtingen, niet tegelijk (walkie-talkie)
- **Full Duplex**: Beide richtingen tegelijk

### Baudrate vs Bitrate
- 2 niveaus → baudrate = bitrate
- Meer niveaus → hogere bitrate bij zelfde baudrate

### Datacompressie
- **Lossless**: gif, zip (geen verlies)
- **Lossy**: jpg, mp4, mp3 (met verlies)
- **Run Length Encoding**: Identieke codes vervangen
- **Huffman**: Code lengte o.b.v. frequentie
- **Lempel-Ziv**: Buffer met boomstructuur

### Modulatie
- **AM** (Amplitude Modulation): Hoge/lage golf
- **FM** (Frequency Modulation): Korte/lange golf
- **PM** (Phase Modulation): Fase aanpassing
- **QAM** (Quadrature AM): Combinatie amplitude + fase

---

## 🌐 DSL Technologieën

### ADSL (Asymmetric Digital Subscriber Line)
- Meer download dan upload
- Gebruikt FDM:
  - 0-4 kHz: Telefoon
  - 26-134 kHz: Upstream
  - 134-1000 kHz: Downstream

### Echo Cancellation
- Upstream + Downstream overlappende frequenties
- Bekende upstream aftrekken voor downstream

### DMT (Discrete Multi Tone)
- 1MHz → 256 kanalen van 4 kHz
- Per subkanaal QAM

### ADSL2
- Kortere afstand tot DSLAM (Digital Subscriber Line Access Multiplexer)

### ADSL2+
- Spectrum tot 2.2 MHz
- Low power modus
- Realtime signaal/ruis meting
- 1.1-2.2 MHz (geen cross-talk)

### VDSL (Very High Speed DSL)
- Max 1 km tot DSLAM
- Symmetrisch/Asymmetrisch mogelijk

### Andere DSL
- **HDSL**: 2 paar telefoonkabels
- **SDSL**: Symmetrisch, voor servers
- **Naked DSL**: Zonder telefoon/splitser

### Ruis Oorzaken
- Niet-beëindigde koperdraad
- Overspraak (cross-talk)
- Telefoongebruik
- Huishoudapparaten, bliksem
- Radiogolven

---

## 📺 Kabelmodems

### Frequentiespectrum
- 5-42 MHz: Upstream Data
- 42-54 MHz: Gap
- 54-550 MHz: TV kanalen
- 550-750 MHz: Downstream Data

### CMTS (Cable Modem Termination System)
- Opdeling gebruikersverkeer
- Koppeling kabelnetwerk ↔ DHCP/Internet

### DOCSIS Protocol
- Data Over Cable Service Interface Specification
- OSI Laag 1 en 2
- **v1.1**: QoS
- **v2.0**: Symmetrisch, betere ruisbescherming
- **v3.0**: IPv6
- **v3.1**: Full-duplex, 4096 QAM

### HFC (Hybrid Fibre Coax)
- Glasvezel tot straat
- Coax tot in huis
- 1 node ≈ 290 gezinnen

---

## 🔌 Fiber & Powerline

### FTTH (Fiber To The Home)
- **Point-to-Point**: Direct provider → gebruiker
- **PON** (Passive Optical Network): Split 16-32 gebruikers

### PCS (Probabilistic Constellation Shaping)
- Variabele punten ipv vaste QAM
- Klein mogelijke amplitude
- Realtime aanpassing
- Tot 1 Terabit/sec

### Powerline
- Data via 220V stopcontact
- **Voordelen**: Lage kost, bestaande verbindingen
- **Nadelen**: Interferentie, externe ruis, last-mile only

---

## 📶 Wireless - WiFi

### WLAN Modi
- **Ad-hoc**: Rechtstreeks tussen apparaten, mesh netwerk
- **Infrastructure**: Via centraal Access Point (AP)

### MANET (Mobile Ad-hoc Network)
- Zelf-configurerend
- Elk apparaat = router
- **B.A.T.M.A.N Protocol**: Better Approach To Mobile Adhoc Network

### WLAN Roaming
- **Seamless**: GSM
- **Nomadic**: WLAN
- 4 stappen: Disassociatie, Zoeken, Her-associatie, Authenticatie
- Op laag 2 (IP behouden)

### ESS (Extended Service Set)
- Meerdere AP's vormen ESS
- Regelmatige beacons
- Aanliggende AP's = verschillende kanalen

### WiFi Standaarden

| Standaard | Naam | Jaar | Band | Snelheid | Features |
|-----------|------|------|------|----------|----------|
| 802.11n | WiFi 4 | 2009 | 2.4/5.2 GHz | - | MIMO (4 kanalen), Channel bonding |
| 802.11ac | WiFi 5 | 2013 | 5 GHz | Gigabit | 256 QAM, MIMO (8 kanalen), 80-160 MHz |
| 802.11ax | WiFi 6 | 2019 | 2.4/5 GHz | 10 Gbps | OFDM, 300% verbetering |
| 802.11axe | WiFi 6E | - | 2.4/5/6 GHz | - | Extra 6G band |

### WLAN Apparaten
- **FAT AP**: Alle functies (RF, conversie, auth, encryptie, beheer)
- **THIN AP**: Enkel RF + conversie

### Bridges
- **Transparent**: Forward tabel, leren
- **Source Route**: AR (All-Route) en SR (Single-Route) frames

### Switching
- **Cut-Through**: Doorsturen bij source/dest herkenning
- **Fast-Forward**: Doorsturen bij dest MAC herkenning
- **Store-Forward**: Buffer, dan doorsturen (voorkomt runts/giants)

---

## 📡 Antennes

### Concepten
- **Directionaliteit**: Omnidirectioneel (360°) of Directioneel
- **Gain**: dBi/dBd gemeten, meer gain = meer dekking
- **Polarizatie**: Meestal verticaal

### Decibel (dB)
**Formule:** dB = 10 log₁₀(P₂/P₁)
- Negatief = verzwakt
- Positief = versterkt

### Gain vs Beamwidth
- Hogere gain → kleinere openingshoek
- Lagere gain → grotere openingshoek
- **LET OP**: Hogere gain ≠ altijd betere dekking!

### Types
- **Omnidirectioneel**: Groot gebied, slecht dwars op antenne
- **Directioneel**: Beperkte zone, meer focus
- Yagi, Sector, Paneel, Schotel

### Line-of-Sight
- VHF transmissies
- Aarde kromming beperkt afstand

---

## 🔐 Wireless Security

### Evolutie
- **1997**: WEP (Wired Equivalent Privacy), SSID, MAC filter
- **2001**: WEP zwakheden ontdekt
- **2003**: WPA (WiFi Protected Access)
- **2004**: WPA2 (802.11i)
- **2018**: WPA3

### (E)SSID
- Extended Service Set Identity = netwerknaam
- **Ad-hoc**: SSID
- **Infrastructure**: ESSID
- Beacon-frames broadcasten SSID
- **Stealth AP**: Geen SSID broadcast

### MAC Filter
- Lijst toegelaten MAC-adressen
- **Zwakheid**: Sniffen + aanpassen MAC eenvoudig

### WEP Authenticatie
- **Open System**: Iedereen toegelaten
- **Shared-Key**: Gedeelde sleutel nodig
- **Nadeel**: CRC te eenvoudig voor integriteit

### WPA (WiFi Protected Access)
**Personal:**
- TKIP/MIC encryptie
- PSK (Pre-Shared Key) auth

**Enterprise:**
- TKIP/MIC encryptie
- 802.1X/EAP auth
- AAA server (RADIUS)

### TKIP (Temporal Key Integrity Protocol)
- Wrapper rond WEP (RC4-Engine)
- MIC (MICHAEL) voor integriteit
- **Zwakheden**: Brute force bij zwak wachtwoord, Beck Tews attack (2008)

### WPA2
**Grote verschil:** AES encryptie (hardware)

**Personal:** PSK + AES-CCMP  
**Enterprise:** 802.1X/EAP + AES-CCMP

### 4-Way Handshake
1. Client ← AP: nonce1
2. Client → AP: nonce2
3. Client ← AP: sessiekey1 (uit nonce1)
4. Client → AP: sessiekey2 (uit nonce2)

### KRACK (Key Reinstallation Attack)
- Msg4 blokkeren
- Hertransmissie Msg3 → nonce1 reset
- Valse replays mogelijk

### WPA3 (2018)
- Minimum AES-128
- Anti brute force
- **Zwakheid**: Dragonblood (downgrade attack)

### Authenticatie Protocollen

**EAP-LEAP:**
- Cisco's Lightweight EAP
- Gekraakt (MS CHAP v1)

**PEAP (Protected EAP):**
- Server PKI certificaat
- TLS tunnel
- Auth binnen tunnel
- **PEAPv0**: EAP MSCHAPv2 (Microsoft)
- **PEAPv1**: EAP-GTC (Token)

**EAP-TTLS:**
- Server + optioneel client certificaat
- TLS tunnel
- Username/pass auth
- Niet door MS ondersteund

### RADIUS
- Remote Authentication Dial-in User Service
- Client → AP → RADIUS server
- Geëncrypteerde auth key
- **MS variant**: IAS (Internet Authentication Service)

### Security Vergelijking

| Feature | WEP | WPA | WPA2 |
|---------|-----|-----|------|
| Encryptie | RC4 | RC4 | AES |
| Sleutel | 128 bit | 128 bit/pakket | 40/128 bits |
| IV | 24-bit | 48-bit | 48-bit |
| Integriteit | CRC32 | Michael MIC | CCM |
| Beheer | Geen | 802.1X/EAP/PSK | 802.1X/EAP/PSK |

---

## 🏷️ RFID, IR & Bluetooth

### RFID (Radio Frequency Identification)

**Types:**
- **Passief**: Enkel scannen, geen batterij
- **Semi-Actief**: Batterij, antwoord op aanvraag
- **Actief**: Batterij, zendt signaal uit

**Frequenties:**
- 125-134 kHz (LF): Mens/dier, 0.05-0.10m
- 13.56 MHz (HF): Bibliotheek, 0.3m
- 868-955 MHz (UHF): Supply chain, 3-6m
- 2.45/5.8 GHz (MW): Tolpoorten, 10-1000m

**RFID vs Barcode:**
- RFID: Exemplaar-ID, bulk lezen, op afstand, herprogrammeerbaar
- Barcode: Type-ID, per stuk, korte afstand, eenmalig

**Nadelen:**
- Werkt niet met vloeistof/metaal (behalve 125 kHz)
- Tags storen elkaar bij te dicht
- Geen beveiliging (binaire datastroom)

### IR (Infrarood)

**Eigenschappen:**
- 802.11 standaard
- Beperkte reikwijdte
- Voor WPAN (Wireless Personal Area Network)
- Gezichtsveld nodig

**IrDA (Infrared Data Association):**
- v1.0: 115.2 Kbps
- v1.1: 4 Mbps
- v1.2/1.3: Low power opties
- Half-duplex
- Storing door omgevingslicht

### Bluetooth

**Basis:**
- 1994 Ericsson
- Deense koning Harald Blauwtand
- RF technologie, ad-hoc PAN binnen 10m
- Frequency-hopping

**FHSS (Frequency Hopping Spread Spectrum):**
- 2.402-2.480 GHz
- Pseudorandom frequentie wissel

**Klassen:**
- Class 1: 100m, 100 mW
- Class 2: 10m, 2.5 mW
- Class 3: 10cm, 1 mW

**Protocollen:**
- **OBEX**: Object Exchange (zoals HTTP)
- **LMP**: Link Manager Protocol (auth, encryptie)
  - Synchroon (Voice): Reserved timeslots, geen hertransmissie
  - Asynchroon (Data): Wel hertransmissie
- **SDP**: Service Discovery Protocol (UUID)

**Netwerk:**
- **Piconet**: Max 8 apparaten, 1 master + slaves
- **Scatternet**: Meerdere piconets, apparaten doorsturen verkeer

**Pairing:**
- PIN code (4-6 cijfers)
- Voorkomt ongewenste verbindingen

**Profielen:**
- Audio streaming (headphone, autoradio)
- Afstandsbediening (TV, radio)
- File transfer (foto's, documenten)
- HID (muis, keyboard, joystick)
- Hands-free (GSM)
- Intercom, PAN, SIM access

---

## 🗂️ Proxy Servers (Uitgebreid)

### Definitie
Server die diensten uitvoert voor gebruikers:
- HTTP, FTP, Telnet, Real Audio, DNS, SOCKS

### Disk Cache
- Ruimte op HDD voor tijdelijke bestanden
- FIFO systeem (First In First Out)
- **HIT**: Pagina in cache
- **MISS**: Pagina niet in cache
- Disk cache ≠ Hardware cache (100-500 KB vs 100+ MB)

### Functies

**Client Accelerator:**
- Disk cache voor reeds opgehaalde data

**HTTP Accelerator / Reverse Proxy:**
- Front-end voor interne webservers
- Statische pagina's uit cache
- Dynamische pagina's van server
- Firewall functie

**Hierarchische Proxy:**
- Watervalstructuur
- Bij MISS: Volgende proxy vragen
- Hoogste proxy haalt van webserver

### Voordelen
- **Snelheid**: Geen dubbel ophalen (disk cache)
- **Beveiliging**: Netwerk verborgen achter proxy
- **Security**: ACL's toegangscontrole

### Cache Validatie
- Aanvraag webserver of pagina veranderd
- Datum/tijd check (snelste)
- **TTL** (Time To Live):
  - WWW adressen: 2 uur
  - GIF files: 7 dagen
  - CGI-bin: 30 minuten

### SOCKS
- Volledige toegang beide kanten proxy
- Username + password auth
- Network firewall
- Programma's: putty.exe, telnet

**Versies:**
- **v4**: Geen UDP proxy, geen auth, geen DNS
- **v5**: Browser support, anonymous FTP, username/pass in cleartext!
- **v6**: TCP Fast Open, 0-RTT, early data

### ICP (Internet Cache Protocol)
- Communicatie tussen proxy servers
- Cascading/hiërarchische proxies
- **Neighbour**: Samenwerkt met proxy
- **Parent**: Hoger niveau proxy
- Snelste proxy geeft antwoord
- **Squid**: Meest gebruikte (Unix/Linux)

### ACL's (Toegangsregels)
Blokkeren/toelaten van:
- IP-nummers/ranges
- Interfaces
- Tijdstippen
- URL's
- Bestandstypes (zip, gif, mpg)
- Services (http, https, ftp, telnet, socks)

### Logs
- Security logs
- Error logs (verkeerde wachtwoorden)
- Onveilige IP-nummers
- Elke opgevraagde pagina

---

## 🔄 ATM (Asynchronous Transfer Mode)

### Basis
- Ontstaan jaren '80 (Broadband B-ISDN)
- Transport: Spraak, Data, Video
- QoS (Quality of Service)
- Connection oriented (end-to-end virtual circuits)
- Circuit switched (capaciteit ligt vast)
- Cel-gebaseerd: 53 bytes (5 header + 48 payload)
- Mb → Gb snelheden

### Traffic Contract
**Parameters:**
- **PCR** (Peak Cell Rate): Max snelheid piekverkeer
- **ACR** (Average Cell Rate): Gemiddelde snelheid
- **QoS**: Vertraging en verlies cellen

**QoS Ondersteuning:**
- Cell loss ratio
- Cell delay
- Cell delay variation
- **CAC** (Connection Admission Control): Check bij aanmaken

### ATM Concepten
- **Switch-gebaseerd** (NIET shared zoals hub)
- Verschillende toegangssnelheden
- Toegekende bandbreedte per verbinding

### ATM Cel (53 Bytes)
**Header (5 bytes):**
- Flow control (niet gebruikt)
- VPI/VCI (Virtual Path/Channel Identifier)
- Payload Type Identifier
- Cell Loss Priority (CLP)
- Header Error Check

**Payload (48 bytes):** Spraak, video of data

### Virtuele Circuits

**PVC (Permanent Virtual Circuit):**
- Vast gealloceerd
- Van tevoren PCR/SCR vastgelegd
- Voor data (huurlijn)

**SVC (Switched Virtual Circuits):**
- Alleen opgezet wanneer nodig
- Zoals telefoonlijn

### Interfaces
- **UNI** (User-Network Interface): Rand netwerk
- **NNI** (Network-Network Interface): Binnen netwerk

### Verbindingen
- **Point-to-Point**: A → B of A ↔ B
- **Point-to-Multipoint**: A → B,C,D (eenrichting)

### ATM Lagen

**Adaptatie Laag:**
- Conversie naar 48 bytes
- **AAL1**: Circuit Emulation
- **AAL2**: Video/Audio (variabele bitrate)
- **AAL3/4**: Data Transfer
- **AAL5**: LAN verkeer (meest gebruikt, SEAL)

**ATM Laag:**
- Header toevoegen/verwijderen
- Beheer virtuele circuits/paden
- Routeren via switches

**Fysische Laag:**
- Elektrisch/optisch signaal
- Media: STP, UTP, Coax, Fiber, Draadloos
- Backbones: ADSL, VHDL

### VPI/VCI
- **VPI** (Virtual Path Identifier): Per pad
- **VCI** (Virtual Channel Identifier): Per toepassing
- Enkel lokaal uniek per interface
- UNI: 8 bits VPI
- NNI: 12 bits VPI

### Leaky Bucket Algoritme
- CLP=1 cellen eerst weggegooid
- Traffic shaping
- QoS handhaving

### ATM vs OSI
- Past NIET in OSI model
- Overlay-network
- Eigen adressering + routering
- Hiërarchische adressering (Plug n Play)

### ATM Nadelen
- Firewalls kunnen info niet interpreteren
- **PRIJS!** Zeer duur
- LAN: Verlies bandbreedte (overhead naar TCP/IP)
- **In praktijk niet meer voor LAN gebruikt**

---

## 🌐 BGP (Border Gateway Protocol)

### Wat is BGP?
- Routing protocol voor ISP's
- Verbindt providers
- Routing tussen Autonome Systemen (AS)
- Distance vector (waarde op verbinding)

### AS (Autonome Systemen)
- Verzameling IP netwerken + routers (zelfde admin)
- **Privaat**: 64512-65535
- **Publiek**: Uniek wereldwijd (ASN)
- Was 16-bit, sinds 2007: 32-bit

**IANA via 5 organisaties:**
- AfriNIC (Afrika)
- APNIC (Azië/Pacific)
- ARIN (Amerika)
- LACNIC (Latijns-Amerika/Caraïben)
- RIPE-NCC (Europa, Midden-Oosten, Centraal-Azië)

### Routering
- **IBGP**: Intern (binnen AS)
- **EBGP**: Extern (buiten AS)

### BGP Sessie
- TCP poort **179**
- Uitwisseling actieve routes
- Incrementele updates
- **Update = IP prefix + attributen:**
  - **AS_PATH**: Aantal AS (hops)
  - **MULTI_EXIT_DISC**: 32-bit waarde voor verbindingsvoorkeur

### Beste Pad Kiezen
1. EBGP > IBGP
2. Kortste AS_PATH
3. Kleinste MULTI_EXIT_DISC
4. Laagste BGP ID (IP adres)

### Langste Prefix Voorrang
- 10.10.10.0/24 > 10.0.0.0/8

### BGP Routing Tabel
- Groei: ~10k (1994) → ~700k+ (2016)
- BGP domein = **HEEL INTERNET**

### BGP Hijacking
- Met eigen AS nummer routing manipuleren
- Geef /24 betere route
- Alle verkeer via jou
- TTL aanpassen (anders traceroute opvalt)

---

## 🔗 CIDR (Classless Inter Domain Routing)

- IP zonder standaard klasse A/B/C
- IP prefix doorgeven:
  - /24 voor klasse C
  - /16 voor klasse B
  - /8 voor klasse A
- Classfull: 20.0.0.0 = direct /8
- Classless: Prefix zelf kiezen
- Protocollen: RIPv2, OSPF, EIGRP

---

## 🔌 Point-to-Point Verbindingen

### X.25 Protocol

**Basis (jaren 1970):**
- Analoge en ISDN lijnen
- **DTE** (Data Terminal Equipment)
- **DCE** (Data Circuit-terminating Equipment): Provider, kloksnelheid
- Packet Switched
- **PAD** (Packet Assembler/Disassembler)

**Lagen (OSI 1-3):**
- **Laag 3**: PLP (Packet Layer Protocol), Virtual Circuits
- **Laag 2**: LAP-B (Link Access Procedure Balanced), uitgebreide error correctie
- **Laag 1**: X.21 bitstroom

**Netwerk:**
- Domme terminal belt provider
- Lokale connectiekost

---

### Frame Relay

**Eigenschappen:**
- X.25 "lite" (zonder extensieve foutcontrole)
- Geen hertransmissie verloren data
- Geen sliding windows
- Foutafhandeling door hogere lagen
- Hogere performantie
- Betrouwbaar medium verwacht

**Gebruik:**
- WAN verbindingsdienst
- LAN's met elkaar verbinden
- OSI Laag 2 (data link)

**DLCI (Data Link Channel Identifier):**
- Onderscheid virtuele circuits
- Unieke DLCI per VC

**LAPF (Link Access Procedure for Frame Relay):**
- IP pakketten → Frame Relay frames
- Bits voor congestie melding
- CLP-achtig: Mag weggegooid bij overload

**LMI (Local Management Interface):**
- "Gang of four" extensie
- Info over netwerktoestand
- **Types** (niet compatible):
  - Cisco
  - ANSI
  - Q933a (ITU)
- **Functionaliteit:**
  - Globale adressering (DLCI niet enkel lokaal)
  - Status berichten VC's
  - Multicasting
  - Flow Control

**CIR (Committed Information Rate):**
- Afspraak snelheid met provider
- Burst, tijd, maximum rate
- Mogelijk via meerdere lijnen

### Frame Relay vs ATM

| Feature | Frame Relay | ATM |
|---------|-------------|-----|
| Pakket | Variabel | Vast (53 bytes) |
| QoS | Geen standaard | QoS + prioriteiten |
| Support | Meer bij providers | Goed schaalbaar |
| Prijs | Goedkoper | Duur/complex |
| Snelheid | 64 Kbps - 40 Mbps | 1.5 Mbps - 622+ Mbps |
| Gebruik | Rand netwerken | Core netwerken |
| Toekomst | Voldoet NU | Toekomst (hogere snelheden) |

---

# Samenvatting MPLS en Advanced Networking - Netwerken 3

## MPLS (Multi Protocol Label Switching)

### Definitie
- **MPLS** = Multi Protocol Label Switching
- Oplossing voor bandbreedte- en dienstenbeheer in IP-gebaseerde backbone netwerken
- Framework voor schaalbaarheid en routering van traffic flow in ATM en Frame Relay netwerken
- Werkt **tussen laag 2 en laag 3** van OSI-model

### Waarom MPLS?
**Traditionele routering tekortkomingen:**
- Te veel focus op kortste pad
- Te weinig rekening met vertraging en congestie
- Complexiteit en kostprijs van ATM als alternatief

**Voordelen MPLS:**
- Meer bandbreedte voor data, spraak en multimedia
- Verschillende dienstenklassen en QoS mogelijk
- Goedkoper dan ATM
- Minder complex dan ATM

### Kernfuncties
1. Specifieert verkeersstromen tussen verschillende niveaus
2. Onafhankelijk van Laag 2 en Laag 3 protocollen
3. Mapped IP adressen naar eenvoudige **labels** (vaste lengte)
4. Interface naar bestaande routing protocollen (OSPF)
5. Ondersteunt IP, Frame Relay en ATM

### Routeringsconcepten

#### 1. Broadcast
"Zoek maar" - Ga overal langs en stop bij bestemming

#### 2. Hop-by-Hop Routing
"Ga langs X, het ligt op de weg!" - Vraag bij elk punt de volgende stap

#### 3. Source Routing
Volledige routebeschrijving van tevoren

#### 4. Label Substitution (MPLS methode)
- Elk kruispunt heeft gereserveerd rijvak
- Grote pijl wijst naar volgende baanvak
- Gereserveerde "lane" per verbinding

### Labels in verschillende technologieën
- **ATM**: VPI/VCI
- **Frame Relay**: DLCI
- **TDM**: Timeslot
- **X.25**: LCN
- **Nieuw**: "Shim Label" (waar geen bestaand label is)

### MPLS Label Structuur
```
| Label (20 bits) | Exp (3 bits) | BS (1 bit) | TTL (8 bits) |
```

**Velden:**
- **Label**: 20 bits voor label identificatie
- **Exp bits**: Verkeersklasse (QoS)
- **BS**: Bottom of Stack (laatste label indicator)
- **TTL**: Time To Live (zoals bij IP)

### MPLS Componenten

#### Label Edge Router (LER)
- Zit aan **rand** van MPLS netwerk
- Voorziet/verwijdert labels bij pakketten
- Ondersteunt meerdere poorten naar verschillende netwerken

#### Label Switch Router (LSR)
- Hoge-snelheidsrouter in **hart** van MPLS netwerk
- ATM switches kunnen als LSR functioneren zonder hardware wijzigingen
- Label switching = VP/VC switching

### Label Switched Path (LSP)

**Opzetten LSP:**
- Vastgelegd **VOOR** transmissie start (network provisioning)
- Twee methoden:
  1. **Hop-by-hop routing**: Elke LSR kiest zelf volgende hop
  2. **Explicit routing**: Source routing - volledige lijst van nodes

**Belangrijk:**
- LSP is **unidirectioneel**
- Terugkerend verkeer krijgt nieuwe LSP!

### Label Distribution
- MPLS specifieert NIET hoe labels verspreid worden
- **BGP** uitgebreid met piggybacking voor labels
- **LDP** (Label Distribution Protocol): speciaal protocol voor labels
  - Extensies ondersteunen QoS parameters

---

## BGP (Border Gateway Protocol)

### Wat is BGP?
- Routing protocol voor **Internet Providers**
- Verbindt providers met elkaar
- Routing tussen **Autonome Systemen (AS)**
- Werkt met **distance vector** (geen volledige topologie kennis)

### Autonoom Systeem (AS)
**Definitie:** Verzameling IP netwerken en routers beheerd door dezelfde administrator(s)

**AS Nummers:**
- **Privaat**: 64512 - 65535 (zelf kiezen)
- **Publiek**: Uniek wereldwijd (ASN)
- Oorspronkelijk 16 bit, sinds 2007 ook 32 bit
- Uitgedeeld door IANA via 5 regionale organisaties:
  - AfriNIC (Afrika)
  - APNIC (Azië/Pacific)
  - ARIN (Amerika)
  - LACNIC (Latijns-Amerika/Caraïben)
  - RIPE-NCC (Europa, Midden-Oosten, Centraal-Azië)

### BGP Werking
- Geen centrale "core"
- Individuele netwerken verbinden en melden IP adressen
- **Announcements** met: IP, prefix, AS_PATH
- **AS_PATH** = lijst van doorstuurders (voorkomt loops)

### Interne vs Externe Routering
- **IBGP**: Intern binnen AS
- **EBGP**: Extern tussen AS's

### CIDR (Classless Inter Domain Routing)
- IP adressen werken niet meer met standaard klasse A/B/C
- Prefix notatie:
  - /24 voor klasse C
  - /16 voor klasse B
  - /8 voor klasse A
- Voorbeeld: 10.10.10.0/24 heeft voorrang op 10.0.0.0/8

### BGP Sessie
- Verbinding over **TCP poort 179**
- Alle actieve routes worden uitgewisseld
- **Update** = IP prefix + attributen
  - **AS_PATH**: Aantal AS's (≈ hops)
  - **MULTI_EXIT_DISC**: 32-bit waarde voor verbindingsvoorkeur (lager = sneller)

### BGP: Kiezen beste pad
Volgorde van criteria:
1. Externe EBGP routes krijgen voorrang op interne IBGP
2. Kortste AS_PATH
3. Kleinste MULTI_EXIT_DISC waarde
4. BGP ID (laagste IP adres krijgt voorrang)

### BGP Updates
- Langste prefix geeft meeste info → krijgt voorrang
- Voorbeeld: 10.10.10.0/24 > 10.0.0.0/8

### BGP Hijacking
**Principe:**
- Met eigen AS nummer kan je routing tabellen manipuleren
- Geef zelf /24 met "betere" route door
- Verkeer gaat via jou
- Je ziet alle verkeer én kan het aanpassen

**Bekende voorbeelden:**
- **Youtube Hijack** (25/02/2008): Pakistan blokkeerde Youtube, route werd per ongeluk wereldwijd verspreid
- **China Telecom Hijack** (08/04/2010): 15% van internet verkeer via China gestuurd

### BGP Routing Tabel Groei
- BGP routing domein = **HEEL INTERNET**
- /24 adressen kunnen niet overschreven worden → grootste zekerheid
- MAAR: maakt routing tabellen enorm groot
- Exponentiële groei: ~10.000 entries (1994) → ~700.000+ (2016)

---

## IPv6

### IPv4 Beperkingen
1. **32 bit adressen zijn op**
2. **Routing tabellen te groot** (niet hiërarchisch, 400k rijen)
3. **Geen pakketbeveiliging** (IPsec optioneel, niet ingebouwd)
4. **Beperkte realtime ondersteuning** (ToS veld geëncrypteerd = onleesbaar)

### IPv6 Verbeteringen
1. **128 bit adressen**
   - Meer hiërarchisch
   - Multicast en anycast adressen
2. **Header met optionele velden** (niet leeg zoals IPv4)
3. **Uitbreidbare header** (snel doorsturen)
4. **Flow Labels** (QoS, realtime)
5. **Authenticatie en Privacy ingebouwd**

### IPv6 Adresnotatie
**Voorkeur:**
- `2001:0:0:0:0:0:200C:417A`
- `2001::200C:417A` (verkorte vorm)

**Mask met prefix:**
- RIPE NCC: `2001:0600::/23`
- BELNET: `2001:06A8::/32`
- KDG.BE: `2001:06A8:0540::/48`
- STUDENT.KDG.BE: `2001:06A8:0540:0101/64`

### IPv6 Adressering Types

#### Unicast
- 1 adres per interface

#### Anycast
- Groep interfaces
- 1 van de interfaces is voldoende (bv. NTP servers)

#### Multicast
- Afleveren bij alle interfaces
- Is ook broadcast

### Soorten IPv6 Adressen

#### Link-Local / Organisational-Local
- **FE80::/10** (huidige private adressen)
- Geldt enkel binnen link/organisatie
- Bevat MAC adres

#### Unique Local
- **FC00::/7**
- Bevat pseudo random 40 bit nummer

#### Multicast
- **FFxx** (begint met FF)
- Voorbeeld: `FF05::43` = Alle NTP servers binnen site

#### Loopback
- **::1**

### Zones
**Probleem:** Meerdere netwerkkaarten met FE80::1/64 en FE80::2/64

**Oplossing:** Zone-identifier in routetabel
- Windows: `FE80::3%1`
- Linux: `FE80::3eth0`
- Niet altijd zichtbaar in routetabel

### IPv6 Header

**Verdwenen uit IPv4:**
- Header Length
- Identification
- Flags
- Fragment Offset
- Header Checksum

**Veranderd:**
- TTL → **Hop Limit**
- Options → **Extension Headers**
- Type of Service → **Traffic Class**

### Extension Headers (Next Header)

1. **Hop-by-Hop Options Header**
   - Opties voor tussenliggende nodes

2. **Routing Header**
   - Source routing (pad aangeven)

3. **Fragment Header**
   - Fragmenteren pakket met grotere MTU
   - Enkel tussen bron en doel (niet onderweg zoals IPv4)

4. **Destination Options Header**
   - Meestal voor veiligheidsopties

5. **Authenticatie/Encryptie Headers**

### Pakketgrootte
- **Minimum**: 1280 octets
- **Aangeraden**: 1500 octets
- **ICMPv6 Packet Too Big** pakket naar bron bij overschrijding
- Afspraak tussen bron en doel (NIET onderweg)

### Stateless Autoconfiguratie

1. **ICMPv6 Router Solicitation** (type 133)
   - Bron: FE80:: met MAC adres
   - Doel: All routers (FF02::2)

2. **ICMPv6 Router Advertisement** (type 134)
   - Bevat IP adres, Lifetime
   - Doel: All nodes (FF02::1)

3. **ICMPv6 Neighbour Solicitation** (type 135)
   - Check: Uniek MAC adres?

4. **ICMPv6 Neighbour Advertisement** (type 136)
   - Antwoord van host met zelfde MAC

### Stateful Autoconfiguration (DHCPv6)

**Aanvraag:**
- Bron: Link local FE80::MAC, UDP poort 546
- Doel: All DHCP servers FF02::1:2, poort 547

**Antwoord:**
- 128 bit adres en Lifetime

### Mobiele Autoconfiguratie
- GSM krijgt vast IPv6 adres op thuisbasis (**Home Agent**)
- GSM krijgt tijdelijk adres bij verplaatsing
- Stuurt **binding** naar Home Agent
- Tijdelijk adres kan veranderen tijdens gesprek
- Home agent werkt als router

### Flow Labels en Verkeersklasse

#### Flow Labels
- Doel: QoS, realtime diensten
- Voorlopig experimenteel

#### Verkeersklasse
- Prioriteiten tussen pakketten
- Enkel aanpassingen door nodes van dezelfde klasse

### Hogere Lagen Wijzigingen
- IPv6 neemt controlesom van **volledige pakket** (ook UDP)
- Time to Live → **Hop Limit**
- IPv6 tunnel door IPv4 = **1 Hop**

### ICMPv6

#### Type 1 - Error Messages
- **0**: No route to destination
- **1**: Communication prohibited (firewall)
- **3**: Address unreachable
- **4**: Port unreachable

#### Informatie
**Ping:**
- Type 128 code 0: Echo Request
- Type 129 code 0: Echo Reply

**Configuratie:**
- Type 130/131/132: Group membership (anycast)
- Type 133/134: Router Solicitation/Advertisement
- Type 135/136: Neighbor Solicitation/Advertisement

### Authenticatie Header
**Verzekert:**
- Herkomst van verkeer
- Integriteit
- Replay attack bescherming
- Tampering bescherming

**Componenten:**
- **Security Parameter Index**: 32-bit nummers tussen zender/ontvanger
- **Volgnummer**: 32-bit voor integriteit
- **Integrity Check Value**: Hash met gedeeld geheim

### Encryptie Header
**Verzekert:** Confidentialiteit

**Kenmerken:**
- Sleutels uitgewisseld over UDP poort 500
- **Encapsulation Security Payload header** bevat:
  - Encryptieprotocol
  - Volgnummer
  - Checksum
- Enkel op Payload (echte Data)

---

## SNMP (Simple Network Management Protocol)

### Wat is SNMP?
- Protocol voor **monitoring en beheer** van netwerkonderdelen
- Routers, switches, computers, printers
- Werkt door **uitlezen/aanpassen** van variabelen
- Device-afhankelijk

### SNMP Onderdelen

#### 1. SNMP Agent
- Geïnstalleerd op elk te monitoren device
- Heeft databank met device info

#### 2. MIB (Management Information Base)
- Databank met alle info van device
- Per agent

#### 3. SNMP Manager
- Centraal beheerpunt

#### 4. SNMP Protocol
- Regelt communicatie tussen agent en manager

### SNMP Protocol
**Via UDP:**
- **Poort 161**: Request/Response
- **Poort 162**: Notificatie

**Berichttypen:**
1. **GetRequest**: Aanvraag waarden van variabelen
2. **GetNextRequest**: Aanvraag volgende variabele
3. **GetResponse**: Antwoord met waarde
4. **SetRequest**: Device moet waarde aanpassen
5. **Trap**: Melding van agent naar manager (waarde veranderd)

### Management Information Base (MIB)

**Soorten MIBs:**
- System MIB (RFC 1907)
- MIB-II TCP/IP netwerken (RFC 1213)
- Interface MIB (RFC 2233)
- TCP MIB (RFC4023)
- IP MIB (RFC4293)
- Per fabrikant (Cisco, Microsoft, IBM)

**MIB Structuur:**
- Boomstructuur met alle objecten
- MIB = tekstbestand in **ASN.1** (Abstract Syntax Notation)
- Linux: `/usr/share/snmp/mibs`

**Object Identifiers (OID):**
- Reeks getallen of woorden, gescheiden door punt
- Voorbeeld: `1.3.6.1.2.1.4.6`
- Of: `iso.org.dod.internet.mgmt.mib-2.ip.ipForwDatagrams`

### SNMP Versies

#### SNMPv1 (1990)
- Basis versie
- Community string als plaintext authenticatie

#### SNMPv2c (1996)
- "GetBulk" functie
- RMON (remote monitoring)
- **c** = "community" (zelfde string als v1)
- Security verbetering mislukt

#### SNMPv3 (2002)
- **Integriteit**: Pakket niet aangepast
- **Authenticatie**: Bron verzekerd
- **Privacy**: Pakket niet leesbaar door derden

### SNMPv3 Security Niveaus

1. **noAuthNoPriv**
   - Authenticatie met juiste gebruikersnaam

2. **authNoPriv**
   - Authenticatie met MD5 of SHA
   - Geen encryptie

3. **authPriv**
   - Authenticatie met MD5 of SHA
   - DES of AES encryptie

**Toegang:**
- Per gebruiker of community
- Per MIB sectie
- Per range van IP adressen

### SNMPv3 Configuratie

**Met authenticatie:**
```
createUser authOnlyUser MD5 "secret007"
rouser authOnlyUser
```

**Met authenticatie en privacy:**
```
createUser authPrivUser SHA "geheim007" AES
rwuser authPrivUser
```

**Belangrijk:** Passphrase minimum 8 characters

### SNMP Tools

**Ubuntu packages:**
- `snmpd`: Agent (daemon)
- `snmp-mibs-downloader`: MIB bestanden downloaden
- `net-snmp-utils`: snmpwalk, snmpget, snmpset
- `tkmib`: MIB browser (GUI)
- `snmptrapd`, `snmptrap`: Trap daemon en handler

**Configuratie:**
- `/etc/snmp/snmpd.conf`
- Service: `systemctl start/stop/status snmpd`

### snmpwalk Opties

**Algemeen:**
- `-v versie`: SNMP versie (1|2c|3)

**Voor SNMPv1/v2c:**
- `-c communitystring`: Bijvoorbeeld `-c public`

**Voor SNMPv3:**
- `-a protocol`: Authenticatie (MD5|SHA)
- `-A passphrase`: Authenticatie passphrase
- `-l level`: Security level (noAuthNoPriv|authNoPriv|authPriv)
- `-u username`: Security name
- `-x protocol`: Privacy protocol (DES|AES)
- `-X passphrase`: Privacy passphrase

### Firewall Configuratie

**Ubuntu/Debian:**
```bash
sudo ufw allow 161/udp
sudo ufw reload
```

**CentOS/Fedora/RedHat:**
```bash
sudo firewall-cmd --permanent --add-port=161/udp
systemctl restart firewalld
```

### SNMP Verificatie

**Service status:**
```bash
systemctl status snmpd
journalctl -a -u snmpd
```

**Poort check (lokaal):**
```bash
sudo lsof -nP -iUDP | grep 161
```

**Poort check (remote - UDP scan!):**
```bash
sudo nmap -sU 192.168.2.1 -p 161
```

---

## HTTP/3 en QUIC

### HTTP Evolutie

#### HTTP/1.1 (Juni 1991)
- Veel parallelle verbindingen
- Elk plaatje = aparte TCP connectie
- Gemiddeld 6 connecties per URL
- "Connectiebom"

#### HTTP/2 (RFC 7540, 2015)
**Voordelen:**
- **Multiplexing**: Parallelle streams over zelfde connectie (max 100)
- Browser maar 1 verbinding voor 6 connecties
- Sneller
- Header compressie bespaart bandbreedte

**Probleem:**
- **TCP Head-of-Line Blocking**
- Als 1 stream blokkeert, blokkeren alle andere ook

#### HTTP/3
**Verbeteringen:**
- Geen TCP head-of-line blocking
- Snellere handshakes
- Snellere data aanvraag (early data)
- Altijd encryptie
- Snellere upgrades (binnen encryptie)

### QUIC (Basis van HTTP/3)

**Wat is QUIC?**
- Geen afkorting, gewoon een naam
- Start 2015 met Google QUIC
- Nieuw transportprotocol
- Betrouwbaar, secure, sneller
- **UDP** in plaats van TCP
- Bewezen dat het werkt

**Waarom UDP?**
- Eerdere pogingen (SCTP) mislukten
- Bestaande infrastructuur werkt alleen met TCP en UDP
- **Reliable transport over UDP in user space**
- UDP is connectionless → QUIC voegt toe:
  - Connecties en streams
  - Hersturen van data
  - Flow control

### TCP vs QUIC Blocking

**TCP (HTTP/2):**
- Als rood blokkeert → groen blokkeert ook
- 1 stream blokkeert hele connectie

**QUIC (HTTP/3):**
- Als blauw blokkeert → geel blokkeert NIET
- Afzonderlijke, onafhankelijke connecties

### QUIC vs TCP Stack

**HTTP/2:**
```
HTTP/2
TLS 1.2+
TCP
IP
```

**HTTP/3:**
```
HTTP/3
QUIC (TLS 1.3 ingebouwd)
UDP
IP
```

### Ossification
- Internet vol "oude machines" (routers, gateways, firewalls)
- Bijna nooit upgrades (wel servers)
- **Ossification** = gebrek aan flexibiliteit om mee te evolueren
- Daarom UDP gekozen (werkt overal)

### QUIC Packet Header Aanpassing

**TCP Header:**
- Source/Destination Port
- Sequence number
- Acknowledgement number
- Flags, Window size
- Checksum, Urgent pointer
- Opties
- Payload (Encrypted)

**UDP Header:**
- Source/Destination Port
- Length, Checksum
- Payload

**QUIC Header:**
- UDP Header
- QUIC (Open): Flags, Connection ID
- QUIC (Encrypted): Packet number, Frame, Ack, Window, Opties
- Payload

### Secure QUIC

**ALTIJD secure:**
- Geen clear-text versie
- TLS ≥ 1.3 verplicht
- HTTPS-achtige beveiliging

**Cipher suites (ALLEEN):**
- TLS_AES_256_GCM_SHA384
- TLS_CHACHA20_POLY1305_SHA256
- TLS_AES_128_GCM_SHA256
- TLS_AES_128_CCM_8_SHA256
- TLS_AES_128_CCM_SHA256

**Geen oude algoritmes (RSA) meer!**

### 0-RTT (Zero Round Trip Time)

**Voordeel:**
- Eerdere sessies hergebruiken (zelfs dag later)
- Direct data sturen zonder handshake
- Zeer snel

**Risico: Replay Attack**
- Geëncrypteerde bankoverschrijving kan opnieuw verstuurd worden

**Bescherming:**
- Alleen voor GET zonder query parameters
- Extra unieke identifier mogelijk

### Minder Vertraging

**HTTP/2 over TCP+TLS:**
- 3-way handshake nodig:
  1. TCP sessie opzetten
  2. TLS sessie met certificaten
  3. HTTP sessie
- **200 ms** (repeat connection)
- **300 ms** (never talked to server)

**HTTP/3 over QUIC:**
- Geen aparte TCP sessie
- Direct TLS
- Early data in handshake
- **0 ms** (repeat connection)
- **100 ms** (never talked to server)

### QUIC Performance

**Bewezen verbeteringen:**
- Traagste 1% connecties winnen **1 seconde**
- **18% minder** buffertijd voor YouTube films
- **75%** van connecties wint door 0-RTT
- **3% sneller** laden Google zoekpagina

### QUIC Handshake

**Stappen:**
1. **Client → Server**: Initial-pakket
   - ClientHello met nonces en crypto parameters

2. **Server → Client**: Initial-pakket
   - ServerHello met nonces en crypto parameters

3. **QUIC handshake**
   - Zoals TLS, maar NIET voor aparte TLS verbinding
   - Update encryptiesleutels

4. **Rest van communicatie**
   - Gecodeerd via QUIC-verbinding

### Connection Migration

**Unieke eigenschap QUIC:**
- Verbindingen krijgen **Connection ID**
- Uniek per sessie
- Verbinding kan lopen over verschillende netwerken
- **Switch van 5G naar WiFi** zonder onderbreking
- Zelfde Connection ID blijft behouden

### HTTP/3 URL
- **Zelfde** als HTTP/2
- Poort **443**
- Zowel QUIC als HTTP/2 mogelijk
- **Alt-Svc** response header wijst door naar QUIC

### HTTP/3 Uitdagingen

1. **Connectie failures**
   - 3-7% van QUIC connecties falen
   - Clients hebben fallback algoritme nodig

2. **CPU intensief**
   - QUIC vraagt meer processing

3. **UDP niet geoptimaliseerd**
   - TLS was gemaakt voor TCP
   - UDP is connectionless

4. **Geen standaard APIs**
   - 15 verschillende implementaties
   - Geen eenheid

5. **User space**
   - Alle QUIC stacks draaien in user land (niet kernel)

### Operators en Monitoring

**Probleem voor operators:**
- Alles geëncrypteerd → bijna niets te volgen
- Geen inzicht in verbindingen

**Spin bit mechanisme:**
- Bit die aangeeft zelfde conversatie
- Beide richtingen: 0 → 1 → 0 → 1
- Operator ziet **klein beetje** dat het zelfde connectie is

**China's oplossing:**
- Eigen CA (Certificate Authority)
- Werken als MITM (Man-In-The-Middle)
- Kunnen alles decrypteren

---

## Suricata (IDS/IPS)

### Wat is Suricata?
- **IDS**: Intrusion Detection System
- **IPS**: Intrusion Prevention System
- Detecteert en voorkomt aanvallen

### Suricata Regels - Syntax

**Voorbeeld:**
```
alert tcp $DMZ1_NET any -> any 80 (msg:"Tentative connexion DMZ1 http";
flow:established,to_server; content:!"|20|yum|2F|";
classtype:web-application-activity; sid:9201503; rev:2;)
```

**Syntax elementen:**
- **Actie**: alert, log, pass, drop
- **Beperkingen**: protocol, source, port, direction, destination, port
- **Meta-settings**: regel naam en parameters

### Detectie Mogelijkheden

**Suricata kan detecteren:**
1. (Her)samenstellen pakketten
2. Cleartext paswoorden of base64 gecodeerd
3. Gebruik van clouds (Dropbox, OneDrive)
4. Gebruik van P2P
5. Malware, Trojans, Virussen
6. Informatie verzameling
7. Brute Force aanvallen

### Configuratie

**Bestanden:**
- `/etc/suricata/suricata.yaml`:
  - Instellen netwerken
  - Instellen regels
- `/etc/suricata/rules`:
  - Regelbestanden
  - Updates door suricata/oinkmaster

**Service beheer:**
```bash
systemctl start/stop/status suricata
```

### Chinese Firewall (The Great Firewall)

**Geblokkeerde services:**
- **Baidu** ipv Google (Maps, Search)
- **QQ/WeChat** ipv Messenger/Discord
  - Blokkeert woorden en afbeeldingen
- **Youku** ipv YouTube
- **Alibaba/Banggood/AliExpress** (populair omdat rest verboden)

**Cisco betrokkenheid:**
- "The Golden Shield Project"
- Public Network Information Security Monitor System

**Doelstellingen:**
- Stop network-related crimes
- Guarantee security of public network
- Combat "Falun Gong" en andere "hostiles"

---

## Belangrijke Examenpunten

### MPLS
- Verschil tussen LER en LSR
- Label structuur (20-3-1-8 bits)
- Label Switched Path opzetten (hop-by-hop vs explicit)
- Bestaande labels per technologie (VPI/VCI, DLCI, timeslot)

### BGP
- AS nummers (privaat vs publiek)
- BGP sessie over TCP poort 179
- Beste pad selectie criteria (volgorde!)
- BGP hijacking principe
- CIDR notatie en voorrang langste prefix

### IPv6
- Adresnotatie en verkorte vorm
- Soorten adressen (Link-Local FE80::/10, Multicast FFxx)
- Autoconfiguratie (stateless vs stateful)
- ICMPv6 types (133/134 voor Router Solicitation/Advertisement)
- Extension headers en functie
- Authenticatie en Encryptie headers

### SNMP
- Protocol poorten (161 request, 162 trap)
- Berichttypen (Get, GetNext, Set, Trap)
- Security niveaus v3 (noAuthNoPriv, authNoPriv, authPriv)
- MIB structuur en OID notatie
- snmpwalk opties per versie

### HTTP/3 en QUIC
- Waarom UDP gekozen (ossification)
- Verschil TCP head-of-line blocking vs QUIC
- 0-RTT principe en replay attack risico
- Connection Migration
- QUIC is ALTIJD secure (TLS 1.3)
- Performance verbeteringen cijfers

### Suricata
- Regel syntax (actie, beperkingen, meta-settings)
- Configuratiebestanden locatie
- Soorten detecties

---
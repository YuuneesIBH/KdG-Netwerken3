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

## 🏷️ MPLS (Multi Protocol Label Switching


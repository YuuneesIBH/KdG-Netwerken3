# Netwerken 3 - Antwoorden "Te Kennen" Vragen

## FIREWALLS

### IP spoofing
Een aanval waarbij een systeem onrechtmatig de identiteit aanneemt van een ander systeem door het overnemen van het IP-adres. Dit wordt verhinderd door anti-spoofing regels op de firewall.

### Source routing
Een mechanisme waarbij je het pad van je pakket vastlegt in de header. Dit zijn gemanipuleerde pakketten die niet luisteren naar de configuratie van je netwerk. Moet geblokkeerd worden: `!ip IN,OUT sourceroute – any any`

### ICMP redirect
ICMP redirect stelt betere routes voor aan een host. Kan misbruikt worden om alle communicatie langs jou te laten lopen door zelf ICMP redirect berichten te sturen.

### Actieve FTP vs Passieve FTP

**Actieve FTP:**
- Client maakt verbinding naar server poort 21 (control)
- Server maakt verbinding naar client vanaf poort 20 (data)
- Probleem: firewall moet poort 20 openstaan voor ALLE hogere poorten
- Beveiligingsrisico: alles vanuit poort 20 mag binnen

**Passieve FTP:**
- Client maakt verbinding naar server poort 21
- Server stuurt random poortnummer door
- Client connecteert naar dat poortnummer voor data
- Veiliger: geen gat in firewall nodig

### Stateful filtering
Filteren van verkeer op basis van informatie van een bepaalde verbinding. De informatie is protocolinformatie van OSI laag 1 tot 4. Houdt status bij van verbindingen in een statustabel.

### Stateful inspection
Gebruikt informatie van stateful filtering + informatie van de commando's op applicatieniveau. Controleert wat wel/niet mag. Al deze informatie samen zorgt ervoor dat één bepaalde verbinding van één bepaalde gebruiker redelijk zeker vastgelegd kan worden.

### RELATED bij FTP (iptables)
RELATED betekent: nieuwe verbinding die te maken heeft met een eerdere ESTABLISHED verbinding.

**Voorbeeld:** Bij actieve FTP moet eerst een controleverbinding opgezet worden (poort 21) alvorens de dataverbinding (poort 20) gemaakt mag worden. Met RELATED los je op dat poort 20 niet voor iedereen openstaat.

```bash
iptables -A INPUT -p tcp -m state --state RELATED -j ACCEPT
```

### ESTABLISHED bij TCP (iptables)
Een eerder opgestarte verbinding (SYN handshake is al gebeurd).

```bash
iptables -A INPUT -p tcp -m state --state ESTABLISHED -j ACCEPT
```

De verbinding is al aangevraagd en opgestart door de client. Er moet dus niet NEW toegestaan worden, enkel ESTABLISHED.

### ESTABLISHED bij UDP (iptables)
UDP heeft geen opstart/stop status zoals TCP, dus kan niet echt stateful zijn. UDP houdt wel source adres/poort en destination adres/poort bij. Op basis hiervan kan er "pseudo-stateful" informatie bijgehouden worden. ESTABLISHED betekent dat er een verbinding actief is, die gesloten wordt na een timeout.

### RELATED bij ICMP (iptables)
RELATED bij ICMP laat foutberichten door die gerelateerd zijn aan een bestaande verbinding. Bijvoorbeeld: je vraagt een website op maar de poort werd geblokkeerd - het ICMP foutbericht mag doorgelaten worden.

### Spoofed FIN/RST pakketten verhinderen
**Probleem:** Met Nemesis spoofed FIN en RST-pakketten naar firewall sturen kan alle interne connecties afsluiten.

**Oplossing:** Stateful firewall gebruiken die:
- Actieve verbindingen bijhoudt met sequence numbers
- Status van elke verbinding controleert
- Timeout in milliseconden voor elke verbinding heeft
- Pakketten dropt die niet tot een actieve verbinding behoren

### Interne vs Externe DNS

**Externe DNS:**
- Voor externe gebruikers
- Publiceert services op internet (publieke IP's)
- Toegankelijk vanaf internet

**Interne DNS:**
- Voor interne gebruikers (medewerkers)
- Publiceert interne webapplicaties
- Geen publiek IP adres, enkel LAN IP's
- Niet bereikbaar vanaf internet

### Red LAN en Blue LAN

**Red LAN (DMZ):**
- Public facing LAN
- Traag (WAN snelheid)
- Servers die van buitenaf toegankelijk moeten zijn

**Blue LAN:**
- Private LAN
- Snel (LAN snelheid)
- Interne gebruikers

**Voordelen:**
- Dubbele bescherming
- Snelheidsverdeling
- Bij inbraak op server komen aanvallers niet aan interne clients

**Nadelen:**
- Extra router nodig (of VLAN configuratie)

---

## DSL, KABEL EN FIBER

### TDM vs STDM

**TDM (Time Division Multiplexing):**
- Elke gebruiker krijgt om de beurt het volledige kanaal
- Ook als er niets verzonden wordt
- Verspilling van bandbreedte

**STDM (Statistical TDM):**
- Kanaal alleen als je het nodig hebt
- Efficiënter gebruik van bandbreedte
- Ongebruikte kanalen worden niet bezet

### QAM modulatie
Quadrature Amplitude Modulation - een combinatie van Amplitude en Fase modulatie. Hierdoor verdubbelt de effectieve bandbreedte. Bij QAM worden zowel amplitude als fase van het signaal aangepast om meer bits per symbool over te brengen.

**Voorbeeld:** QAM-16 heeft 16 verschillende combinaties van amplitude en fase.

### Verschil upstream/downstream
De verbindingen zijn asymmetrisch opgebouwd omdat er veel meer vraag is naar downstream (downloads) dan upstream. Er zijn daarom meer kanalen/bandbreedte toegewezen aan downstream.

**Praktisch:**
- Download: films kijken, websites bezoeken, bestanden downloaden
- Upload: emails versturen, foto's uploaden (minder data)

### Verbetering ruis bij ISP's
Internet Providers hebben nu een **digitale verbinding** met het publieke telefoonnetwerk. Hierdoor moeten er geen D/A of A/D convertors meer toegepast worden, wat resulteert in veel minder ruis.

### Echo cancellation
Bij echo cancellation overlappen de upload en download frequentiebereiken.

**Principe:**
- Signaal op kabel = upload signaal + download signaal
- We kennen ons eigen upload signaal
- Download signaal = totaal signaal - upload signaal

**Voordeel:** Lagere frequentieband kan gebruikt worden voor downstream (minder attenuatie)

**Nadeel:** Moeilijker te implementeren

### A bij ADSL
**Asymmetric** Digital Subscriber Line

Betekent dat er meer bandbreedte voor downstream dan upstream is:
- 26-134 kHz voor upstream
- 134-1000 kHz voor downstream
- Gebruikt FDM (Frequency Division Multiplexing)

### DMT subkanalen
**DMT = Discrete Multi Tone**

Werking:
- 1 MHz spectrum opdelen in 256 kanalen van 4 kHz
- Vóór opstarten van verbinding nakijken welke kanalen optimaal zijn
- Per subkanaal QAM gebruiken
- Elk subkanaal kan optimaal benut worden
- Slechte kanalen kunnen uitgeschakeld worden

### ADSL2+ verbeteringen
1. **Kortere afstand** tot DSLAM (Digital Subscriber Line Access Multiplexer)
2. **Uitbreiding frequentiespectrum** tot 2.2 MHz (was 1 MHz)
3. **Low Power Modus** (kanalen niet altijd actief)
4. **Realtime S/R monitor** (Signaal/Ruis verhouding)
5. **Cross-talk vermijding** op hogere frequenties (1.1-2.2 MHz)

**Resultaat:** 12 Mbps downstream, 3.5 Mbps upstream

### Realtime S/R monitor
Meet **realtime** de Signaal/Ruisverhouding en schakelt zowel ontvanger als zender tegelijk over naar de beste kanalen. Bij ADSL gebeurde dit alleen bij opstart, bij ADSL2+ gebeurt dit continu tijdens de verbinding.

### Aanpassingen kabelnetwerk
1. **Meer glasvezel** naar residentiële gebieden (meer gebruikers + upstream verkeer)
2. **Boomstructuur → Sterstructuur** vanaf residentiële gebieden
3. **Bidirectionele versterkers** (ook upstream versterken)
4. **Bandbreedte uitbreiding**: 540 MHz → 750+ MHz
5. Meer TV-kanalen mogelijk: 83 → 110+

### HFC (Hybrid Fibre Coax)
- **Glasvezel** tot aan de straatkast (node)
- **Coaxkabel** van straatkast tot in huis
- Gemiddeld 290 gezinnen per node in België
- Goedkoper dan fiber tot in huis

### Dispersie en Solitonen

**Dispersie:**
- Verbreding van lichtsignaal over afstand
- Verschillende frequenties gaan elkaar overlappen
- Afhankelijk van golflengte

**Solitonen:**
- Speciale golfvormen die hun vorm behouden over lange afstand
- Oplossing tegen dispersie
- Behouden energie en vorm tijdens transport

### Last mile bij Powerline
**Last mile** = het laatste stukje van de verbinding tot de eindgebruiker.

Bij Powerline is dit letterlijk de laatste stukjes elektriciteitsnet omdat:
- Signaal niet door transformator kan
- Alleen bruikbaar binnen één transformatorgebied
- Typisch binnen een huis of klein gebouw

### Voorbeelden Powerline gebruik
1. **Aansturen straatverlichting**
2. **Doorsturen elektriciteitsmetingen** aan leverancier
3. **Binnenhuisnetwerk** (internet via stopcontact)
4. **Smart home** apparaten aansturen

### Circuit vs Packet Switched

| **Circuit Switched** | **Packet Switched** |
|---|---|
| Fysisch pad tussen bron en destinatie | Geen fysisch pad |
| Alle pakketten gebruiken hetzelfde pad | Pakketten reizen zelfstandig |
| Reserveert vooraf volledige bandbreedte | Reserveert niet |
| Kan bandbreedte verspillen | Efficiënter bandbreedtegebruik |
| Geen store-and-forward | Ondersteunt store-and-forward |
| Vaste vertraging | Variabele vertraging |
| Voorbeeld: Telefoonnetwerk | Voorbeeld: Internet |

---

## IPv6

### Drie soorten IPv6 adressen

1. **Unicast**
   - ID voor één enkele interface
   - Pakket wordt afgeleverd op dit specifieke adres
   - Bijvoorbeeld: 2001:6a8:540::1

2. **Anycast**
   - ID voor verzameling interfaces (meestal verschillende nodes)
   - Pakket wordt afgeleverd bij de dichtstbijzijnde interface
   - Routing protocol bepaalt welke het dichtst is
   - Mag geen bronadres zijn
   - Alleen voor routers, niet voor hosts
   - Bijvoorbeeld: DNS servers, NTP servers

3. **Multicast**
   - ID voor verzameling interfaces
   - Pakket wordt afgeleverd bij ALLE interfaces op dat adres
   - Heeft "scope" veld (link, node, site)
   - Mag geen bronadres zijn
   - Vervangt broadcast uit IPv4
   - Bijvoorbeeld: FF02::1 (alle nodes), FF02::2 (alle routers)

### Waarvoor dienen zones?
Zones lossen het probleem op wanneer je **meerdere interfaces** hebt met hetzelfde link-local adres.

**Probleem:** 
- Interface 1: fe80::1/64
- Interface 2: fe80::2/64  
- Server: fe80::3/64
- Hoe weet de computer via welke interface de server bereikbaar is?

**Oplossing - Zone IDs:**
- Windows: numeriek → `fe80::3%1`
- Linux/BSD: interface naam → `fe80::3%eth0`

### fe80::250:56ff:fec0:8%1 uitleggen

- **fe80:** Link-Local adres (begint altijd met fe80)
- **::** Ongedefinieerd adres / verkort adres met nullen
- **250:56ff:fec0:8:** Het interface ID (vaak afgeleid van MAC-adres via EUI-64)
- **%1:** Zone ID voor Windows (interface nummer 1)

### 169.254.x.x en IPv6 equivalent

**IPv4 - 169.254.x.x:**
- APIPA adres (Automatic Private IP Addressing)
- Automatisch toegewezen als DHCP faalt
- Bereik: 169.254.0.1 tot 169.254.254.254
- Alleen lokale communicatie

**IPv6 equivalent:**
- Link-Local adressen: fe80::/10
- Worden altijd automatisch gegenereerd
- Zelfs als er een globaal adres is
- Gebruikt voor neighbor discovery en lokale communicatie

### Uitbreiden header als voordeel

**IPv4 probleem:**
- Vaste header met opties veld
- Veel lege ruimte of ongebruikte opties
- Alle routers moeten hele header inlezen

**IPv6 voordeel:**
- Basis header altijd 40 bytes
- Optionele extension headers alleen als nodig
- Sneller doorsturen: routers hoeven alleen basis header te lezen
- Extension headers: Hop-by-Hop, Routing, Fragment, Destination Options, Authentication, Encryption

### Time To Live → Hop Limit
TTL bestaat niet meer bij IPv6, het heet nu **Hop Limit**.

**Waarom?**
- Betere naam die beschrijft wat het echt doet
- Het ging nooit over "tijd" maar over aantal hops (routers)
- Functie blijft hetzelfde: aantal routers dat pakket mag passeren

### Te grote pakketten bij IPv4 vs IPv6

**IPv4:**
- Router fragmenteert onderweg
- Router kan pakket droppen als "Don't Fragment" bit is gezet
- Veel overhead voor routers

**IPv6:**
- **Geen fragmentatie onderweg!**
- Bron en doel bepalen zelf de MTU (Path MTU Discovery)
- Fragmentatie alleen door bron
- ICMPv6 "Packet Too Big" bericht terug naar bron
- Bron past pakketgrootte aan
- Minimum MTU: 1280 bytes

### Stateless autoconfiguratie
Host krijgt **geen adres van een server** maar maakt het zelf.

**Proces:**
1. **Router Solicitation (RS)** - ICMPv6 type 133
   - Bron: fe80:: met MAC adres
   - Doel: All routers FF02::2
   
2. **Router Advertisement (RA)** - ICMPv6 type 134
   - Bevat: IP prefix, lifetime, flags
   - Doel: All nodes FF02::1
   
3. **Neighbor Solicitation (NS)** - ICMPv6 type 135
   - Test of MAC adres uniek is (DAD - Duplicate Address Detection)
   
4. **Neighbor Advertisement (NA)** - ICMPv6 type 136
   - Als andere host zelfde MAC heeft, meldt deze zich

Host combineert prefix van router met eigen interface ID (EUI-64 van MAC).

### Stateful autoconfiguratie
Host krijgt adres **van DHCPv6 server**.

**Proces:**
1. UDP multicast naar **poort 547** (DHCPv6 servers)
   - Bron: link-local fe80::MAC, UDP poort 546
   - Doel: All DHCP servers FF02::1:2
   
2. DHCPv6 server stuurt terug:
   - 128-bit IPv6 adres
   - Lifetime
   - DNS servers
   - Andere configuratie

**Wanneer gebruiken?**
- M-bit in Router Advertisement = 1 (Managed flag)
- Volledige configuratie via DHCPv6

### Mobiele autoconfiguratie
Voor GSM/mobiele toestellen met **handovers**.

**Werking:**
1. GSM krijgt **vast IPv6 adres** van thuisbasis (Home Agent)
2. Bij verplaatsing: **tijdelijk adres** op nieuwe locatie
3. GSM stuurt **binding** naar Home Agent:
   - Koppeling tijdelijk ↔ vast adres
4. Home Agent fungeert als **router**
5. Tijdelijk adres kan tijdens gesprek veranderen
6. Gesprek blijft actief via Home Agent

**Vergelijk met:** Mobile IP

### 5 belangrijkste wijzigingen IPv4 → IPv6

1. **Uitbreiding adresseringsmogelijkheid**
   - 32 bit → 128 bit
   - 4.3 miljard → 340 undeciljoen adressen
   - Hiërarchische structuur

2. **Vereenvoudiging header**
   - Vaste 40 bytes (was variabel)
   - Minder velden (12 → 8)
   - Sneller te verwerken door routers

3. **Betere ondersteuning voor uitbreidingen**
   - Extension headers alleen als nodig
   - Flexibeler dan IPv4 options
   - Niet alle routers hoeven te lezen

4. **Mogelijkheid tot labelen van stroom**
   - Flow Label veld (20 bits)
   - QoS (Quality of Service)
   - Realtime toepassingen (VoIP, video)

5. **Authenticatie en Privacy ingebouwd**
   - IPsec verplicht (bij IPv4 optioneel)
   - Authentication Header
   - Encapsulating Security Payload
   - Veiligheid standaard

---

## PROXY

### HIT en MISS

**HIT:**
- Proxy vindt pagina terug in disk cache
- Pagina wordt direct vanuit cache geleverd
- Sneller, geen internet verkeer
- Vermindert bandbreedte gebruik

**MISS:**
- Pagina staat niet in cache
- Proxy moet pagina ophalen van internet
- Langzamer, genereert internet verkeer
- Pagina wordt opgeslagen in cache voor volgende keer

### 3 voorbeelden TTL bij proxy

1. **DNS cache TTL**
   - Hoelang DNS queries gecached worden
   - Bijvoorbeeld: 2 uur voor www adressen

2. **Content cache TTL**
   - Hoelang webpagina's/bestanden gecached blijven
   - Bijvoorbeeld: 7 dagen voor gif/jpg files
   - Bijvoorbeeld: 30 minuten voor cgi-bin

3. **Authenticatie TTL**
   - Hoelang gebruiker blijft ingelogd
   - Hoelang credentials geldig blijven
   - Bijvoorbeeld: 8 uur voor een werkdag

### SOCKS gebruik
SOCKS laat toe dat hosts aan de ene kant van de proxy **volledige toegang** krijgen tot hosts aan de andere kant.

**Functie:**
- SOCKS server voorziet authenticatie (username/password)
- Stuurt data door tussen client en server
- Werkt als firewall die interne hosts beschermt

**Gebruikt door:**
- Putty (SSH client)
- Telnet
- Browsers kunnen SOCKS ondersteunen
- Algemene TCP/UDP applicaties

**Versies:**
- SOCKSv4: geen UDP, geen authenticatie, geen DNS
- SOCKSv5: wel UDP, authenticatie, DNS
- SOCKSv6: snelheidsverbeteringen (TFO, 0-RTT)

### ICP functie
**ICP = Internet Cache Protocol**

Communicatie tussen proxy servers onderling (hierarchische/cascading proxies).

**Voordelen:**
- Aanvraag via verschillende proxies (werk verdelen)
- **Snelste proxy** geeft antwoord
- Detecteert slecht ingestelde proxies
- Detecteert niet-werkende proxies

**Begrippen:**
- **Neighbour:** proxy die samenwerkt met jouw proxy
- **Parent:** proxy op hoger niveau

---

## 2G/3G

### TDMA
**Time Division Multiple Access** - biedt digitale draadloze diensten met TDM.
- Meerdere gebruikers delen zelfde frequentie
- Elk krijgt een tijdslot
- Gebruikt bij GSM

### CDMA
**Code Division Multiple Access** - gebruikt spread-spectrum technieken.
- Geen specifieke frequentie per gebruiker
- Elk kanaal gebruikt volledig spectrum
- Gesprekken worden gecodeerd met unieke codes
- Gebruikt bij 3G (UMTS)

### HLR
**Home Location Register** - centrale database van operator.
- Bevat alle abonnees van operator
- Telefoonnummer + abonnementsopties
- Huidige locatie van GSM
- Permanent opgeslagen

### VLR
**Visited Location Register** - lokale database per gebied.
- Bevat alle abonnees binnen het gebied
- Tijdelijke registratie als GSM in gebied is
- Info wordt gestuurd naar/van HLR
- Gebruikt voor snellere oproepopbouw

### Handovers

**Soft handover:**
- Overschakelen naar ander basisstation
- Binnen eigen systeem/operator
- Maakt eerst nieuwe verbinding, dan pas oude verbreken
- "Make before break"
- Gebruikt bij CDMA/UMTS

**Softer handover:**
- Blijven op zelfde basisstation
- Overschakelen naar andere frequentie
- Wanneer storing op bepaalde frequentie
- Nog soepeler dan soft

**Hard handover:**
- Overschakelen naar nieuwe sector/cel
- Op andere frequentie
- Eerst oude verbinding verbreken, dan nieuwe maken
- "Break before make"
- Korte onderbreking mogelijk
- Gebruikt bij GSM

### Bellen in buitenland - locatie

**Proces:**
1. Je GSM meldt zich aan bij lokale VLR
2. VLR stuurt info naar jouw HLR (in België)
3. HLR stuurt jouw gegevens terug naar VLR
4. Iemand belt jouw Belgisch nummer
5. Belgische MSC (Mobile Switching Center) vraagt HLR
6. HLR weet dat je in buitenland bent (VLR locatie)
7. Oproep wordt doorgestuurd naar buitenlandse MSC
8. Buitenlandse MSC contacteert jouw GSM

### Tromboning
**Probleem:** Inefficiënte routering van gesprekken.

**Voorbeeld:**
- Je bent in NYC
- Belt naar iemand anders in NYC
- Signaal gaat: NYC → België (HLR) → NYC
- Extra vertraging en kosten

**Oplossing:**
- Optimized call routing
- Lokale MSC kan direct verbinden
- Niet meer via HLR in thuisland

### Zwakheden GSM beveiliging

1. **Valse basisstations** (fake base stations)
   - Aanvaller kan zich voordoen als basisstation
   - GSM verbindt met sterkste signaal

2. **Sleutels cleartext doorgestuurd**
   - Tussen en binnen netwerken
   - Kunnen onderschept worden

3. **Microwave links onbeschermd**
   - Verbindingen tussen basisstations en MSC
   - Kunnen afgeluisterd worden

4. **A5/1 en A5/2 encryptie gekraakt**
   - Relatief zwakke algoritmes
   - Kunnen met moderne computers gekraakt worden

5. **64-bit sleutels te kort**
   - Tegenwoordig onvoldoende
   - Brute force mogelijk

**Oplossingen:**
- Geen A5/2 meer ondersteunen
- Nieuwe sleutel per verbinding
- A5/3 of A3/A8 gebruiken
- 3G/4G met sterkere encryptie

### WAP aanpassing aan GSM
Voor **WAP** (Wireless Application Protocol) moesten volgende componenten toegevoegd:

1. **SMS controller bij MSC**
2. **SGSN** (Serving GPRS Support Node)
   - Beheert data verkeer van mobiele gebruikers
3. **GGSN** (Gateway GPRS Support Node)
   - Koppelt naar internet/externe netwerken

### GPRS sneller dan GSM

**GPRS = General Packet Radio Service**

Sneller omdat:
1. **Packet switched** ipv circuit switched
   - Alleen data versturen als nodig
   - Efficiënter gebruik van kanalen

2. **Meerdere tijdslots tegelijk**
   - GSM: 1 tijdslot (9.6 kbps)
   - GPRS: tot 8 tijdslots (theoretisch 171 kbps)

3. **Betere modulatie**
   - Efficiënter gebruik van bandbreedte

4. **Always-on verbinding**
   - Geen opbouwen van verbinding telkens

### GPRS nadelen

1. **Beperkte celcapaciteit**
   - Alle gebruikers delen beschikbare tijdslots
   - Bij veel gebruikers: lagere snelheid per persoon

2. **Praktische snelheid beperkt tot ~40 kbps**
   - Theoretisch: 171 kbps
   - Realiteit: veel lager door overhead en delen

3. **Verschillende modulatie dan 3G**
   - GPRS: GMSK (Gaussian Minimum Shift Keying)
   - UMTS: 8-PSK (8 Phase Shift Keying)
   - Niet compatibel

4. **Potentiële delay**
   - Bij veel verkeer
   - Best-effort service

5. **Geen QoS garanties**
   - Ongeschikt voor realtime toepassingen

---

## 3G

### UMTS FDD vs TDD

**FDD (Frequency Division Duplex):**
- Voor grote en overlappende gebieden
- Macro en micro cellen
- Data tot 384 kbps bij hoge mobiliteit
- Aparte frequenties voor up/downstream
- Meest gebruikt

**TDD (Time Division Duplex):**
- Voor "hot spot" scenario's
- Kleine cellen
- Efficiënter bij asymmetrisch verkeer
- Data tot 2 Mbps
- Zelfde frequentie voor up/down (verschillende tijdslots)

### UMTS sneller dan GPRS
UMTS gebruikt **CDMA** (Code Division Multiple Access).

**Voordelen:**
- Volledige spectrum voor elke gebruiker
- Hogere datasnelheden (tot 2 Mbps)
- Betere spectrale efficiëntie
- Minder interferentie
- Betere capaciteit

### CDMA spreading en despreading

**Spreading:**
- Origineel signaal wordt "verspreid" over breed spectrum
- Unieke spreidingscode per gebruiker
- Signaal komt onder ruisniveau
- Lijkt op ruis voor anderen

**Despreading:**
- Ontvanger gebruikt correlator
- Herkent alleen signaal met juiste code
- Haalt origineel signaal terug uit "ruis"
- Andere gebruikers blijven ruis

**Voordeel:** Meerdere gebruikers tegelijk op zelfde frequentie.

### OFDM werking
**Orthogonal Frequency-Division Multiplexing**

1. Spectrum opdelen in **subkanalen**
2. Op elk subkanaal: PSK of QAM modulatie
3. Data **parallel** versturen over subkanalen
4. Frequenties orthogonaal gekozen
   - Voorkomt cross-talk tussen subkanalen
   - Subkanalen kunnen overlappen zonder interferentie

**Voordelen:**
- Beste signaal per frequentie
- Minder last van multipath fading
- Efficiënt spectrumgebruik
- Gebruikt bij 4G/5G

### Power Control belangrijk bij UMTS

**Near-far probleem:**
- Toestel dicht bij basisstation → sterk signaal
- Toestel ver weg → zwak signaal
- Sterk signaal overstemt zwak signaal

**Power control oplossing:**
- Dichtbij: zend met **lager vermogen**
- Ver weg: zend met **hoger vermogen**
- Alle signalen komen ongeveer even sterk aan bij basisstation

**Voordelen:**
1. Minder batterijverbruik (dichtbij station)
2. Minder straling (gezondheid)
3. Minder interferentie
4. Meer capaciteit in cel

### Soft vs Softer handover

**Soft handover:**
- Overschakelen naar **ander basisstation**
- Binnen hetzelfde netwerk/operator
- "Make before break" (eerst nieuwe, dan oude verbreken)
- Gebruikt bij UMTS/CDMA
- Soepele overgang zonder onderbreking

**Softer handover:**
- Blijven bij **zelfde basisstation**
- Overschakelen naar **andere frequentie**
- Wanneer storing op huidige frequentie
- Nog soepeler dan soft handover
- Minimale onderbreking

### Cell breathing
Mechanisme bij CDMA-netwerken.

**Principe:**
- Overbelaste cel kan verkeer "uitademen"
- Geografisch bereik van cel wordt **kleiner**
- Gebruikers aan rand van cel worden overgedragen naar naburige cellen
- Bij weinig verkeer: cel "inademt" → groter bereik

**Vergelijk met:** Een ballon die opblaast en leegloopt.

### Rake receiver
Radio-ontvanger voor multipath fading.

**Probleem:** Signaal komt via meerdere paden aan (reflecties).

**Oplossing:**
- Meerdere "sub-ontvangers" = **fingers**
- Elke finger is correlator voor één multipath component
- Elk pad wordt apart ontvangen
- Signalen worden gecombineerd
- Sterkere totaal signaal

**Resultaat:** Multipath wordt voordeel ipv nadeel.

---

## 4G-5G

### HARQ (Hybrid ARQ)
**Hybrid Automatic Repeat Request**

Klassiek ARQ: vraagt hertransmissie bij fout.

**HARQ innovatie:**
- Onthoudt ook **foutieve pakketten**
- Vraagt hertransmissie
- Combineert oude + nieuwe pakket
- Forward Error Correction (FEC) + ARQ
- Hogere slaagkans met minder hertransmissies

**Voordeel:** Sneller en efficiënter dan gewone ARQ.

### Beamforming
Techniek om draadloos signaal te **richten** naar specifieke gebruiker.

**Werking:**
- Meerdere antennes (MIMO)
- Signalen worden gefaseerd
- Constructieve interferentie in gewenste richting
- Destructieve interferentie in andere richtingen
- Dynamische aanpassing aan beweging gebruiker

**Voordelen:**
1. Sterker signaal bij ontvanger
2. Minder interferentie
3. Hogere datasnelheid
4. Groter bereik
5. Meer capaciteit in cel

### Dual Mode GSM's
Toestellen die **twee verschillende systemen** ondersteunen.

**Voorbeelden:**
- GSM + UMTS (2G + 3G)
- UMTS + LTE (3G + 4G)
- LTE + 5G NR (4G + 5G)

**Voordeel:** Automatisch omschakelen naar beste beschikbare netwerk.

---

## ATM

### ATM cel header
**ATM cel = 53 bytes:** 5 bytes header + 48 bytes payload

**Header bevat:**
1. **GFC** (4 bits) - General Flow Control
   - Niet gebruikt in praktijk
   
2. **VPI** (8 bits UNI / 12 bits NNI) - Virtual Path Identifier
   - Identificeert virtueel pad
   
3. **VCI** (16 bits) - Virtual Channel Identifier
   - Identificeert virtueel kanaal binnen pad
   
4. **PTI** (3 bits) - Payload Type Identifier
   - Data of controle verkeer
   - Congestie indicatie
   
5. **CLP** (1 bit) - Cell Loss Priority
   - 0 = hoge prioriteit
   - 1 = mag weggegooid bij congestie
   
6. **HEC** (8 bits) - Header Error Check
   - Foutdetectie en correctie

### UNI vs NNI

**UNI (User-Network Interface):**
- Rand van netwerk
- Tussen eindgebruiker en ATM switch
- 8 bits voor VPI (256 paden)
- Meer bits beschikbaar voor applicaties

**NNI (Network-Network Interface):**
- Binnen ATM netwerk
- Tussen ATM switches onderling
- 12 bits voor VPI (4096 paden)
- Meer paden nodig binnen netwerk

**Verschil nodig omdat:**
- Netwerk heeft meer routering nodig
- Eindgebruiker heeft minder paden nodig
- Optimale verdeling van bits

### ATM Adaptation Layers (AAL)

**AAL 1:**
- Circuit emulation
- Constante bitrate (CBR)
- Gebruikt voor: spraak (telefonie)
- Timing recovery

**AAL 2:**
- Variabele bitrate (VBR)
- Gebruikt voor: compressed voice, video
- Kan meerdere VCs in één cel

**AAL 3/4:**
- Data transfer
- Connectionless of connection-oriented
- Error detection
- Niet veel gebruikt (te veel overhead)

**AAL 5:**
- LAN verkeer
- "SEAL" - Simple and Efficient Adaptation Layer
- Minimale overhead
- Gebruikt voor: IP over ATM, Frame Relay over ATM
- Meest gebruikt voor data

### Waarom ATM niet meer populair?

1. **Complexiteit**
   - Moeilijk te configureren
   - Veel expertise nodig

2. **Duur**
   - Hardware zeer kostelijk
   - Implementatie duur

3. **Vaste celgrootte (53 bytes)**
   - Veel overhead voor kleine pakketten
   - Inefficiënt voor variabele data

4. **Opkomst Ethernet**
   - Gigabit/10G Ethernet goedkoper
   - Eenvoudiger te beheren
   - Vergelijkbare prestaties

5. **MPLS alternatief**
   - Kan QoS bieden
   - Werkt op bestaande infrastructuur
   - Flexibeler

6. **Packet switching won**
   - Internet groei met IP
   - Minder vraag naar circuit-oriented

---

## BGP

### AS nummer kiezen?

**Privaat:** JA, je mag kiezen tussen **64512 - 65535**
- Voor intern gebruik
- Niet op internet

**Publiek:** NEE, je moet aanvragen bij:
- IANA (Internet Assigned Numbers Authority)
- Via Regional Internet Registry (RIR):
  - RIPE NCC (Europa)
  - ARIN (Noord-Amerika)
  - APNIC (Azië-Pacific)
  - LACNIC (Latijns-Amerika)
  - AfriNIC (Afrika)

**Formaat:**
- Oorspronkelijk 16-bit (0-65535)
- Sinds 2007 ook 32-bit (4-byte ASN)

### CIDR voordeel
**CIDR = Classless Inter-Domain Routing**

**Voordelen:**

1. **Efficiënter gebruik IP adressen**
   - Niet gebonden aan klasse A/B/C
   - Kan precies juiste aantal toewijzen
   - Minder verspilling

2. **Kleinere routing tabellen**
   - Route aggregatie mogelijk
   - Meerdere netwerken in één route
   - Bijvoorbeeld: 192.168.0.0/22 ipv vier /24's

3. **Supernetting**
   - Combineren van netwerken
   - Vermindert routing entries

4. **Subnetting flexibility**
   - VLSM mogelijk (Variable Length Subnet Mask)
   - Aangepaste subnet groottes

**Voorbeeld:**
- Zonder CIDR: 192.168.1.0/24, 192.168.2.0/24, 192.168.3.0/24
- Met CIDR: 192.168.0.0/22 (alle drie in één route)

### BGP netwerk selectie
BGP neemt een netwerk op in zijn tabel op basis van:

1. **AS_PATH analyse**
   - Routes met korter AS pad krijgen voorrang
   - Vermijdt loops (eigen AS niet in pad)

2. **Prefix length**
   - Langste prefix match wint
   - 10.10.10.0/24 > 10.0.0.0/8

3. **MULTI_EXIT_DISC**
   - Tussen zelfde AS paren
   - Lagere waarde = betere route

4. **eBGP vs iBGP**
   - Externe routes > interne routes

5. **BGP ID**
   - Bij gelijke routes: laagste router ID wint

6. **Manual weights** (lokaal)
   - Hoogste weight wint

### BGP misbruik voor verkeer onderscheppen

**Methoden:**

1. **Prefix Hijacking**
   - Adverteren van prefix die jou niet toebehoort
   - Met specifiekere prefix (langere /24 ipv /22)
   - Verkeer wordt naar jou gerouted
   - Voorbeeld: Pakistan vs YouTube (2008)

2. **AS Path Manipulation**
   - Shorter path adverteren dan werkelijk
   - Door AS nummers weg te laten
   - Of fictieve shorter path aan te maken

3. **BGP Route Injection**
   - Valse BGP updates injecteren
   - Man-in-the-middle tussen AS's

**Gevolgen:**
- Alle verkeer via aanvaller
- Aanvaller kan:
  - Data lezen
  - Data aanpassen
  - TTL aanpassen om detectie te voorkomen
  - Services blokkeren

**Verdediging:**
- RPKI (Resource Public Key Infrastructure)
- BGPsec (route origin validation)
- Filtering van onwaarschijnlijke routes

---

## FRAME RELAY

### Circuit vs Packet Switched Network

| **Aspect** | **Circuit Switched** | **Packet Switched** |
|---|---|---|
| **Verbinding** | Fysisch pad gereserveerd | Geen vast pad |
| **Setup** | Setup tijd nodig | Geen setup |
| **Routing** | Alle data via zelfde route | Elk pakket eigen route |
| **Bandbreedte** | Volledig gereserveerd | Gedeeld, on-demand |
| **Efficiency** | Kan verspild worden | Efficiënter gebruikt |
| **Delay** | Constant | Variabel |
| **Volgorde** | Gegarandeerd | Kan verschillen |
| **Geschikt voor** | Spraak, video | Data, internet |
| **Voorbeeld** | Telefoonnetwerk, ISDN | Internet, Frame Relay |

### X.25 vs Frame Relay

| **X.25** | **Frame Relay** |
|---|---|
| Veel error checking | Minimale error checking |
| Hertransmissie op elke hop | Geen hertransmissie |
| Sliding windows | Vereenvoudigd |
| Laag 1, 2 én 3 | Alleen laag 1 en 2 |
| Langzamer | Sneller |
| Voor analoge lijnen | Voor digitale lijnen |
| Betrouwbaar over slechte lijnen | Vertrouwt op goede verbinding |

### LAP-B vs LAP-F

**LAP-B (X.25):**
- Link Access Procedure, Balanced
- Uitgebreide foutcontrole
- Hertransmissie per hop
- Sliding window flow control
- Acknowledgments
- Meer overhead

**LAP-F (Frame Relay):**
- Link Access Procedure for Frame Relay
- Minimale foutcontrole
- Alleen CRC check
- Geen hertransmissie
- Minder overhead
- Sneller maar minder robuust

### LMI gebruik
**LMI = Local Management Interface**

Ontwikkeld door "Gang of Four" (Cisco, DEC, Northern Telecom, StrataCom).

**Functies:**

1. **Status informatie**
   - Welke PVC's zijn actief
   - Welke zijn down
   - Netwerk status updates

2. **Globale adressering**
   - DLCI's niet alleen lokaal
   - Uniek binnen netwerk

3. **Flow control**
   - Congestie notificatie
   - FECN/BECN bits

4. **Keepalive berichten**
   - Controleren verbinding actief
   - Tussen DTE en DCE

5. **Multicasting**
   - Ondersteuning multicast groepen

**Types:**
- Cisco (Cisco proprietary)
- ANSI (American National Standards Institute)
- Q933a (ITU standard)

### Frame Relay vs ATM

| **Frame Relay** | **ATM** |
|---|---|
| Variabele pakketgrootte | Vaste celgrootte (53 bytes) |
| 64 Kbps - 40 Mbps | 1.5 Mbps - 622+ Mbps |
| Geen standaard QoS | QoS met verschillende klassen |
| Eenvoudiger | Complexer |
| Goedkoper | Duurder |
| Meer ondersteund | Minder verspreid |
| Laag 2 | Laag 1/2 |
| Voor WAN edge | Voor WAN core |
| CIR (Committed Info Rate) | Peak Cell Rate, QoS |

---

## MPLS

### Label Substitution
Het proces waarbij een MPLS router een **inkomend label vervangt** door een **uitgaand label**.

**Proces:**
1. Pakket komt aan met label X
2. Router kijkt in forwarding tabel
3. Vervangt label X door label Y
4. Stuurt pakket door naar volgende hop
5. Volgende router doet hetzelfde

**Vergelijk met:**
- ATM: VPI/VCI switching
- Frame Relay: DLCI switching

**Voordeel:** Snel, simpele tabel lookup.

### MPLS labels bij ATM/Frame Relay

**Hergebruik bestaande labels:**

1. **ATM:** VPI/VCI **IS** het MPLS label
   - Geen extra header nodig
   - Native ATM switching

2. **Frame Relay:** DLCI **IS** het MPLS label
   - Gebruikt bestaande DLCI veld
   - Geen extra overhead

3. **Ethernet/PPP:** "Shim" header
   - 32-bit label tussen laag 2 en 3
   - Nieuwe header toegevoegd

**Voordeel:** MPLS werkt op bestaande infrastructuur zonder hardware wijzigingen.

### MPLS labels doorsturen
Labels worden doorgestuurd via:

1. **Label Distribution Protocol (LDP)**
   - IETF standaard protocol
   - Specifiek voor MPLS
   - Distribueert labels tussen routers
   - Bouwt forwarding tabellen op

2. **BGP met piggybacking**
   - Labels meeliften op BGP updates
   - Uitbreiding van BGP protocol
   - Efficiënt voor VPN's

3. **RSVP-TE** (Traffic Engineering)
   - Voor expliciete paths
   - QoS garanties

**Proces:**
- LSR's wisselen labels uit
- Bouwen Label Forwarding Table
- Elke LSR weet: inkomend label → uitgaand label + interface

### 2 manieren LSP opzetten

**1. Hop-by-Hop Routing**
- Elke LSR kiest zelf de volgende hop
- Gebruikt bestaande routing protocollen (OSPF, IS-IS)
- Automatisch, gedistribueerd
- Eenvoudiger te configureren
- Minder controle over pad

**2. Explicit Routing (Source Routing)**
- Ingress router bepaalt volledig pad
- Lijst van nodes in volgorde
- RSVP-TE gebruikt voor signaling
- Meer controle over pad
- Traffic Engineering mogelijk
- Kan QoS garanties bieden

**Opmerking:** LSP is **unidirectioneel** - terugverkeer krijgt apart LSP!

### LER vs LSR

**LER (Label Edge Router):**
- Aan **rand** van MPLS netwerk
- Voegt labels toe (ingress)
- Verwijdert labels (egress)
- Ondersteunt meerdere interfaces:
  - Frame Relay
  - ATM
  - Ethernet
  - PPP
- Classificeert verkeer in FEC's

**LSR (Label Switch Router):**
- In **core** van MPLS netwerk
- Switcht pakketten obv labels
- Label substitution
- Hoge snelheid
- ATM switches kunnen LSR zijn zonder hardware wijzigingen

---

## VOIP

### SIP functie
**SIP = Session Initiation Protocol**

**Functies:**

1. **User Location**
   - Vinden waar gebruiker is
   - Device discovery

2. **User Availability**
   - Is gebruiker beschikbaar
   - Status checking

3. **User Capabilities**
   - Welke codecs worden ondersteund
   - Media types negotiëren

4. **Session Setup**
   - Opzetten van gesprek
   - Parameters afspreken

5. **Session Management**
   - Transfer, hold, conference
   - Modificeren tijdens gesprek

**Protocol:**
- Tekstgebaseerd (zoals HTTP)
- Poort 5060 (UDP/TCP)
- Poort 5061 (TLS encrypted)

### ENUM werking
**ENUM = tElephone NUmber Mapping**

Vertaalt **telefoonnummers** naar **internet adressen**.

**Proces:**

1. Telefoonnummer: +32 3 641 82 11
2. Omzetten naar ENUM formaat:
   - 1.1.2.8.1.4.6.3.2.3.e164.arpa
   - (omgekeerde volgorde + e164.arpa)
3. DNS lookup (NAPTR record)
4. Resultaat: SIP URI
   - sip:user@domain.com
   - mailto:user@domain.com
   - h323:user@gateway.com

**Voordeel:** Gewone telefoonnummers gebruiken voor VoIP.

### NAT/PAT probleem oplossen voor VoIP

**Problemen:**
- SIP headers bevatten IP adressen
- RTP streams moeten direct bereikbaar zijn
- NAT herschrijft pakketten verkeerd

**Oplossingen:**

1. **STUN** (Session Traversal Utilities for NAT)
   - Client ontdekt extern IP/poort
   - Stuurt dit in SIP berichten
   - Voor symmetric NAT werkt dit niet

2. **TURN** (Traversal Using Relays around NAT)
   - Relay server in publiek netwerk
   - Al verkeer via deze server
   - Werkt altijd maar meer overhead

3. **ICE** (Interactive Connectivity Establishment)
   - Combineert STUN + TURN
   - Probeert beste methode
   - Moderne standaard

4. **ALG** (Application Layer Gateway)
   - NAT router begrijpt SIP
   - Herschrijft IP's in SIP headers
   - Niet altijd betrouwbaar

5. **VPN**
   - Tunnel naar bedrijfsnetwerk
   - Geen NAT problemen

### Skype door firewall

**Skype gebruikte:**

1. **SuperNodes**
   - Clients met publiek IP
   - Fungeren als relay
   - Skype verkeer gaat via hen

2. **Port 80 en 443**
   - HTTP/HTTPS poorten
   - Meestal open in firewall
   - Vermomd als web verkeer

3. **UDP hole punching**
   - Simultaan verbindingen opzetten
   - Direct P2P waar mogelijk

4. **Proprietary protocol**
   - Versleuteld en obfuscated
   - Moeilijk te blokkeren

5. **Multiple fallbacks**
   - Probeert verschillende methodes
   - Altijd een manier vinden

**Modern (Microsoft Skype):**
- Meer via centrale servers
- Minder P2P
- Makkelijker te beheren

### VoIP gesprek starten

**SIP call flow:**

1. **Caller** → SIP INVITE → **SIP Proxy/Server**
   - Bevat: caller ID, codecs, IP/poort voor RTP

2. **SIP Proxy** → DNS/location lookup
   - Waar is callee?

3. **SIP Proxy** → INVITE → **Callee**
   - Doorsturen invite

4. **Callee** → 180 Ringing → **Caller**
   - Telefoon gaat over

5. **Callee** neemt op → **200 OK** → **Caller**
   - Bevat: codecs, IP/poort voor RTP

6. **Caller** → ACK → **Callee**
   - Bevestiging

7. **RTP streams** (direct tussen caller en callee)
   - Media (spraak) gaat NIET via SIP server
   - Direct peer-to-peer voor efficiency

8. Einde gesprek → BYE → 200 OK

---

## WIRELESS

### Wireless roaming werking

**802.11 roaming proces (4 stappen):**

1. **Disassociatie**
   - Verbreken verbinding met huidige AP
   - Signaal wordt te zwak

2. **Scanning**
   - Passief: luisteren naar beacons
   - Actief: probe requests sturen
   - Zoeken naar APs op alle kanalen
   - Meten signaalsterkte

3. **Re-associatie**
   - Verbinden met nieuwe AP (sterkste signaal)
   - Authentication handshake
   - Nieuwe associatie opbouwen

4. **Authenticatie**
   - WPA2/WPA3 handshake
   - Keys uitwisselen

**Kenmerken:**
- "Break before make" volgorde
- Korte onderbreking mogelijk
- Nomadic roaming (niet seamless zoals GSM)
- Laag 2 proces (IP adres blijft gelijk binnen subnet)

### 802.11ac vs 802.11n verschillen

**802.11ac verbeteringen (Wi-Fi 5):**

1. **Alleen 5 GHz band**
   - Geen 2.4 GHz
   - Minder interferentie
   - Meer kanalen beschikbaar

2. **256-QAM modulatie**
   - Was 64-QAM bij 11n
   - Hogere datasnelheid per stream

3. **Bredere kanalen**
   - 80 MHz standaard
   - Optioneel 160 MHz
   - Was 40 MHz bij 11n

4. **Meer MIMO streams**
   - Tot 8 spatial streams
   - Was 4 bij 11n
   - MU-MIMO (Multi-User)

5. **Beamforming standaard**
   - Verbeterde richting signalen
   - Betere range en snelheid

6. **Gigabit snelheden**
   - Theoretisch tot 6.93 Gbps
   - Praktisch 1-3 Gbps

**Resultaat:** 3x sneller dan 802.11n in praktijk.

---

## WIRELESS SECURITY

### WEP nadelen

1. **Zwakke RC4 implementatie**
   - 24-bit IV (Initialization Vector) te kort
   - IV's worden hergebruikt (binnen paar uur)
   - Fluhrer-Mantin-Shamir aanval

2. **Geen key management**
   - Statische keys
   - Moeilijk te wijzigen
   - Gedeeld tussen alle gebruikers

3. **CRC32 checksum zwak**
   - Niet cryptografisch veilig
   - Bit-flipping attacks mogelijk
   - Kan aangepast worden zonder detectie

4. **Authentication zwak**
   - Shared key authentication via challenge-response
   - Challenge kan gesnifd worden
   - Key kan afgeleid worden

5. **Snel te kraken**
   - Met tools zoals aircrack-ng
   - Binnen minuten met voldoende packets
   - Passieve aanvallen mogelijk

**Conclusie:** WEP is **volledig onveilig** en mag niet meer gebruikt worden!

### Michael (MIC)

**Michael = Message Integrity Code**

- Onderdeel van **TKIP** (WPA)
- Vervangt zwakke CRC32 van WEP
- Detecteert tampering (aanpassing) van packets

**Werking:**
- Toevoegen van 8-byte MIC aan elk frame
- Berekend over data + MAC adressen
- Beschermt tegen bit-flipping

**Zwakheid:**
- Relatief zwak (64-bit)
- Beck-Tews attack (2008) kan het kraken
- Voor ARP packets vooral kwetsbaar

**Countermeasure:**
- Bij detectie van 2 valse MIC's in 1 minuut:
  - Netwerk wordt 60 seconden geblokkeerd
  - Alle verbindingen verbroken
  - Nieuwe keys gegenereerd

### KdG wireless netwerk

**Configuratie:**

1. **WPA2-Enterprise**
   - Niet PSK (Pre-Shared Key)
   - Centraal gebruikersbeheer

2. **AES-CCMP encryptie**
   - Sterkste encryptie
   - Geen TKIP

3. **PEAP v0**
   - Protected EAP
   - TLS tunnel voor authenticatie

4. **MS-CHAPv2**
   - Microsoft Challenge Handshake Authentication Protocol
   - Binnen PEAP tunnel

5. **Server certificaat**
   - Voor TLS tunnel
   - Valideren authenticatie server
   - Bescherming tegen fake AP's

6. **RADIUS server**
   - Central Authentication
   - Via KdG credentials
   - Logging van verbindingen

### RADIUS server functie

**RADIUS = Remote Authentication Dial-In User Service**

**Functies:**

1. **Authentication (AAA)**
   - Controleert username/password
   - Certificaten valideren
   - Diverse authenticatie methodes

2. **Authorization**
   - Bepaalt wat gebruiker mag
   - VLAN toewijzing
   - Bandwidth limits
   - Toegangsregels

3. **Accounting**
   - Logging van sessies
   - Start/stop tijd
   - Data gebruik
   - Billing informatie

**VoIP context:**
- AP stuurt credentials naar RADIUS
- RADIUS controleert en stuurt encryptie keys terug
- Keys voor secure verbinding tussen client en AP
- Geen data zonder geldige key

**Poorten:**
- UDP 1812 (Authentication)
- UDP 1813 (Accounting)

---

## RFID

### RFID nadelen

1. **Privacy concerns**
   - Tracking mogelijk
   - Ongemerkt uitlezen
   - Geen beveiliging bij passieve tags

2. **Beperkt bereik**
   - Passief: enkele cm - 5m
   - Afhankelijk van omgeving

3. **Interferentie**
   - Metaal blokkeert signaal
   - Vloeistoffen dempen signaal
   - Andere RFID tags storen elkaar

4. **Minimale afstand tussen tags**
   - 13.56 MHz: 60 cm nodig
   - Anders collision

5. **Geen standaard beveiliging**
   - Tags zijn vaak onversleuteld
   - Klonen mogelijk
   - Man-in-the-middle attacks

6. **Kosten**
   - Duurder dan barcodes
   - Vooral actieve tags

7. **Data capaciteit beperkt**
   - Meestal alleen ID
   - Niet geschikt voor grote datasets

### RFID voorbeelden

**Passief (geen batterij, korte range):**
1. **Bibliotheek boeken** (13.56 MHz)
   - Uitleen registratie
   - Diefstalbeveiliging
   
2. **Toegangskaarten** (125 kHz)
   - Gebouw toegang
   - Hotel sleutels
   
3. **Kledij tags** bij Decathlon (865-868 MHz)
   - Inventaris
   - Zelfscankassa's

**Semi-Actief (batterij voor sensor, passieve communicatie):**
1. **Temperatuur monitoring**
   - Voedsel transport
   - Farmaceutische producten
   
2. **Vochtigheid sensoren**
   - Bouwmaterialen
   
3. **Container tracking**
   - Scheepvaart

**Actief (batterij, lange range):**
1. **Toll poorten** (2.45 GHz / 5.8 GHz)
   - Automatische tol betaling
   - Bereik: 10-100 meter
   
2. **Fleet management** (GPS + RFID)
   - Vrachtwagen tracking
   - Real-time locatie
   
3. **Vee tracking** (134 kHz actief)
   - Boerderij management
   - Bewegingspatronen

---

## BLUETOOTH

### Frequency hopping
**FHSS = Frequency Hopping Spread Spectrum**

**Werking:**
- Bluetooth gebruikt 2.402 - 2.480 GHz band
- Verdeeld in 79 kanalen van 1 MHz
- Hopped **1600 keer per seconde** tussen kanalen
- Pseudo-random volgorde
- Master bepaalt hopping sequence

**Voordelen:**
1. **Minder interferentie**
   - Kortdurend op elke frequentie
   - Storing heeft beperkte impact
   
2. **Beveiliging**
   - Moeilijk af te luisteren
   - Moet hopping sequence kennen
   
3. **Meerdere piconets**
   - Elk met eigen sequence
   - Kunnen naast elkaar bestaan

### Piconet en Scatternet

**Piconet:**
- Ad-hoc Bluetooth netwerk
- 1 **master** + tot 7 actieve **slaves**
- Tot 255 "parked" (passieve) slaves
- Master bepaalt:
  - Hopping sequence
  - Timing
  - Polling slaves
- Slaves mogen alleen zenden wanneer master toestaat

**Scatternet:**
- Meerdere piconets samen
- Een device kan in meerdere piconets zijn
- Switching tussen piconet roles:
  - Master in piconet A
  - Slave in piconet B
- Complexer time scheduling
- Gebruikt voor uitbreiden bereik

**Voorbeeld:**
```
Piconet 1: Master(A) - Slave(B) - Slave(C)
Piconet 2: Master(B) - Slave(D) - Slave(E)
                ↑
          Device B is bridge
```

---

## SNMP

### OID voorbeeld
**OID = Object Identifier**

**Numeriek:**
- `1.3.6.1.2.1.1.1.0`
  - System description
  
- `1.3.6.1.2.1.2.2.1.10.1`
  - Interface inbound octets voor interface 1

**Named:**
- `iso.org.dod.internet.mgmt.mib-2.system.sysDescr.0`
- `iso.org.dod.internet.mgmt.mib-2.interfaces.ifTable.ifEntry.ifInOctets.1`

**Structuur:**
- iso (1)
- org (3)
- dod (6)
- internet (1)
- mgmt (2)
- mib-2 (1)
- [categorie]
- [object]
- [instance]

### SNMPv3 vs SNMPv2

**Waarom SNMPv3 gebruiken:**

1. **Security**
   - **Authenticatie:** MD5 of SHA
   - **Encryptie:** DES of AES
   - **Integriteit:** Berichten niet aangepast
   
2. **User-based security**
   - Per gebruiker rechten
   - Niet alleen community string
   
3. **Access control**
   - Per MIB sectie
   - Per IP range
   - Read-only of read-write

4. **Privacy**
   - Data encryptie met DES/AES
   - Community strings in cleartext bij v2

5. **Granulaire rechten**
   - Per gebruiker verschillende toegang
   - Niet alles of niets

**Waarom SNMPv2 gebruiken:**
- Eenvoudiger configuratie
- Oudere apparaten ondersteunen v3 niet
- Minder overhead
- Voldoende voor niet-kritische netwerken

### SNMPv3 Commando's

**createUser authOnlyUser MD5 "secret007"**
- Maakt gebruiker aan met **alleen authenticatie**
- Gebruikt MD5 hash voor paswoord verificatie
- Passphrase minimum 8 characters
- **Geen encryptie** van data (authNoPriv)

**createUser authPrivUser SHA "geheim007" AES**
- Maakt gebruiker aan met **authenticatie én privacy**
- SHA voor authenticatie (veiliger dan MD5)
- AES encryptie voor data privacy
- **Wel encryptie** van SNMP verkeer (authPriv)
- Passphrase minimum 8 characters

---

## HTTP/3

### Ossification
**Ossification** = Het gebrek aan flexibiliteit om mee te groeien en evolueren met nieuwe versies.

**Probleem:**
- Internet staat vol "oude machines"
- Routers, gateways, firewalls
- Doen bijna nooit upgrades
- Servers worden veel vaker geüpgraded
- Nieuwe protocollen worden geblokkeerd door oude hardware

### 0-RTT (Zero Round Trip Time)
**Snellere verbindingsopbouw zonder handshake delay.**

**Werking:**
- Geen TCP sessie, direct TLS
- Early data: Data request al in de handshake
- Als je al een site hebt bezocht moet je geen nieuwe verbinding maken
- Hergebruik van eerdere sessie parameters

**Voordeel:**
- Veel sneller voor herhaalde bezoeken
- 75% van connecties winnen door 0-RTT

**Risico:**
- Replay attacks mogelijk
- Alleen veilig voor GET zonder query parameters
- Extra unieke identifier kan replay attacks detecteren

### TCP line blocking (Head of Line blocking)
**Probleem bij TCP:**
- TCP connectie blokkeert wanneer 1 van de streams blokkeert
- Als rode stream blokkeert, blokkeert groene stream ook
- Alle data moet in volgorde aankomen

**QUIC oplossing:**
- QUIC heeft afzonderlijke streams binnen één connectie
- Als blauwe stream blokkeert, blokkeert gele stream niet
- Onafhankelijke streams per resource
- Betere prestaties bij pakketverlies

### Connection Migration
**Verbindingen blijven actief bij netwerkwissel.**

**Werking:**
- Verbindingen krijgen in HTTP/3 een **Connection ID**
- Deze zijn uniek voor een sessie
- Verbindingen kunnen lopen over verschillende netwerkverbindingen
- Switchen van 5G naar WiFi kan met dezelfde Connection ID
- De verbinding wordt niet onderbroken

**Voordeel:**
- Naadloze overgang tussen netwerken
- Belangrijk voor mobiele apparaten
- Geen TCP session reset nodig

### Spin bit
**Mechanisme om operators beperkte zichtbaarheid te geven.**

**Probleem:**
- Connecties zijn door operators niet te volgen omdat alles geencrypteerd is
- Operators kunnen verkeer niet analyseren voor troubleshooting

**Oplossing - Spin bit:**
- Verbindingen gebruiken dezelfde spin bit om aan te geven dat ze in dezelfde conversatie zitten
- Spin bits staan in beide richtingen op 0, daarna op 1, daarna op 0, enz.
- Zo kan een operator een klein beetje zien dat het over dezelfde connectie gaat
- Helpt bij round-trip time metingen

**Beperking:**
- Operator ziet bijna niets van de inhoud
- Alleen basis timing informatie

### HTTP/3 verbeteringen tov HTTP/2

**1. Geen TCP head-of-line blocking**
- Niet 1 stream die alles blokkeert
- Onafhankelijke streams

**2. Snellere handshakes**
- Niet een TCP handshake én TLS handshake
- TLS 1.3 geïntegreerd in QUIC
- 0-RTT voor herhaalde bezoeken

**3. Snellere data aanvraag**
- Early data in handshake
- Geen wachten op verbindingsopbouw

**4. Altijd encryptie**
- QUIC is altijd encrypted
- Geen cleartext versie
- Betere privacy en security

**5. Snellere upgrades**
- Overstap naar QUIC2 is binnen encryptie een upgrade
- Geen nieuwe handshake nodig

**6. Connection Migration**
- Verbinding blijft bij netwerkwissel
- Belangrijk voor mobiele devices

**7. Minder vertraging**
- Traagste connecties (1%) winnen 1 seconde
- 18% minder buffertijd voor video's
- 3% sneller laden gemiddelde pagina

### Probleem nieuw transportprotocol

**Ossification probleem:**
- Nieuwe transportprotocollen worden geblokkeerd door middleboxes
- Firewalls, routers en NAT devices begrijpen alleen TCP en UDP
- Eerdere poging met SCTP (Stream Transmission Control Protocol) mislukte

**Waarom UDP gekozen:**
- UDP wordt overal doorgelaten
- Connectionless, geen state in netwerk
- QUIC bouwt betrouwbaarheid bovenop UDP
- Implementatie in userspace, niet in kernel
- Snellere ontwikkeling en updates mogelijk

**QUIC voegt toe aan UDP:**
- Connecties en streams
- Hersturen van verloren data
- Flow control
- Congestion control
- TLS 1.3 encryptie

### HTTP/3 beschikbaar stellen

**Proces:**

1. **Alt-Svc response header**
   - Server stuurt header mee met HTTP/2 response
   - Bijvoorbeeld: `Alt-Svc: h3=":443"; ma=2592000`
   - Geeft aan dat HTTP/3 (h3) beschikbaar is op poort 443
   - `ma` = max-age in seconden

2. **Browser onthoudt dit**
   - Browser onthoudt dat server HTTP/3 ondersteunt
   - Volgende bezoek probeert direct HTTP/3

3. **Fallback mechanisme**
   - 3-7% van QUIC connecties falen
   - Browser valt terug op HTTP/2 over TCP
   - Transparant voor gebruiker

4. **Zelfde URL en poort**
   - URL blijft https://
   - Poort 443 voor beide protocollen
   - Geen wijzigingen aan applicaties nodig

**DNS HTTPS records (optioneel):**
- Nieuwere methode via DNS
- HTTPS record geeft direct aan dat HTTP/3 beschikbaar is
- Sneller dan Alt-Svc header

---

## ALGEMENE TIPS

- Het is belangrijker om te weten **HOE** iets werkt, dan om een afkorting van buiten te kennen
- Er komen ook zeker vragen over het **praktische gedeelte**
- Je moet Firewall regels algemeen, met iptables, met vyos of met cisco routers **verstaan**
- Vragen kunnen ook **omgekeerd** zijn (het antwoord wordt een vraag)
- Je krijgt ook meer **open vragen**, waar je je mening moet funderen met antwoorden gespreid over de cursus
  - Bijvoorbeeld: Teken een netwerkontwerp MET geldige IP adressen, waarbij je gebruik maakt van een proxy server, webserver, firewall en externe DNS
  - Bijvoorbeeld: Geef 2 technieken die je zou gebruiken bij een nieuwe WiFi standaard
- Je moet ook een netwerk kunnen ontwerpen met onderdelen/services die je in de les hebt gezien, **inclusief IP adressering**
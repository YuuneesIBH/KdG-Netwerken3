# Proxy Server Setup - Volledige Uitleg

## Inhoudsopgave
1. [Installatie van Packages](#installatie)
2. [Squid Proxy Server Configuratie](#squid)
3. [Access Control Lists (ACLs)](#acls)
4. [Ad Blocking met Squid](#adblocking)
5. [E2guardian Content Filtering](#e2guardian)
6. [ClamAV Virus Scanning](#clamav)
7. [Troubleshooting](#troubleshooting)

---

## 1. Installatie van Packages {#installatie}

### Geïnstalleerde Components

```bash
sudo apt install squid curl e2guardian clamav-daemon clamav-testfiles
```

**Squid** (`squid`): HTTP proxy cache server
- Doel: Forward proxy voor HTTP/HTTPS verkeer
- Functionaliteit: Caching, access control, bandwidth management

**E2guardian** (`e2guardian`): Content filtering proxy
- Doel: Web content filtering en monitoring
- Functionaliteit: URL filtering, keyword filtering, virus scanning integration

**ClamAV** (`clamav-daemon`, `clamav-freshclam`):
- `clamav-daemon`: Antivirus daemon voor realtime scanning
- `clamav-freshclam`: Automatische virus signature updates
- `clamav-testfiles`: Test bestanden (EICAR test virus)

**Hulpprogramma's**:
- `curl`: HTTP client voor testen
- `logrotate`: Log management
- `libclamav12`: ClamAV library
- `squid-common`, `squid-langpack`: Squid ondersteuning

### Service Status Controle

Na installatie draaien automatisch:
```bash
systemctl status squid        # Port 3128 (default)
systemctl status e2guardian    # Port 8080 (default)
```

ClamAV daemon is standaard **disabled** en moet handmatig gestart worden.

---

## 2. Squid Proxy Server Configuratie {#squid}

### Port Configuratie

**Locatie**: `/etc/squid/squid.conf`

Wijzig de standaard port van 3128 naar 8080:

```bash
# Zoek regel met http_port
grep -n "http_port" /etc/squid/squid.conf

# Regel 2116 bevat:
http_port 3128

# Wijzig naar:
http_port 8080
```

**Waarom port 8080?**
- Standaard alternatieve HTTP port
- E2guardian gebruikt standaard ook 8080, dus er was een conflict
- E2guardian werd eerst naar 8888 verplaatst

### Service Herstarten

```bash
sudo systemctl restart squid
sudo systemctl status squid
```

### Port Verificatie

Controleer welke diensten op welke ports luisteren:

```bash
sudo ss -ltnp | grep -E "8080|8888"
```

Output toont:
- Squid luistert op port **8080**
- E2guardian luistert op port **8888**

### Testen van de Proxy

**Test 1: Direct via Squid (port 8080)**
```bash
curl -x http://localhost:8080 http://example.com
```

**Test 2: Via E2guardian (port 8888)**
```bash
curl -x http://localhost:8888 http://example.com
```

### Log Locaties

```bash
# Squid access logs
sudo tail -f /var/log/squid/access.log

# E2guardian logs
sudo tail -f /var/log/e2guardian/access.log
```

**Log formaat Squid**:
```
timestamp duration client_ip result/status size method URL - hierarchy content_type
```

Voorbeeld:
```
1759320545.194    400 127.0.0.1 TCP_MISS/200 1636 GET http://example.com/ - HIER_DIRECT/23.220.75.245 text/html
```

---

## 3. Access Control Lists (ACLs) {#acls}

### ACL Concept

**Access Control Lists** bepalen wie toegang heeft tot welke resources via de proxy.

**Syntax**:
```
acl <naam> <type> <waarde>
http_access allow|deny <naam>
```

### KDG.be Blokkeren

**Doel**: Blokkeer alle toegang tot *.kdg.be domeinen

**Configuratie in `/etc/squid/squid.conf`**:

```bash
# Definieer ACL voor KDG domein
acl blokkade dstdomain .kdg.be

# Blokkeer normale HTTP requests
http_access deny blokkade

# Blokkeer HTTPS CONNECT requests
http_access deny CONNECT blokkade

# Allow localhost
http_access allow localhost

# Deny all other access
http_access deny all
```

**Belangrijke details**:

1. **`.kdg.be`** met punt ervoor = wildcard voor alle subdomeinen
   - Blokkeert: `www.kdg.be`, `mail.kdg.be`, `student.kdg.be`, etc.

2. **CONNECT blokkade** is nodig voor HTTPS:
   - HTTP gebruikt gewone requests
   - HTTPS gebruikt CONNECT tunnel methode
   - Beide moeten apart geblokkeerd worden

3. **Volgorde is belangrijk**:
   - ACLs worden van boven naar beneden geëvalueerd
   - Eerste match wint
   - `localhost` moet voor deny all komen

### Testen

```bash
# Restart na configuratie
sudo systemctl restart squid

# Test geblokkeerd domein
curl -x http://localhost:8080 http://www.kdg.be
# Verwacht: 403 Forbidden of geen connectie

# Test toegestaan domein  
curl -x http://localhost:8080 http://example.com
# Verwacht: Normale response
```

---

## 4. Ad Blocking met Squid {#adblocking}

### Principe

Gebruik een **blacklist** van bekende ad server domeinen om advertenties te blokkeren.

### Implementatie (Calomel Methode)

**Stap 1: Download ad server lijst**

```bash
sudo curl -sS -L --compressed \
  "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml&showintro=0&mimetype=plaintext" \
  -o /etc/squid/ad_block.txt
```

**Bestand bevat**: Lijst van domeinnamen van bekende ad servers (bijv. `doubleclick.net`, `googlesyndication.com`)

**Stap 2: Configureer Squid ACL**

In `/etc/squid/squid.conf`:

```bash
# Ad blocker - Calomel methode
acl ads dstdom_regex "/etc/squid/ad_block.txt"
http_access deny ads
```

**`dstdom_regex`**: Match destination domain met regular expressions uit bestand

**Stap 3: Herlaad configuratie**

```bash
sudo squid -k reconfigure
```

**Geen restart nodig!** - `squid -k reconfigure` herlaadt config zonder downtime.

### Volgorde in squid.conf

```bash
# Localhost toegang
http_access allow localhost

# Blokkeer KDG
acl blokkade dstdomain .kdg.be
http_access deny blokkade
http_access deny CONNECT blokkade

# Blokkeer advertenties
acl ads dstdom_regex "/etc/squid/ad_block.txt"
http_access deny ads

# Deny rest
http_access deny all
```

### Testen

```bash
# Test normaal domein
curl -x http://localhost:8080 http://example.com -I
# Verwacht: HTTP/1.1 200 OK

# Test ad server
curl -x http://localhost:8080 http://ads.doubleclick.net -I
# Verwacht: HTTP/1.1 502 Bad Gateway of 403 Forbidden
```

**In logs**:
```bash
sudo tail -f /var/log/squid/access.log | grep doubleclick
# Toont geblokkeerde requests
```

### Automatische Updates (Optioneel)

Maak een cron job om de lijst elke 3 dagen te updaten:

```bash
# /etc/cron.d/squid-adblock
35 5 */3 * * root curl -sS -L --compressed "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml&showintro=0&mimetype=plaintext" -o /etc/squid/ad_block.txt && squid -k reconfigure
```

---

## 5. E2guardian Content Filtering {#e2guardian}

### Architectuur

```
Client → E2guardian (8888) → Squid (8080) → Internet
            ↓
        ClamAV scan
```

**E2guardian** filtert content **voor** het naar Squid gaat.

### Configuratie

**Bestand**: `/etc/e2guardian/e2guardian.conf`

**Wijzigingen**:

```bash
# E2guardian luistert op port 8888
filterports = 8888

# Forward naar Squid op port 8080
proxyport = 8080

# Proxy IP (localhost)
proxyip = 127.0.0.1
```

**Opmerking**: `mapportstoips = off` betekent dat port mapping uitstaat.

### Service Restart

```bash
sudo systemctl restart e2guardian
sudo systemctl status e2guardian
```

### Testen via E2guardian

```bash
# Via E2guardian (met filtering)
curl -x http://localhost:8888 http://example.com -I

# Direct via Squid (zonder E2guardian filtering)
curl -x http://localhost:8080 http://example.com -I
```

### Logs

```bash
sudo tail -f /var/log/e2guardian/access.log
```

**Log formaat**:
```
timestamp - - client_ip remote_ip URL method status size ... flags ... group
```

**Velden**:
- `*SCANNED*`: Bestand werd gescand door antivirus
- `*DENIED*`: Access geweigerd
- `group`: Filter group (standaard: `no_name_group`)

---

## 6. ClamAV Virus Scanning {#clamav}

### ClamAV Architectuur

**ClamAV Components**:
1. **clamd**: Daemon voor realtime scanning
2. **freshclam**: Update service voor virus signatures
3. **clamdscan**: CLI scanner die communiceert met clamd

### ClamAV Activeren

**Stap 1: Enable en start daemon**

```bash
sudo systemctl enable clamav-daemon
sudo systemctl start clamav-daemon
sudo systemctl status clamav-daemon
```

**Verificatie**:
```bash
ps -u clamav
# Output: freshclam en clamd processen
```

### E2guardian Content Scanner Configureren

**Stap 1: Activeer clamdscan in e2guardian.conf**

Bestand: `/etc/e2guardian/e2guardian.conf`

Zoek regel ~495 en verwijder commentaar:

```bash
# Voor:
#contentscanner = '/etc/e2guardian/contentscanners/clamdscan.conf'

# Na:
contentscanner = '/etc/e2guardian/contentscanners/clamdscan.conf'
```

**Stap 2: Controleer clamdscan.conf**

Bestand: `/etc/e2guardian/contentscanners/clamdscan.conf`

```bash
plugname = 'clamdscan'

# ClamD UNIX socket locatie
clamdudsfile = '/run/clamav/clamd.ctl'
```

**Socket**: Unix domain socket voor IPC tussen E2guardian en ClamAV.

### Permissions Probleem Oplossen

**Probleem**: E2guardian draait als user `e2guardian`, maar moet kunnen communiceren met ClamAV (user `clamav`) en temp files schrijven.

**Oplossing**: Verander E2guardian user naar `clamav`

**Stap 1: Wijzig daemon user in e2guardian.conf**

```bash
# Zoek regels ~90-95
daemonuser = 'clamav'
daemongroup = 'clamav'
```

**Stap 2: Fix log directory permissions**

```bash
# Geef clamav group ownership van logs
sudo chgrp -R clamav /var/log/e2guardian

# Geef group write permissions
sudo chmod -R g+w /var/log/e2guardian
```

**Stap 3: Clean temp files en restart**

```bash
# Stop service
sudo systemctl stop e2guardian

# Verwijder oude temp files (van oude user)
sudo rm /tmp/.e2guardian*

# Start service
sudo systemctl start e2guardian
sudo systemctl status e2guardian
```

### Virus Scan Testen

**EICAR Test File**: Standaard test virus (harmless)

```bash
# Download EICAR via proxy
curl -x http://localhost:8888 \
  http://www.eicar.org/download/eicar.com.txt \
  -o /tmp/eicar.txt
```

**Verwacht resultaat**: 
- HTTP 403 Forbidden
- Of HTML pagina met "Access Denied"

**In logs**:
```bash
sudo tail -f /var/log/e2guardian/access.log
```

**Success log bevat**:
```
*SCANNED* *DENIED* /tmp/csXXXXX: Access denied. ERROR
```

**Betekenis van flags**:
- `*SCANNED*`: File werd door ClamAV gescand
- `*DENIED*`: Virus gedetecteerd en geblokkeerd
- `/tmp/csXXXXX`: Temp file waar scan plaatsvond
- `Content scanning`: Reden van blokkade

### ClamAV Virus Database Updates

**Automatisch via freshclam**:

```bash
systemctl status clamav-freshclam
```

Freshclam update regelmatig (standaard: elk uur check) de virus signatures.

**Handmatige update**:
```bash
sudo freshclam
```

---

## 7. Troubleshooting {#troubleshooting}

### Port Conflicts

**Probleem**: E2guardian en Squid willen beide port 8080

**Oplossing**: 
- Squid → 8080
- E2guardian → 8888

**Verificatie**:
```bash
sudo ss -ltnp | grep -E "8080|8888"
```

### Permission Denied Errors

**Symptomen**: 
- E2guardian start niet
- "Permission denied" in logs
- Temp files niet schrijfbaar

**Oplossing**:
1. Zorg dat `daemonuser` en `daemongroup` correct zijn
2. Fix directory permissions met `chgrp` en `chmod`
3. Verwijder oude temp files: `rm /tmp/.e2guardian*`

**Nooit `chmod 777` gebruiken!** - Security risk

### ClamAV Socket Not Found

**Probleem**: E2guardian kan ClamAV niet bereiken

**Check socket locatie**:
```bash
ls -l /run/clamav/clamd.ctl
```

**Moet overeenkomen met** `clamdudsfile` in `/etc/e2guardian/contentscanners/clamdscan.conf`

**Fix**:
```bash
sudo systemctl restart clamav-daemon
```

### Logs Checken

**Squid errors**:
```bash
sudo journalctl -u squid -f
```

**E2guardian errors**:
```bash
sudo journalctl -u e2guardian -f
```

**ClamAV errors**:
```bash
sudo journalctl -u clamav-daemon -f
```

**System log**:
```bash
sudo tail -f /var/log/syslog
```

### Config Syntax Testen

**Squid**:
```bash
sudo squid -k parse
# Output: "OK" als syntax correct is
```

**E2guardian**:
```bash
sudo e2guardian -t
# Test mode - checkt config syntax
```

### Service Dependency Order

**Juiste volgorde opstarten**:

1. **ClamAV** eerst (als virus scanning gebruikt wordt)
   ```bash
   sudo systemctl start clamav-daemon
   ```

2. **Squid** daarna
   ```bash
   sudo systemctl start squid
   ```

3. **E2guardian** als laatste (heeft Squid én ClamAV nodig)
   ```bash
   sudo systemctl start e2guardian
   ```

---

## Samenvatting Flow

```
┌─────────────────────────────────────────────────┐
│ Client Browser (proxy: localhost:8888)          │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│ E2guardian (port 8888)                          │
│  - Content filtering                            │
│  - Keyword blocking                             │
│  - Virus scanning via ClamAV                    │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│ Squid (port 8080)                               │
│  - HTTP proxy                                   │
│  - ACL filtering (KDG, ads)                     │
│  - Caching                                      │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│ Internet                                        │
└─────────────────────────────────────────────────┘
```

**Request flow**:
1. Client → E2guardian (8888)
2. E2guardian download & scan content
3. Als clean → forward naar Squid (8080)
4. Squid checkt ACLs (KDG block, ad block)
5. Als allowed → fetch van internet
6. Response terug via zelfde weg

**Multiple filtering layers**:
- **E2guardian**: Content/virus filtering
- **Squid ACLs**: Domain/URL blocking
- **Ad blocker**: Advertising blocking

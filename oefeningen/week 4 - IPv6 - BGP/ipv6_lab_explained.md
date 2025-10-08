# IPv6 Lab - Complete Explanation

## Table of Contents
1. [SSH over IPv6 with tcpdump](#1-ssh-over-ipv6-with-tcpdump)
2. [Apache IPv6-Only Configuration](#2-apache-ipv6-only-configuration)
3. [IPv6 Firewall Rules](#3-ipv6-firewall-rules)
4. [VyOS Router Advertisements](#4-vyos-router-advertisements)
5. [Linux IPv6 Client Configuration](#5-linux-ipv6-client-configuration)
6. [VLC IPv6 Streaming](#6-vlc-ipv6-streaming)
7. [IPv6 Multicast](#7-ipv6-multicast)

---

## 1. SSH over IPv6 with tcpdump

### Objective
Test SSH connections over IPv6 and verify traffic using tcpdump.

### Commands Used

#### Install required packages
```bash
sudo apt update
sudo apt install tcpdump openssh-server -y
```

#### Start tcpdump on loopback interface
```bash
sudo tcpdump -i lo
```

#### SSH connections
```bash
# Test IPv4 SSH connection
ssh ubuntu@127.0.0.1

# Test IPv6 SSH connection
ssh ubuntu@::1
```

### Key Concepts

**IPv6 Loopback Address**: `::1` is the IPv6 equivalent of `127.0.0.1` in IPv4.

**tcpdump Output**: When monitoring with tcpdump, you can identify IPv6 traffic by looking for:
- `IP6` prefix in packet descriptions
- `ip6-localhost` in connection strings
- IPv6 addresses in the format `xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx`

### What We Observed
```
12:19:39.967862 IP6 ip6-localhost.59831 > ip6-localhost.50567: UDP, length 0
```

The `IP6` prefix confirms IPv6 traffic, while `ip6-localhost` refers to the `::1` loopback address.

---

## 2. Apache IPv6-Only Configuration

### Objective
Configure Apache to listen ONLY on IPv6, making it inaccessible via IPv4.

### Configuration Steps

#### 1. Install Apache
```bash
sudo apt install apache2 -y
```

#### 2. Modify `/etc/apache2/ports.conf`
```apache
# Listen on IPv6 loopback only
Listen [::1]:80
```

**Key syntax**: IPv6 addresses in Apache must be enclosed in square brackets `[]`.

#### 3. Modify `/etc/apache2/sites-enabled/000-default.conf`
```apache
<VirtualHost [::]:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    # ... rest of configuration
</VirtualHost>
```

#### 4. Configure system to enforce IPv6-only binding
```bash
# Add to /etc/sysctl.conf
net.ipv6.bindv6only = 1

# Apply changes
sudo sysctl -p
sudo sysctl -w net.ipv6.bindv6only=1
```

#### 5. Restart Apache
```bash
sudo systemctl restart apache2
```

### Troubleshooting

**Problem**: Port conflict with nginx on port 80
```bash
sudo ss -tlnp | grep :80
```

**Solution**: Stop conflicting service
```bash
sudo systemctl stop nginx
sudo systemctl disable nginx
```

### Verification

Check that Apache is listening on IPv6 only:
```bash
sudo ss -tlnp | grep :80
# Should show: LISTEN 0 511 [::1]:80 [::]:* users:(("apache2",...))
```

### Accessing IPv6 Website in Browser

To access an IPv6-only website in a browser, use the IPv6 address with square brackets:
```
http://[::1]/
http://[2001:6a8:540:101::2]/
```

### Key Concepts

- **`net.ipv6.bindv6only=1`**: Ensures that sockets bound to `::` only accept IPv6 connections, not IPv4-mapped IPv6 addresses
- **IPv6 address notation**: Always use square brackets `[]` in URLs and Apache configs
- **`::1`**: IPv6 loopback (equivalent to 127.0.0.1)
- **`::`**: IPv6 "any address" (equivalent to 0.0.0.0)

---

## 3. IPv6 Firewall Rules

### Objective
Configure ip6tables to block specific IPv6 ping traffic.

### Network Setup

#### View IPv6 addresses
```bash
ip -6 addr show
```

Output shows:
- Loopback: `::1/128`
- Link-local: `fe80::1863:23ff:fe39:a42c/64`
- Global: `2001::1/64` (manually assigned)

#### Assign IPv6 addresses
```bash
# On Linux host
sudo ip -6 addr add 2001::1/64 dev enp0s1

# On second interface for communication with VyOS
sudo ip link set enp0s2 up
sudo ip -6 addr add 2001:6a8:540:101::2/64 dev enp0s2
```

### VyOS Configuration

```bash
# Configure IPv6 address on VyOS
configure
set interfaces ethernet eth1 address 2001:6A8:540:101::1/64
commit
save
```

### Testing Connectivity

```bash
# Ping VyOS from Linux
ping6 2001:6a8:540:101::1
```

### Firewall Rules

#### View current IPv6 firewall rules
```bash
sudo ip6tables -L -v
```

#### Block ping to specific IPv6 address
```bash
sudo ip6tables -A OUTPUT -p ipv6-icmp --icmp-type echo-request \
    -d 2001:6a8:540:101::1 -j DROP
```

#### Verify rule is active
```bash
sudo ip6tables -L -v
# Shows:
# pkts bytes target     prot opt in     out     source               destination
#    5   520 DROP       ipv6-icmp any    any     anywhere             2001:6a8:540:101::1  ipv6-icmp echo-request
```

### Key Concepts

- **ip6tables**: IPv6 equivalent of iptables
- **ipv6-icmp**: IPv6 uses ICMPv6 (not ICMP like IPv4)
- **echo-request**: Ping request packet type
- **OUTPUT chain**: Filters outgoing packets from the host
- **-j DROP**: Silently discard matching packets

### IPv6 Address Types

1. **Loopback** (`::1/128`): Local host communication
2. **Link-local** (`fe80::/10`): Communication within the same network segment
3. **Global unicast** (`2000::/3`): Internet-routable addresses
4. **Unique local** (`fc00::/7`): Private addresses (like 192.168.x.x)

---

## 4. VyOS Router Advertisements

### Objective
Configure VyOS to distribute IPv6 addresses using SLAAC (Stateless Address Autoconfiguration) via Router Advertisements, NOT DHCPv6.

### VyOS Configuration

```bash
configure

# Configure IPv6 address on interface
set interfaces ethernet eth1 address 2001:6A8:540:101::1/64

# Enable Router Advertisements
set service router-advert interface eth1 prefix 2001:6A8:540:101::/64

# Set prefix lifetimes
set service router-advert interface eth1 prefix 2001:6A8:540:101::/64 valid-lifetime 2592000
set service router-advert interface eth1 prefix 2001:6A8:540:101::/64 preferred-lifetime 2073600

commit
save
```

### Router Advertisement Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| **valid-lifetime** | 2592000 | 30 days - How long address remains valid |
| **preferred-lifetime** | 2073600 | 24 days - How long address is preferred for new connections |
| **Prefix** | 2001:6A8:540:101::/64 | Network prefix to advertise |

### Verification on Linux Client

```bash
# Restart network to receive RA
sudo systemctl restart NetworkManager

# Check IPv6 addresses
ip -6 addr show enp0s2
```

Expected output:
```
inet6 2001:6a8:540:101:4065:49ff:fe49:e3ab/64 scope global dynamic mngtmpaddr
    valid_lft 2591857sec preferred_lft 2073457sec
```

### Check IPv6 routes
```bash
ip -6 route
```

Should show default route via link-local address of VyOS:
```
default via fe80::1491:c4ff:fe80:a0e0 dev enp0s2 proto ra metric 1024
```

### Key Concepts

#### SLAAC (Stateless Address Autoconfiguration)
- Host generates its own IPv6 address using:
  - Network prefix from Router Advertisement
  - Interface identifier (usually derived from MAC address using EUI-64)
- No central DHCP server needed
- Router only advertises prefix, not complete addresses

#### Router Advertisement (RA)
- ICMPv6 message type
- Sent periodically by routers
- Contains:
  - Network prefix(es)
  - Default gateway information
  - MTU
  - Hop limit
  - Flags (managed/other config)

#### Address Format
```
2001:6a8:540:101:4065:49ff:fe49:e3ab
├─────────────────┤└─────────────────┘
    Prefix (64)      Interface ID (64)
   From Router        From MAC address
```

#### Lifetime Values
- **Valid lifetime**: Total time address can be used
- **Preferred lifetime**: Time address should be used for new connections
- When preferred expires, address becomes deprecated (still valid, but not preferred)

---

## 5. Linux IPv6 Client Configuration

### Objective
Configure a Linux client to obtain IPv6 addresses via Router Advertisements and test connectivity.

### Essential IPv6 Commands

#### View IPv6 addresses
```bash
ip -6 addr show
```

Output breakdown:
```
2: enp0s2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500
    inet6 2001:6a8:540:101:4065:49ff:fe49:e3ab/64 scope global dynamic mngtmpaddr
        valid_lft 2591479sec preferred_lft 2073079sec
    inet6 2001:6a8:540:101::2/64 scope global
        valid_lft forever preferred_lft forever
    inet6 fe80::4065:49ff:fe49:e3ab/64 scope link
        valid_lft forever preferred_lft forever
```

**Address types**:
- **scope global dynamic**: SLAAC-generated address from RA
- **scope global**: Statically configured address
- **scope link**: Link-local address (fe80::/10)

#### Request address via Router Advertisements
```bash
sudo systemctl restart NetworkManager
# or
sudo dhclient -6 -r && sudo dhclient -6
```

#### View IPv6 routing table
```bash
ip -6 route
```

Output:
```
::1 dev lo proto kernel metric 256 pref medium
2001:6a8:540:101::/64 dev enp0s2 proto kernel metric 256 pref medium
fe80::/64 dev enp0s2 proto kernel metric 256 pref medium
default via fe80::1491:c4ff:fe80:a0e0 dev enp0s2 proto ra metric 1024
```

**Route types**:
- `::1`: Loopback route
- Network routes: Direct connectivity
- `default via fe80:...`: Default gateway learned from RA

#### Perform IPv6 ping
```bash
ping6 2001:6a8:540:101::1
# or
ping -6 2001:6a8:540:101::1
```

### NetworkManager and IPv6

NetworkManager handles IPv6 automatically:
1. Listens for Router Advertisements
2. Generates SLAAC address
3. Configures routes
4. Maintains privacy extensions

### Common Issues and Solutions

#### No IPv6 address received
```bash
# Check if IPv6 is enabled
sysctl net.ipv6.conf.all.disable_ipv6
# Should return: net.ipv6.conf.all.disable_ipv6 = 0

# Check for Router Advertisements
sudo tcpdump -i enp0s2 -n icmp6
# Look for: "router advertisement"
```

#### Ping fails despite having address
```bash
# Check firewall rules
sudo ip6tables -L -v

# Verify routing
ip -6 route get 2001:6a8:540:101::1
```

### IPv6 Address Scopes

| Scope | Description | Example |
|-------|-------------|---------|
| **host** | Loopback only | ::1 |
| **link** | Same network segment | fe80::/10 |
| **site** | Deprecated scope | - |
| **global** | Internet routable | 2001::/3 |

---

## 6. VLC IPv6 Streaming

### Objective
Stream video over IPv6 using VLC and verify traffic using tcpdump/nmap.

### Setup

#### Install VLC and SMPlayer
```bash
sudo apt install vlc smplayer -y
```

#### Download test video
```bash
wget http://download.opencontent.netflix.com.s3.amazonaws.com/CosmosLaundromat/CosmosLaundromat_2k24p_HDR_P3PQ.mp4 -O ~/test.mp4
```

### VLC Streaming Server

#### Start streaming (headless)
```bash
cvlc ~/test.mp4 --sout '#http{mux=ts,dst=[2001:6a8:540:101::2]:8090/}' --ttl 12
```

**Command breakdown**:
- `cvlc`: Console VLC (no GUI)
- `--sout`: Stream output
- `#http{...}`: HTTP streaming module
- `mux=ts`: Transport Stream container
- `dst=[IPv6]:port/`: Destination with IPv6 address in brackets
- `--ttl 12`: Time-to-live for packets

### Troubleshooting Port Conflicts

#### Check for port usage
```bash
sudo ss -tlnp | grep 8080
```

#### Stop conflicting service (e.g., Squid)
```bash
sudo systemctl stop squid
```

### Verify Open Ports with nmap

#### Scan IPv6 address
```bash
nmap -6 2001:6a8:540:101::2
# or
nmap [2001:6a8:540:101::2]
```

Expected output:
```
PORT     STATE SERVICE
8090/tcp open  http
```

**nmap IPv6 options**:
- `-6`: Force IPv6 scanning
- Use brackets around IPv6 addresses in URL format

### Client Playback with SMPlayer

```bash
smplayer http://[2001:6a8:540:101::2]:8090/
```

**Important**: Always use square brackets around IPv6 addresses in URLs.

### Verify IPv6 Traffic with tcpdump

```bash
sudo tcpdump -i enp0s2 -n ip6 and port 8090
```

Output shows:
```
IP6 2001:6a8:540:101::2.8090 > 2001:6a8:540:101:4065:49ff:fe49:e3ab.xxxxx: Flags [P.], ...
```

**tcpdump filters**:
- `ip6`: IPv6 traffic only
- `port 8090`: Specific port
- `-n`: No DNS resolution
- `-i enp0s2`: Specific interface

### VLC Streaming Modules

| Module | Protocol | Use Case |
|--------|----------|----------|
| **http** | HTTP | Standard streaming |
| **rtp** | RTP | Real-time protocol |
| **udp** | UDP | Low-latency streaming |
| **rtsp** | RTSP | Controlled streaming |

### Muxers (Container Formats)

| Muxer | Format | Description |
|-------|--------|-------------|
| **ts** | MPEG-TS | Most compatible, streaming |
| **ps** | MPEG-PS | DVD-like format |
| **ogg** | Ogg | Open format |
| **mp4** | MP4 | Modern, but not for streaming |

---

## 7. IPv6 Multicast

### Objective
Explore IPv6 multicast streaming with VLC.

### IPv6 Multicast Basics

#### Multicast Address Format
```
FF00::/8 - Multicast prefix
  ├─ FF00-FF0F: Reserved
  ├─ FF10-FF1F: Transient (temporary)
  ├─ FF20-FF2F: Permanent
  └─ FF30-FF3F: Prefix-based

Scope field (4 bits):
  1 = Interface-local
  2 = Link-local
  5 = Site-local
  8 = Organization-local
  E = Global
```

#### Common Multicast Addresses

| Address | Scope | Description |
|---------|-------|-------------|
| **FF02::1** | Link-local | All nodes |
| **FF02::2** | Link-local | All routers |
| **FF15::1** | Site-local | Custom group |
| **FF05::101** | Site-local | NTP servers |

### VLC Multicast Streaming

#### Server (broadcaster)
```bash
cvlc ~/test.mp4 --sout '#udp{dst=[FF15::1]:1234,mux=ts}' --ttl 12
```

**Parameters**:
- `udp`: UDP protocol (required for multicast)
- `FF15::1`: Site-local multicast address
- Port `1234`: Arbitrary port number
- `--ttl 12`: Hop limit for multicast packets

#### Client (receiver)
```bash
smplayer udp://@[FF15::1]:1234
# or
vlc udp://@[FF15::1]:1234
```

**Note**: The `@` symbol indicates joining a multicast group.

### Multicast with SLAAC Routing

For multicast to work across routers, configure multicast routing:

#### On VyOS
```bash
configure
set protocols pim6 interface eth1
commit
save
```

### Testing Multicast

#### Send ICMPv6 ping to all nodes
```bash
ping6 -I enp0s2 ff02::1
```

This pings all IPv6 devices on the link, showing their link-local addresses.

#### Listen for multicast traffic
```bash
sudo tcpdump -i enp0s2 -n 'ip6 multicast'
```

### Multicast Groups

#### View joined multicast groups
```bash
netstat -g6
# or
ip -6 maddr show
```

Output shows:
```
2:	enp0s2
	inet6 ff02::1:ff49:e3ab
	inet6 ff02::1
	inet6 ff01::1
```

### MLDv2 (Multicast Listener Discovery)

IPv6 uses MLDv2 (equivalent to IGMPv3 in IPv4) for multicast group management:

1. **Listener Report**: Host joins group
2. **Listener Done**: Host leaves group
3. **Multicast Listener Query**: Router queries for members

### Troubleshooting Multicast

#### Check if multicast is enabled
```bash
sysctl net.ipv6.conf.all.mc_forwarding
```

#### Verify multicast routing
```bash
ip -6 mroute show
```

#### Monitor MLD messages
```bash
sudo tcpdump -i enp0s2 -n 'icmp6 and ip6[40] == 130 or ip6[40] == 131 or ip6[40] == 132'
```

### Multicast vs Unicast Streaming

| Feature | Unicast | Multicast |
|---------|---------|-----------|
| **Bandwidth** | N × stream size | 1 × stream size |
| **Clients** | Separate connection each | Shared stream |
| **Protocol** | TCP or UDP | UDP only |
| **Reliability** | High | Lower |
| **Scalability** | Poor | Excellent |

---

## Summary of Key IPv6 Concepts

### 1. Address Assignment Methods
- **Static**: Manually configured
- **SLAAC**: Router Advertisement + EUI-64
- **DHCPv6**: Central server (not used in this lab)
- **Privacy Extensions**: Random interface IDs

### 2. Essential Tools
```bash
ip -6 addr show        # View addresses
ip -6 route            # View routes
ping6 <address>        # Test connectivity
ip6tables -L -v        # View firewall
tcpdump -i <if> ip6    # Capture IPv6 traffic
nmap -6 <address>      # Scan IPv6 host
```

### 3. IPv6 in Applications
- Always use square brackets: `http://[::1]/`
- Both numeric and DNS work: `http://[2001::1]/` or `http://example.com/`
- Link-local requires interface: `ping6 fe80::1%eth0`

### 4. Firewall (ip6tables)
```bash
# View rules
sudo ip6tables -L -v

# Block ICMPv6
sudo ip6tables -A OUTPUT -p ipv6-icmp --icmp-type echo-request -d <dest> -j DROP

# Allow established connections
sudo ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Save rules
sudo ip6tables-save > /etc/iptables/rules.v6
```

### 5. Router Advertisements
- Periodic broadcast on link
- Contains prefix, gateway, MTU
- Clients auto-configure using SLAAC
- No DHCP server needed for addresses

### 6. Streaming Protocols
- **Unicast**: One-to-one (HTTP, RTSP)
- **Multicast**: One-to-many (UDP to FF00::/8)
- **Anycast**: One-to-nearest (same address on multiple hosts)

---

## Common Pitfalls and Solutions

### 1. "Address already in use"
**Problem**: Port conflict
```bash
sudo ss -tlnp | grep <port>
sudo systemctl stop <conflicting-service>
```

### 2. "Network is unreachable"
**Problem**: No route to destination
```bash
ip -6 route get <destination>
# Add route if needed:
sudo ip -6 route add <network> via <gateway> dev <interface>
```

### 3. "Cannot assign requested address"
**Problem**: Trying to bind to non-existent address
```bash
ip -6 addr show  # Verify address exists
```

### 4. Firewall blocks traffic
```bash
sudo ip6tables -L -v  # Check rules
sudo ip6tables -F     # Flush all rules (careful!)
```

### 5. Router Advertisements not received
```bash
# Check IPv6 is enabled
sysctl net.ipv6.conf.all.disable_ipv6

# Check accept_ra is enabled
sysctl net.ipv6.conf.enp0s2.accept_ra

# Monitor for RAs
sudo tcpdump -i enp0s2 -n 'icmp6 and ip6[40] == 134'
```

---

## Conclusion

This lab covered:
- ✅ SSH over IPv6 with packet capture
- ✅ IPv6-only Apache web server
- ✅ IPv6 firewall rules with ip6tables
- ✅ VyOS Router Advertisements for SLAAC
- ✅ Linux IPv6 client configuration
- ✅ VLC streaming over IPv6
- ✅ IPv6 multicast concepts

Key takeaways:
1. IPv6 requires square brackets in URLs and configs
2. Router Advertisements enable automatic address configuration
3. ip6tables functions similarly to iptables but for IPv6
4. tcpdump with `ip6` filter shows IPv6 traffic
5. Link-local addresses (fe80::/10) are essential for neighbor discovery
6. Multicast is native to IPv6 and more efficient than unicast for streaming

Remember: IPv6 is not just "IPv4 with more addresses" – it fundamentally changes how networks operate with features like SLAAC, native multicast, and improved routing.
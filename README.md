# Netwerken 3 - Course Materials

## Course Overview
This course covers advanced networking concepts, focusing on enterprise-level networking technologies, security, and modern network implementations. The material is structured to provide both theoretical knowledge and practical implementation skills.

## Course Structure

### Module 1: LAN-WAN Connectivity
- **Router/Firewall Configuration**
  - Cisco vs ADSL vs PC routers
  - Hardware specifications and fail-safe mechanisms
  - Port and IP address management
- **Proxy Technologies**
  - Traditional proxy servers (HTTP accelerator, firewall functions)
  - Transparent proxy implementation
  - SOCKS protocol versions 4, 5, and 6
- **Network Address Translation (NAT/NAPT)**
  - IP mapping techniques
  - Port forwarding and reverse proxy configurations
  - Masquerading and packet rewriting

### Module 2: TCP/IP Deep Dive
- **OSI Layer Analysis**
  - Application layer protocols (TELNET, FTP, TFTP, SMTP, SNMP, HTTP, DHCP)
  - Transport layer protocols (TCP vs UDP)
  - Network and data link layer implementation
- **Packet Structure and Flow**
  - Header analysis and packet encapsulation
  - Port numbering and MAC address resolution
  - ARP and DNS integration

### Module 3: VyOS Router Configuration
- **Open Source Routing**
  - VyOS installation and configuration
  - CLI operations (operational vs configuration mode)
  - Interface configuration (DHCP and static IP)
- **Advanced Features**
  - SSH configuration and remote management
  - Static and dynamic routing (RIP)
  - Firewall rules and NAT configuration
  - IPv6 implementation
  - Version control and rollback capabilities

### Module 4: Firewall Technologies
- **Packet Filtering Fundamentals**
  - TCP conversation management (SYN, ACK, FIN, RST)
  - Anti-spoofing techniques
  - Source routing and ICMP redirect protection
- **Stateful Firewalls**
  - Connection state tracking
  - Cisco reflexive access lists
  - iptables configuration for TCP and UDP
- **Network Segmentation**
  - DMZ (Red LAN) vs Internal (Blue LAN) architecture

### Module 5: High-Speed Modems and Connectivity
- **Connection Types**
  - Synchronous vs Asynchronous communication
  - Multiplexing techniques (FDM, TDM, Statistical TDM, WDM)
  - Duplex communication modes
- **DSL Technologies**
  - ADSL, ADSL2, ADSL2+, VDSL
  - DMT modulation and echo cancellation
  - Distance limitations and DSLAM configuration
- **Cable and Fiber**
  - Cable modem technology and DOCSIS protocols
  - FTTH (Fiber to the Home) implementations
  - HFC (Hybrid Fiber Coax) networks
- **Alternative Technologies**
  - Powerline communication
  - V90/V92 modem standards

### Module 6: Wireless Networking
- **WiFi Standards Evolution**
  - 802.11n (WiFi-4): MIMO and channel bonding
  - 802.11ac (WiFi-5): 256 QAM and 5GHz focus
  - 802.11ax (WiFi-6/6E): OFDM and 6GHz band
- **Network Topologies**
  - Ad-hoc vs Infrastructure mode
  - MANET (Mobile Ad-hoc Networks)
  - B.A.T.M.A.N protocol
- **Hardware Components**
  - Access points (Fat vs Thin AP)
  - Bridges and switching technologies
  - Antenna concepts and gain calculations

### Module 7: Wireless Security
- **Security Evolution**
  - WEP vulnerabilities and limitations
  - WPA improvements and TKIP implementation
  - WPA2 with AES-CCMP encryption
  - WPA3 enhancements and offline attack prevention
- **Authentication Methods**
  - EAP, LEAP, and PEAP protocols
  - 802.1X enterprise authentication
  - RADIUS server integration
- **Key Management**
  - 4-way handshake process
  - Key Reinstallation Attack (KRACK) vulnerabilities
  - Group key distribution

### Module 8: Emerging Wireless Technologies
- **RFID Systems**
  - Active, semi-passive, and passive tags
  - Frequency bands and applications
  - Security considerations and jamming
- **Bluetooth**
  - Protocol stack and service profiles
  - Piconets and scatternets
  - Device pairing and security
- **Infrared Communication**
  - IrDA standards and limitations
  - Line-of-sight requirements

### Module 9: Proxy Servers
- **Proxy Functionality**
  - Client accelerator and HTTP accelerator modes
  - Hierarchical proxy cache systems
  - Disk cache management (HIT/MISS scenarios)
- **Advanced Features**
  - Access Control Lists (ACLs)
  - SOCKS protocol implementation
  - Internet Cache Protocol (ICP)
  - Mail proxy configuration

### Module 10: WAN Protocols
- **ATM (Asynchronous Transfer Mode)**
  - Cell-based switching (53-byte cells)
  - Quality of Service (QoS) guarantees
  - Virtual circuits (PVC vs SVC)
  - AAL (ATM Adaptation Layer) types
- **Frame Relay**
  - Virtual circuits and DLCI addressing
  - CIR (Committed Information Rate)
  - LMI (Local Management Interface)
  - Comparison with X.25
- **MPLS (Multi-Protocol Label Switching)**
  - Label-based forwarding
  - LSR and LER functionality
  - Label Distribution Protocol (LDP)
  - Traffic engineering capabilities

### Module 11: Routing Protocols
- **BGP (Border Gateway Protocol)**
  - Autonomous System (AS) concepts
  - EBGP vs IBGP operations
  - Path selection algorithms
  - Internet routing security issues
- **Real-world Case Studies**
  - YouTube hijack incident (2008)
  - China Telecom incident (2010)
  - Route hijacking mitigation strategies

### Module 12: IPv6 Implementation
- **Address Structure**
  - 128-bit addressing scheme
  - Address types (unicast, anycast, multicast)
  - Address representation and prefixes
- **Configuration Methods**
  - Stateless autoconfiguration
  - DHCPv6 (stateful configuration)
  - Router advertisements and solicitations
- **Security Features**
  - Built-in IPsec support
  - Authentication and encryption headers
  - Mobile IPv6 capabilities

### Module 13: Network Security Monitoring
- **Suricata IDS/IPS**
  - Rule syntax and configuration
  - Threat detection capabilities
  - Network monitoring and analysis
- **Advanced Detection**
  - Malware identification
  - Brute force attack detection
  - Protocol analysis and reconstruction

## Learning Objectives

By the end of this course, students will be able to:

1. **Configure and manage** enterprise-level routers and firewalls
2. **Implement** various WAN technologies and protocols
3. **Design** secure wireless networks with appropriate authentication
4. **Analyze** network traffic and identify security threats
5. **Troubleshoot** complex network connectivity issues
6. **Deploy** IPv6 networks with proper addressing schemes
7. **Understand** the evolution and implementation of modern networking standards

## Prerequisites

- Basic understanding of TCP/IP networking
- Familiarity with OSI model concepts
- Command-line interface experience
- Basic knowledge of network hardware

## Recommended Tools and Software

- **VyOS** - Open source router OS for practical exercises
- **Wireshark** - Network packet analysis
- **Suricata** - Network security monitoring
- **Virtual networking environments** - For lab simulations
- **SSH clients** - For remote router management

## Assessment Methods

- Practical configuration exercises
- Network design projects  
- Security implementation assignments
- Protocol analysis tasks
- Comprehensive final project integrating multiple technologies

## Additional Resources

- VyOS Wiki: https://wiki.vyos.net/
- DANOS Project: https://www.danosproject.org/
- BGP routing tables: http://bgp.potaroo.net/
- IETF RFCs for protocol specifications
- Network security documentation and best practices

---

*This course provides hands-on experience with enterprise networking technologies and prepares students for advanced network administration and security roles.*
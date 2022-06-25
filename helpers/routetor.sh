#!/bin/sh


_tor_uid="debian-tor"
_trans_port=9040                                        # TCP port
_dns_port=9053                                          # DNS port
_virt_addr="10.192.0.0/10"                              # Virt addr for VirtualAddrNetworkIPv4
_non_tor="192.168.0.0/16 172.16.0.0/12 10.0.0.0/8"     # LAN destinations that shouldn't be routed through Tor


### Flush Iptables
iptables -F
iptables -t nat -F

### *nat OUTPUT (For local redirection)

# For the onion addresses
iptables -t nat -A OUTPUT -d $_virt_addr -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j REDIRECT --to-ports $_trans_port

# For the dns requests to Tor
iptables -t nat -A OUTPUT -p udp -m udp --dport 53 -j DNAT --to-destination 127.0.0.1:$_dns_port
iptables -t nat -A OUTPUT -p tcp -m tcp --dport 53 -j DNAT --to-destination 127.0.0.1:$_dns_port

# Don't nat the Tor process or the loopback address
iptables -t nat -A OUTPUT -m owner --uid-owner $_tor_uid -j RETURN
iptables -t nat -A OUTPUT -o lo -j RETURN

# Allow lan access for hosts in _non_tor
for _lan in $_non_tor; do
    iptables -t nat -A OUTPUT -d $_lan -j RETURN
done

# For the rest of the TCP traffic
iptables -t nat -A OUTPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j REDIRECT --to-ports $_trans_port


### *filter INPUT
iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT     # Accept all the established conn
iptables -A INPUT -i lo -j ACCEPT                            # Accept everything from the loopback addr
iptables -A INPUT -j LOG --log-prefix "[FILTER] Dropped INPUT packet: " --log-level 7 --log-uid  # Log the dropped packets
iptables -A INPUT -j DROP                                    # Drop everything else


### *filter FORWARD
iptables -A FORWARD -j DROP # Drop everything


### *filter OUTPUT
iptables -A OUTPUT -m state --state INVALID -j DROP         # Drop all the packets that are in an invalid state
iptables -A OUTPUT -m state --state ESTABLISHED -j ACCEPT   # Accept every conn ESTABLISHED

# Accept all Tor traffic and loopback traffic
iptables -A OUTPUT -m owner --uid-owner $_tor_uid -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m state --state NEW -j ACCEPT
iptables -A OUTPUT -o lo -d 127.0.0.1/32 -j ACCEPT
iptables -A OUTPUT -d 127.0.0.1/32 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN --dport $_trans_port -j ACCEPT

# Drop everything else and also log
iptables -A OUTPUT -j LOG --log-prefix "[FILTER] Dropped OUTPUT packet: " --log-level 7 --log-uid
iptables -A OUTPUT -j DROP


### Set the default policy to DROP for IPv4 and IPv6
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# Uncomment if you want to set the default policies for ipv6 to DROP
#ip6tables -P INPUT DROP
#ip6tables -P FORWARD DROP
#ip6tables -P OUTPUT DROP

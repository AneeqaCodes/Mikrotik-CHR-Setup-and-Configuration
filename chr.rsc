# 2026-01-02 00:10:47 by RouterOS 7.20.6
# system id = zMcto5oAMaI
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
/ip hotspot profile
add hotspot-address=192.168.10.1 name=hsprof1
/ip pool
add name=hotspot-mikrotik ranges=192.168.10.10-192.168.10.100
/ip hotspot
add address-pool=hotspot-mikrotik disabled=no interface=ether2 name=hotspot1 \
    profile=hsprof1
/ip address
add address=192.168.10.1/24 interface=ether2 network=192.168.10.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server
add address-pool=hotspot-mikrotik interface=ether2 name=dhcp2
/ip dhcp-server network
add address=192.168.10.0/24 gateway=192.168.10.0
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=drop chain=forward dst-address-list=1.1.1.1 dst-port=443 protocol=\
    tcp
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=192.168.10.0/24
/ip hotspot user
add name=admin
/radius
add address=35.227.71.209 service=hotspot

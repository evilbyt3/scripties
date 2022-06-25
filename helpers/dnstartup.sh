#!/bin/bash

_Dns_Port=9053
usage()
{
        printf """<Usage> ./dnstartup.sh <option>
                --Tor           [DNS requests will go through Tor]
                --OpenDns       [DNS requests will go through OpenDNS]
                --Custom        [DNS requests will go through the custom server]
               \n"""
}

if   [[ $1 == "--Tor"       ]]; then
        echo "namerserver 127.0.0.1:"$_Dns_Port > /etc/resolv.conf
elif [[ $1 == "--OpenDns"   ]]; then
        echo "nameserver 208.67.222.222" > /etc/resolv.conf
elif [[ $1 == "--Custom"    ]]; then
        printf "Custom DNS server: "
        read server
        if [ $server ]; then
                echo "nameserver " $server > /etc/resolv.conf
        fi
else
        usage
        exit
fi


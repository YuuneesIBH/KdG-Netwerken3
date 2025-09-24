#!/bin/bash
# Loopscript om ICMP pakketten te sturen met nemesis

for i in {1..100}
do
    nemesis-icmp -d enp0s1 -S 192.168.128.24 -D 192.168.128.3
done
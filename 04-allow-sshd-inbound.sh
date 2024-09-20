#!/bin/bash
sudo iptables -A INPUT -p tcp -s 10.100.100.0/24 --dport 22 -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -j DROP
sudo iptables-save | sudo tee /etc/iptables/rules.v4
sudo iptables -L -n -v

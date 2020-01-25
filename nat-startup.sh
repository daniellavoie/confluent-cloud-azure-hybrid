#! /bin/bash
sudo sysctl -w net.ipv4.ip_forward=1
sudo sh -c 'echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf'
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
# Copyright 2020 Nokia
# Licensed under the BSD 3-Clause License.
# SPDX-License-Identifier: BSD-3-Clause

# Start iperf3 server in the background
# with 8 parallel tcp streams, each 200 Kbit/s == 1.6Mbit/s
# using ipv4 interfaces
# -c => client mode, -t => traffic duration, -i => results every 1s, -p port number,
# -B => bind client to local IP, -P => set 8 parallel streams, 
# -b => 200kBps for each stream, -M => Maximum Segment Size 1460 Bytes, 
# & => run in background
iperf3 -c 192.168.1.30 -t 10000 -i 1 -p 5203 -B 192.168.1.10 -P 8 -b 200K -M 1460 &
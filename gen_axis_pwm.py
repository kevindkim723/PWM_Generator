#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: kevin kim, kekim@hmc.edu


generates test vectors for AXI-PWM interface
"""
from random import randrange

MAX_DUT = 100 #max duty cycle
NUM_CHANNEL = 16 #max number of channels


"""
x: number in decimal to convert to binary
n: width of binary signal we desire

returns: binary representation of x with width n

"""
def convB(x,n):
	s = bin(x)[2:]
	return "0"*(n-len(s))+s;

f = open("axis_sim1.tv", "w")

"""
format of each signal: 

0000_0000_00000000_0

UNUSED_CHANNELNUMBER_DUTYCYCLE_DATAREADY
"""
# =============================================================================
# GENERATE DIFF CHANNEL, DIFF DUT
# =============================================================================
lines = ""
for i in range(1000):
	channel = convB((randrange(NUM_CHANNEL)),4)
	dut = convB(randrange(MAX_DUT+1),16)
	lines += f"0000_{channel}_{dut}_{1}\n"
	lines += f"0000_{channel}_{dut}_{0}\n"
	lines += f"0000_{channel}_{dut}_{0}\n"
	lines += f"0000_{channel}_{dut}_{0}\n"
f.write(lines)
f.close()


# =============================================================================
# GENERATE DIFF CHANNEL, SAME DUT
# =============================================================================
f = open("axis_sim2.tv", "w")

lines = ""
dut = convB(randrange(MAX_DUT+1),16)
for i in range(1000):
	channel = convB((randrange(NUM_CHANNEL)),4)
	lines += f"0000_{channel}_{dut}_{1}\n"
	lines += f"0000_{channel}_{dut}_{0}\n"
	lines += f"0000_{channel}_{dut}_{0}\n"
	lines += f"0000_{channel}_{dut}_{0}\n"
f.write(lines)
f.close()

# =============================================================================
# GENERATE ONE CHANNEL, DIFF DUT
# =============================================================================
f = open("axis_sim3.tv", "w")

lines = ""
channel = convB((randrange(NUM_CHANNEL)),4)

for i in range(1000):
	dut = convB(randrange(MAX_DUT+1),16)
	lines += f"0000_{channel}_{dut}_{1}\n"
	lines += f"0000_{channel}_{dut}_{0}\n"
	lines += f"0000_{channel}_{dut}_{0}\n"
	lines += f"0000_{channel}_{dut}_{0}\n"
f.write(lines)
f.close()

# =============================================================================
# GENERATE ONE CHANNEL, SAME DUT
# =============================================================================
f = open("axis_sim4.tv", "w")

lines = ""
dut = convB(randrange(MAX_DUT+1),16)
channel = convB((randrange(NUM_CHANNEL)),4)

for i in range(1000):
	lines += f"0000_{channel}_{dut}_{1}\n"
	lines += f"0000_{channel}_{dut}_{0}\n"
	lines += f"0000_{channel}_{dut}_{0}\n"
	lines += f"0000_{channel}_{dut}_{0}\n"
f.write(lines)
f.close()

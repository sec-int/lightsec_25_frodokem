
# LightSEC 2025 FrodoKEM

This is a verilog implementation of the FrodoKEM algorithm for a paper submitted to LightSEC 2025 conference.

It has a single module (in src/main.v) that can be configured to run the three FrodoKEM schemes FrodoKEM-{640,976,1344}-SHAKE. More specifically, the module can be configured to run any of the three algorithms of FrodoKEM: Key generation, encapsulation and decapsulation. It executes those algorithms one at a time. See the related paper (at TODO) for more information on the FrodoKEM algorithm and on the implementation structure.

## Code Conventions

We use the prefix `o_` for output ports, `i_` for input ports. We use the suffix `__d1` and `__d2` for a signal delayed by one or two clock cycles.

There are two types of bus. The main one has a `canReceive` wire to say if the receiving module can receive data, a `isReady` wire to say that the data is ready, and which can only be set if the `canReceive` is also set. The second type of bus has a `hasAny` to say if the bus has data, and a `consume` that is set by the receiver when they took note of that data. Both can have a `isLast` wire to say if the data stream is ended. 

See the main test file (at test/testAll.v) for information on the usage.

## Implementation

The code targets the AMD/Xilinx FPGA xc7a35Tcsg324-3. It currently produces

Element | #
--- | ---:
LUTs | 12438
FFs | 4060
BRAMs | 8
DSPs | 0

The current timing analysis has a slack of

Slack type | time (ns)
--- | ---:
Setup | 0.217
Hold | 0.076
PW | 4.500


TODO: the following numbers (keygen, encaps) need update.

algorithm | parameter | clock cycles
--- | ---: | ---:
keygen | 640 | 134008
encaps | 640 | 137074
decaps | 640 | 139106
keygen | 976 | 299242
encaps | 976 | 304492
decaps | 976 | 305454
keygen | 1344 | 541000
encaps | 1344 | 548226
decaps | 1344 | 549491


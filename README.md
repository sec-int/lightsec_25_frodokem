
# LightSEC 2025 FrodoKEM

This is a verilog implementation of the FrodoKEM algorithm for a paper submitted to LightSEC 2025 conference.

It has a single module (in src/main.v) that can be configured to run the three FrodoKEM schemes FrodoKEM-{640,976,1344}-SHAKE. More specifically, the module can be configured to run any of the three algorithms of FrodoKEM: Key generation, encapsulation and decapsulation. It executes those algorithms one at a time.

See the related paper (at TODO) for more information.


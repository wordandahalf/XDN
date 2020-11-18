<p align="center"><img src="https://i.imgur.com/S84A9k3.png" alt="XDN Logo" height="100"></p>

---

A simple CPU written in Verilog based on the popular breadboard CPU made by Ben Eater

## Building
Requires `verilator` (I use `4.105 devel rev v4.104-13-g1e7c61b2`) for turning the Verilog source into compilable C++. `gtkwave` is require for tracing.
To build XDN, a simple `make build` can be used. To run it, use `make run`. `make trace` runs the binary and opens GTKWave with the generated VCD.

## Programming
The ISA is not final--opcodes are now a byte long (compared to a nybble in Ben Eater's design) and I would like to research a sane way of encoding operands. The code executed on startup can be found at [`data/ram.hex`](https://github.com/wordandahalf/XDN/blob/master/data/ram.hex). Currently it has the same program that Ben uses to demo the breadboard, adjusted to have byte-long opcodes.

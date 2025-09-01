# Verilog Simulation with Icarus and GTKWave

This project contains Verilog design and testbench files.  
The provided `Makefile` automates compilation, simulation, and waveform viewing.

---

## Requirements

Make sure you have the following installed:

- [Icarus Verilog](http://iverilog.icarus.com/) (`iverilog`, `vvp`)
- [GTKWave](http://gtkwave.sourceforge.net/) (`gtkwave`)
- GNU Make (`make`)

On Ubuntu/Debian you can install them with:

```bash
sudo apt update
sudo apt install iverilog gtkwave make
```

## Usage

Run the following commands under the sim directory:

```
make help     # Show all available targets
make simv     # Compile Verilog sources
make sim      # Run simulation
make view     # Run simulation and open GTKWave
make all      # Compile + run + open GTKWave
make clean    # Remove generated files
```

## Output Files

 - simv → simulation executable
 - *.vcd → waveform dump file (view in GTKWave)
 - cos_output.txt, sin_output.txt → simulation outputs (if generated)

## Note

 - Ensure your testbench includes $dumpfile("tb_top_CORDIC_Engine_v1.vcd"); and $dumpvars; to generate waveforms.
 - Update SRC in the Makefile if you add/remove Verilog files.
 - Run make view to see the waveform results in GTKWave.

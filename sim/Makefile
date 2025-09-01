# Variables
SRC      = tb_top_CORDIC_Engine_v1.v   # your design and testbench files
WAVEFILE = tb_top_CORDIC_Engine_v1.vcd
# Tools
IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave
TESTFILE = cos_output.txt sin_output.txt tb_top_CORDIC_Engine_v1.vcd simv

# Targets
all: sim view

# Compile
simv: $(SRC)
	$(IVERILOG) -g2009 -o simv $(SRC)

# Run simulation
sim: simv
	$(VVP) simv

# Run simulation and open waveform
view: sim
	@if [ -f $(WAVEFILE) ]; then \
		$(GTKWAVE) $(WAVEFILE); \
	else \
		echo "Error: $(WAVEFILE) not found. Did you add $$dumpfile/$$dumpvars in testbench?"; \
	fi

# Clean generated files
clean:
	rm -f $(TESTFILE)

# Help
help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Available targets:"
	@echo "  all     : Compile, run simulation, and open GTKWave"
	@echo "  simv    : Compile the design and testbench"
	@echo "  sim     : Run simulation only"
	@echo "  view    : Run simulation and open GTKWave for waveform viewing"
	@echo "  clean   : Remove generated output files (simv, VCD, txt)"
	@echo "  help    : Show this help message"


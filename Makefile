build:
	mkdir build

build/testbench: build
	ghdl -i --std=08 --workdir=build src/*.vhdl
	ghdl -m --std=08 --workdir=build -o build/testbench testbench

testbench: build/testbench

simulate: build/testbench
	./build/testbench --wave=build/simulation.ghw

clean:
	rm -fr build

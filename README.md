# bashdl
Bash scripts to compile VHDL and Verilog sources. This project is a template that you can use for starting HDL projects. It eases the compilation of libraries.

## Usage
First we assume that you must have at least the following arboresence from root directory :
- bash
- lib
- src
    - rtl
    - bench
Put the `.sh` files into the bash directory

Open a terminal into the `bash` directory and type :

```shell
$ ./com_cmp.sh adder_4 mult_16 counter32
$ ./com_all.sh
```

The first line compiles all the given files in `rtl` directory, it will search for `adder_4.vhd`, `mult_16.vhd` and so on.

If you gave a test bench file in the `bench` directory it will also compile it assuming it's named `adder_4_bench.vhd` and so on.

The second line compules all the files in `rtl` directory and there test bench if these are implemented.
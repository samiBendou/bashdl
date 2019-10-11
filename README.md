# bashdl
Bash scripts to compile VHDL and Verilog sources. It eases the compilation and synthesis of VHDL libraries. This project can be integrated to any VHDL project.

## Usage
First we assume that you have at least the following arboresence from root directory of your project :
- bashdl
- lib
- src
    - rtl
    - bench

The bashdl directory must contain the content of this repository.

### Single file compilation

Open a terminal at the root of the project and go to the `bashdl` directory. Run the script `./com_cmp.sh` to compile components individually

```
$ ./com_cmp.sh adder_4 mult_16 counter32
$ ./com_cmp.sh -s adder_4 
```
The first line compiles all the given files in `rtl` directory, it will search for `adder_4.vhd`, `mult_16.vhd` and so on.
If you gave a test bench file in the `bench` directory it will also compile it assuming it's named `adder_4_bench.vhd` and so on.

The second lines compiles and synthetizes the adder_4 component. You must provide at least a synthetized `adder_4.v` file.

In general the syntax is the following :
```
./com_cmp.sh [-s] [-l LIB_NAME] [-r PROJECT_ROOT] CMP_NAMES
```

**Note** If it doesn't work try `source com_cmp.sh`

### Library compilation

Open a terminal at the root of the project and go to the `bashdl` directory. Run the script `./com_all.sh` to compile all the components in a given directory.

```
$ ./com_all.sh
$ ./com_all.sh -s
$ ./com_all.sh -l lib_thirdparty
```

First second line compiles all the files in `rtl` directory and their test bench if theses are implemented. 

The tird line compiles all the files in the `lib_thirdparty` directory that must be located located in the `src` directory. Benchs files have to be located in the `bench` directory.

In general the syntax is the following :

```
./com_all.sh [-s] [-r PROJECT_ROOT] [-l LIB_NAME]
```kK


**Note** If it doesn't work try `source com_all.sh`
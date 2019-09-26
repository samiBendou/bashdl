# !/bin/source.

# Compile given components

for CMP_NAME in $*
do
    echo ""
    echo "**** $CMP_NAME ****"

    # Compiling source
    echo ""
    echo "Compiling $PROJECT_ROOT/src/rtl/$CMP_NAME.vhd"
    vcom -work lib_rtl $PROJECT_ROOT/src/rtl/$CMP_NAME.vhd

    if [[ `find $PROJECT_ROOT/src/bench/ -name "${CMP_NAME}_bench.vhd" 2> /dev/null` ]]
    then
        echo "Compiling $PROJECT_ROOT/src/bench/${CMP_NAME}_bench.vhd"
        vcom -work lib_bench $PROJECT_ROOT/src/bench/${CMP_NAME}_bench.vhd

    else echo "WARNING: No test bench found for $CMP_NAME" ;
    fi
done

# !/bin/source.

# Compile given components

if [ -z $PROJECT_ROOT ]
then
    PROJECT_ROOT=".."
fi

if [ -z $LIB_NAME ]
then
    LIB_NAME="rtl"
fi

for CMP_NAME in $*
do
    echo ""
    echo "**** $CMP_NAME ****"

    # Compiling source
    echo ""
    echo "Compiling $PROJECT_ROOT/src/$LIB_NAME/$CMP_NAME.vhd"
    vcom -work lib_rtl $PROJECT_ROOT/src/$LIB_NAME/$CMP_NAME.vhd

    if [[ `find $PROJECT_ROOT/src/bench/ -name "${CMP_NAME}_bench.vhd" 2> /dev/null` ]]
    then
        echo "Compiling $PROJECT_ROOT/src/bench/${CMP_NAME}_bench.vhd"
        vcom -work lib_bench $PROJECT_ROOT/src/bench/${CMP_NAME}_bench.vhd

    else echo "WARNING: No test bench found for $CMP_NAME" ;
    fi
done

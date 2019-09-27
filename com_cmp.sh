# !/bin/source.

function usage()
{
  echo "usage: $0 [-s] [-l LIB_NAME] [-r PROJECT_ROOT] CMP_NAMES"
  exit 2
}

OPTIND=1 

# Compile given components

if [ -z $PROJECT_ROOT ]
then
    PROJECT_ROOT=".."
fi

if [ -z $LIB_NAME ]
then
    LIB_NAME="rtl"
fi

DO_SYNTHESIS="FALSE"

while getopts 'h?sl:r:' c
do
  case $c in
    h|\?) usage ;;
    s) DO_SYNTHESIS="TRUE" ;;
    l) LIB_NAME=$OPTARG ;;
    r) PROJECT_ROOT=$OPTARG ;;
  esac
done

shift $((OPTIND-1))

for CMP_NAME in $@
do
    echo ""
    echo "**** $CMP_NAME ****"

    echo ""
    echo "Compiling $PROJECT_ROOT/src/$LIB_NAME/$CMP_NAME.vhd"
    vcom -work lib_rtl $PROJECT_ROOT/src/$LIB_NAME/$CMP_NAME.vhd

    if [[ `find $PROJECT_ROOT/src/bench/ -name "${CMP_NAME}_bench.vhd" 2> /dev/null` ]]
    then
        echo "Compiling $PROJECT_ROOT/src/bench/${CMP_NAME}_bench.vhd"
        vcom -work lib_bench $PROJECT_ROOT/src/bench/${CMP_NAME}_bench.vhd

    else echo "WARNING: No test bench found for $CMP_NAME" ;
    fi

    if [ $DO_SYNTHESIS == "FALSE" ]
    then 
        continue
    fi
    
    if [[ `find $PROJECT_ROOT/src/gates/ -name "${CMP_NAME}.v" 2> /dev/null` ]]
    then
        echo "Compiling $PROJECT_ROOT/src/gates/$CMP_NAME.v"
        vlog -work lib_gates ./src/gates/${CMP_NAME}.v
    else
        echo "ERROR: No synthesis file provided for $CMP_NAME"
        continue
    fi

    if [[ `find $PROJECT_ROOT/src/bench/ -name "${CMP_NAME}_bench.vhd" 2> /dev/null` ]]
    then
        echo "Compiling $PROJECT_ROOT/src/bench/${CMP_NAME}_synth_bench.vhd"
        vcom -work lib_bench ./src/bench/${CMP_NAME}_synth_bench.vhd

    else echo "WARNING: No synthesis test bench found for $CMP_NAME" ;
    fi

done

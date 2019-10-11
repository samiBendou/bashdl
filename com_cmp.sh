# !/bin/source.

function usage()
{
  echo "usage: $0 [-s] [-l LIB_NAME] [-r PROJECT_ROOT] [-b BENCH_SUFIX] CMP_NAMES"
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

if [ -z $BENCH_SUFIX ]
then
    BENCH_SUFIX="bench"
fi

DO_SYNTHESIS="FALSE"

while getopts 'h?sl:r:b:' c
do
  case $c in
    h|\?) usage ;;
    s) DO_SYNTHESIS="TRUE" ;;
    l) LIB_NAME=$OPTARG ;;
    r) PROJECT_ROOT=$OPTARG ;;
    b) BENCH_SUFIX=$OPTARG ;;
  esac
done

shift $((OPTIND-1))

for CMP_NAME in $@
do
    CMP_PATH=$PROJECT_ROOT/src/$LIB_NAME/$CMP_NAME.vhd
    BENCH_PATH=$PROJECT_ROOT/src/$BENCH_SUFIX/${CMP_NAME}_${BENCH_SUFIX}.vhd
    GATE_PATH=$PROJECT_ROOT/src/gates/$CMP_NAME.v
    SYNTH_BENCH_PATH=$PROJECT_ROOT/src/$BENCH_SUFIX/${CMP_NAME}_synth_${BENCH_SUFIX}.vhd

    echo ""
    echo "**** $CMP_NAME ****"

    echo ""
    echo "Compiling $CMP_PATH"
    vcom -work lib_$LIB_NAME $CMP_PATH

    if [[ `find $PROJECT_ROOT/src/$BENCH_SUFIX/ -name "${CMP_NAME}_${BENCH_SUFIX}.vhd" 2> /dev/null` ]]
    then
        echo "Compiling $BENCH_PATH"
        vcom -work lib_$BENCH_SUFIX $BENCH_PATH

    else echo "WARNING: No test bench found for $CMP_NAME at $BENCH_PATH" ;
    fi

    if [ $DO_SYNTHESIS == "FALSE" ]
    then 
        continue
    fi
    
    if [[ `find $PROJECT_ROOT/src/gates/ -name "${CMP_NAME}.v" 2> /dev/null` ]]
    then
        echo "Compiling $GATE_PATH"
        vlog -work lib_gates $GATE_PATH
    else
        echo "ERROR: No synthesis file provided for $CMP_NAME at $GATE_PATH"
        continue
    fi

    if [[ `find $PROJECT_ROOT/src/bench/ -name "${CMP_NAME}_${BENCH_SUFIX}.vhd" 2> /dev/null` ]]
    then
        echo "Compiling $SYNTH_BENCH_PATH"
        vcom -work lib_${BENCH_SUFIX} $SYNTH_BENCH_PATH
    else echo "WARNING: No synthesis test bench found for $CMP_NAME at $SYNTH_BENCH_PATH" ;
    fi

done

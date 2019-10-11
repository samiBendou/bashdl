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
    echo ""
    echo "**** $CMP_NAME ****"

    echo ""
    echo "Compiling $PROJECT_ROOT/src/$LIB_NAME/$CMP_NAME.vhd"
    vcom -work lib_$LIB_NAME $PROJECT_ROOT/src/$LIB_NAME/$CMP_NAME.vhd

    if [[ `find $PROJECT_ROOT/src/${BENCH_SUFIX}/ -name "${CMP_NAME}_${BENCH_SUFIX}.vhd" 2> /dev/null` ]]
    then
        echo "Compiling $PROJECT_ROOT/src/${BENCH_SUFIX}/${CMP_NAME}_${BENCH_SUFIX}.vhd"
        vcom -work lib_${BENCH_SUFIX} $PROJECT_ROOT/src/${BENCH_SUFIX}/${CMP_NAME}_${BENCH_SUFIX}.vhd

    else echo "WARNING: No test bench found for $CMP_NAME at $PROJECT_ROOT/src/${BENCH_SUFIX}/${CMP_NAME}_${BENCH_SUFIX}.vhd" ;
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

    if [[ `find $PROJECT_ROOT/src/bench/ -name "${CMP_NAME}_${BENCH_SUFIX}.vhd" 2> /dev/null` ]]
    then
        echo "Compiling $PROJECT_ROOT/src/bench/${CMP_NAME}_synth_${BENCH_SUFIX}.vhd"
        vcom -work lib_${BENCH_SUFIX} ./src/bench/${CMP_NAME}_synth_${BENCH_SUFIX}.vhd

    else echo "WARNING: No synthesis test bench found for $CMP_NAME" ;
    fi

done

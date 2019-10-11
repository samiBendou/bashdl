# !/bin/source.

# Compile all components in directory

export PROJECT_ROOT=".."
export LIB_NAME="rtl"
export BENCH_SUFIX="bench"
OPTIND=1

function usage()
{
  echo "usage: $0 [-s] [-r PROJECT_ROOT] [-l LIB_NAME]"
  exit 2
}

function deep_count_dep()
{

    DEP_NAMES=`cat $PROJECT_ROOT/src/$LIB_NAME/$1.vhd | grep "^component .*" | sed 's/ *component *//g' 2> /dev/null`
    DEP_COUNT=`echo $DEP_NAMES | wc -w`
    DEEP_DEP_COUNT=$DEP_COUNT
    CHILD_COUNT=0

    if [ $DEP_COUNT == 0 ]
    then
        echo 0
        return
    fi

    for DEP_NAME in $DEP_NAMES
    do
        CHILD_COUNT=$(deep_count_dep $DEP_NAME)
        DEEP_DEP_COUNT=$(($DEEP_DEP_COUNT + $CHILD_COUNT))
    done

    echo $DEEP_DEP_COUNT
}

function sort_by_dep_count()
{
    # Counting the deep number of dependancies for each component 
    for i in $(seq 1 `echo ${CMP_NAMES[@]} | wc -w`)
    do
        DEP_COUNT[i-1]=$(deep_count_dep ${CMP_NAMES[i-1]})
    done

    # Sorting components by number of dependancies
    j=0
    for i in $(seq 2 `echo ${CMP_NAMES[@]} | wc -w`)
    do
        DEP_TMP=${DEP_COUNT[i-1]}
        CMP_TMP=${CMP_NAMES[i-1]}

        j=$((i-1))
        while (($j > 0)) && (( ${DEP_COUNT[j-1]} > $DEP_TMP ))
        do
            DEP_COUNT[j]=${DEP_COUNT[j-1]}
            CMP_NAMES[j]=${CMP_NAMES[j-1]}
            j=$((j-1))
        done
        DEP_COUNT[j]=$DEP_TMP
        CMP_NAMES[j]=$CMP_TMP
    done
    echo ${CMP_NAMES[@]}
}

function clean_lib() 
{
    vdel -lib $PROJECT_ROOT/lib/lib_$1 -all
    vlib $PROJECT_ROOT/lib/lib_$1
    vmap lib_$1 $PROJECT_ROOT/lib/lib_$1
}

OPT_SYNTHESIS=""

while getopts 'h?sl:r:b:' c
do
  case $c in
    h|\?) usage ;;
    l) LIB_NAME=$OPTARG ;;
    s) OPT_SYNTHESIS="-s" ;;
    r) PROJECT_ROOT=$OPTARG ;;
    b) BENCH_SUFIX=$OPTARG ;;
  esac
done

echo ""
echo "** COMPILING FILES IN  $PROJECT_ROOT/src/$LIB_NAME/ **"

echo ""
echo "Searching components..."
CMP_NAMES=(`ls $PROJECT_ROOT/src/$LIB_NAME/ 2> /dev/null | grep ".*.vhd" | cut -d . -f 1`)

if [ -z "${CMP_NAMES[*]}" ]
then
    echo "ERROR: No components found at $PROJECT_ROOT/src/$LIB_NAME/"
    exit 2
fi

echo ${CMP_NAMES[@]}
echo ""
echo "Resolving dependancies..."
CMP_NAMES=`sort_by_dep_count`
echo $CMP_NAMES

echo ""
echo "Cleaning libraries..."
echo "**** $LIB_NAME ****"
`clean_lib $LIB_NAME`
echo "**** $BENCH_SUFIX ****"
`clean_lib $BENCH_SUFIX`
echo "**** gates ****"
`clean_lib gates`


echo ""
echo "Starting compilation..."
NUMBER_OF_FILES=`ls $PROJECT_ROOT/src/$LIB_NAME/ | grep ".*.vhd" | wc -l`
source com_cmp.sh $OPT_SYNTHESIS $CMP_NAMES
echo ""
echo "Number of files compiled : $NUMBER_OF_FILES"
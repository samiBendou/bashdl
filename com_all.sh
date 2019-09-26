# !/bin/source.

# Ca fait la diff

export PROJECT_ROOT=".."

# Compile all components in directory

function deep_count_dependancies()
{
    DEP_NAMES=`cat $PROJECT_ROOT/src/rtl/$1.vhd | grep "component .*" | sed 's/ *component *//g' 2> /dev/null`
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
        CHILD_COUNT=$(deep_count_dependancies $DEP_NAME)
        DEEP_DEP_COUNT=$(($DEEP_DEP_COUNT + $CHILD_COUNT))
    done

    echo $DEEP_DEP_COUNT
}

echo ""
echo "** COMPILING FILES IN  $PROJECT_ROOT/src/rtl/ **"

echo ""
echo "Finding components..."
CMP_NAMES=(`ls $PROJECT_ROOT/src/rtl/ | grep ".*.vhd" | cut -d . -f 1`)
echo ""
echo ${CMP_NAMES[@]}
echo ""
echo "Resolving dependancies..."

# Counting the deep number of dependancies for each component 

for i in $(seq 1 `echo ${CMP_NAMES[@]} | wc -w`)
do
    DEP_COUNT[i-1]=$(deep_count_dependancies ${CMP_NAMES[i-1]})
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

echo ""
echo ${CMP_NAMES[@]}
echo ""
echo "Starting compilation..."
NUMBER_OF_FILES=`ls $PROJECT_ROOT/src/rtl/ | grep ".*.vhd" | wc -l`
source com_cmp.sh ${CMP_NAMES[@]}
echo ""
echo "Number of files compiled : $NUMBER_OF_FILES"
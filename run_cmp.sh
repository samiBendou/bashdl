# !/bin/source.

function usage()
{
  echo "usage: $0 [-r PROJECT_ROOT] [-b BENCH_SUFIX] [-c CONF_SUFIX ] CMP_NAME"
  exit 2
}

OPTIND=1 

# Compile given components

if [ -z $PROJECT_ROOT ]
then
    PROJECT_ROOT=".."
fi

if [ -z $BENCH_SUFIX ]
then
    BENCH_SUFIX="bench"
fi

if [ -z $CONF_SUFIX ]
then
    CONF_SUFIX="conf"
fi

while getopts 'h?r:b:c:' c
do
  case $c in
    h|\?) usage ;;
    r) PROJECT_ROOT=$OPTARG ;;
    b) BENCH_SUFIX=$OPTARG ;;
    c) CONF_SUFIX=$OPTARG ;;
  esac
done

shift $((OPTIND-1))

CMP_NAME=$@
BENCH_NAME=lib_${BENCH_SUFIX}.${CMP_NAME}_${BENCH_SUFIX}_${CONF_SUFIX}
DO_PATH=${PROJECT_ROOT}/src/do/${CMP_NAME}_${BENCH_SUFIX}_wave.do

echo "RUNNING ${BENCH_NAME}"
if [ `find ${DO_PATH}` ]
then
    vsim ${BENCH_NAME} -do ${DO_PATH}
else
    echo "WARNING: No .do file provided at ${DO_PATH}"
    vsim ${BENCH_NAME}
fi
# !/bin/source.

export PROJECT_ROOT=".."

echo ""
echo "** CREATING LIBRARIES **"
echo ""

echo "**** rtl ****"
vdel -lib $PROJECT_ROOT/lib/lib_rtl -all
vlib $PROJECT_ROOT/lib/lib_rtl
vmap lib_rtl $PROJECT_ROOT/lib/lib_rtl

echo "**** bench ****"
vdel -lib $PROJECT_ROOT/lib/lib_bench -all
vlib $PROJECT_ROOT/lib/lib_bench
vmap lib_bench $PROJECT_ROOT/lib/lib_bench
# !/bin/source.

export PROJECT_ROOT=".."

echo "**** ams ****"
vdel -lib $PROJECT_ROOT/lib/lib_ams -all
vlib $PROJECT_ROOT/lib/lib_ams
vmap lib_ams $PROJECT_ROOT/lib/lib_ams

vlog -work lib_ams $PROJECT_ROOT/src/ams/c35_CORELIB.v
vlog -work lib_ams $PROJECT_ROOT/src/ams/c35_CORELIB_3B.v
vlog -work lib_ams $PROJECT_ROOT/src/ams/c35_IOLIB_3B_4M.v
vlog -work lib_ams $PROJECT_ROOT/src/ams/c35_IOLIB_4M.v
vlog -work lib_ams $PROJECT_ROOT/src/ams/c35_IOLIB_ANA_3B_4M.v
vlog -work lib_ams $PROJECT_ROOT/src/ams/c35_IOLIB_ANA_4M.v
vlog -work lib_ams $PROJECT_ROOT/src/ams/c35_IOLIBV5_4M.v
vlog -work lib_ams $PROJECT_ROOT/src/ams/c35_UDP.v




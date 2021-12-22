##########################################################################
# mmslite802.sh                                                          #
# Build file for making MMS-Lite for LINUX, QNX, etc.
# Use the first command line arg ($1) to specify the platform.
# if $1=AIX     Build for the AIX platform
# if $1=LYNX    Build for the LYNX platform
# if $1=LINUX   Build for the LINUX platform (default if $1 is empty)
# if $1=QNX     Build for the QNX platform
# Additional command line args may be (in any order):
#   64		Do 64-bit compile
#   clean	Pass to each make command.
#                                                                        #
# Examples:
#   ./mmslite802.sh LINUX
#   ./mmslite802.sh LINUX clean
#   ./mmslite802.sh LINUX 64
#   ./mmslite802.sh LINUX clean 64
#                                                                        #
# NOTE: ositpxs.mak only works on LINUX.
#       However, it should be usable on other platforms if
#       "clnp_linux.c" is replaced with a file ported to each platform.
#                                                                        #
##########################################################################
# MODIFICATION LOG :                                                     #
#  Date     Who   Rev                   Comments                         #
# --------  ---  ------   -----------------------------------------------#
# 04/14/17  JRB  Do 64-bit compile if command line arg "64" included.
# 01/16/17  JRB  Add mlog lib now used for mmslog.
# 09/19/14  JRB		  Add scl_test
# 02/03/11  JRB		  Del uositcps0, uositpxs0.
# 06/25/10  JRB		  Del obsolete ositp4e library.
# 12/15/09  JRB    18     Del ssec0 library.
#			  Make object directories only if not present.
# 03/17/08  JRB    17     Del old ositcpe, ositpxe libraries
#                         and sreadd, slistend executables.
# 01/18/08  RKR    16     Removed the line that ran mbufcalc
# 05/23/07  LWP    15     Ported to bash Posix
# 03/08/07  JRB    14     Add sositpxs0, uositpxs0.
# 12/01/06  JRB    13     Add ositpxs, smpval, cositpxs0, scl_tpxs0.
# 11/17/06  JRB    12     Add gse_mgmt, gse_mgmt_test
# 11/13/06  JRB    11     Del client, server, uca_srvr sample executables
#                         (they all link to ositcpe lib).
#                         Del "*ositp4e", "*ositpxe" sample executables.
# 08/16/05  RKR    10     Renamed
# 08/15/05  JRB    09     Changed name to make802.sh
# 08/08/05  EJV    08     Added arg $2, and test for correct args
#                         Rem setting AIX compiler mode (see platform.mak)
#                         Export PLATFORM variable once for all makefiles.
# 08/03/05  JRB    07     Add *ositp4e.mak, *ositpxe.mak, iecgoose.mak.
# 08/16/04  JRB    06     Use "X_$1" in "if test" to work w/ NO arg on cmdline
# 08/04/04  EJV    05     Added AIX support.
# 07/19/04  JRB    04     Add scl_srvr.mak.
# 03/15/04  GLB    03     Copy sockets executables to "/usr/bin".
# 11/18/03  JRB    02     Add ositcps_*.a, *ositcps0_ld, ssec0_*.a
#                         Pass PLATFORM=$1 to each make command
#                          to allow use on QNX, etc.
# 12/09/02  CRM    01     Created mkall.sh from QNX script file          #
##########################################################################
##########################################################################
#  MAKE ALL LIBRARIES                                                    #
##########################################################################
# ------------------------------------------------------------------------
#  NOTE: The platform.mak included in every makefile specifies pthreads
#        support if available. There is small performance penalty when
#        multithreading support is enabled.
#        The platform.mak shows how to disable multithreading support.
# ------------------------------------------------------------------------
# check if correct parameters were passed
if [ -z "$1" ]
then
  echo "No command-line arguments. Must specify platform (LINUX, QNX, etc.)"
  exit 0
fi

# additional args may be "clean" or "64"
# if arg is "clean", save it in OPT2 to pass to make commands
# if arg is "64", save it in CC_MODE
if [ -n "$2" ]
then
  if [ "$2" = "clean" ]
  then
    OPT2=clean
  else
    if [ "$2" = "64" ]
    then
      CC_MODE=64
    else
      if [ "$2" = "ARM" ]
      then
#        export CROSS_COMPILE=aarch64-linux-gnu-
	    export CROSSDIR=_arm
	  else
        echo "ERROR: invalid argument: $2"
        exit 0
      fi
    fi
  fi
fi

if [ -n "$3" ]
then
  if [ "$3" = "clean" ]
  then
    OPT2=clean
  else
    if [ "$3" = "64" ]
    then
      CC_MODE=64
    else
      echo "ERROR: invalid argument: $3"
      exit 0
    fi
  fi
fi

if [ "$1" = "LINUX" -o "$1" = "LYNX" -o "$1" = "QNX" -o "$1" = "AIX" ]
then
  PLATFORM=$1
else
  echo "ERROR: unsupported platform: $1"
  exit 0
fi

# export PLATFORM and CC_MODE used by all make files
export PLATFORM=$1
export CC_MODE

if [ "$OPT2" = "clean" ]
then
  rm -f cc.lst
  rm -f foundry.tmp
fi

# johnkim : comment out
#if test "$1" = "LINUX" -o "$1" = "LYNX" -o "$1" = "QNX" -o "$1" = "AIX"; then
#  if test "$2" = "ARM"; then
#    export CROSS_COMPILE=aarch64-linux-gnu-
#	export CROSSDIR=_arm
#  else
#    export CROSS_COMPILE
#	export CROSSDIR
#  fi
#else
#  echo "ERROR: unsupported platform: $1"
#  exit 0
#fi

# make directories
  mkdir -p mmslite_ed2/cmd/gnu/../../lib"$CC_MODE"
  mkdir -p mmslite_ed2/cmd/gnu/../../bin$CROSSDIR

# Make ALL object directories.
  mkdir -p mmslite_ed2/cmd/gnu/obj_l$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_n$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_ld$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_nd$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_mvlu_l$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_mvlu_n$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_mvlu_ld$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_mvlu_nd$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_ositcps_l$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_ositcps_n$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_ositcps_ld$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_ositcps_nd$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_foundry_ld$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_mmslog_ld$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_cositcps0_ld$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_sositcps0_ld$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_scl_srvr_ld$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_scl_test_ld$CROSSDIR
# kjn 2019-09-30 9:46오전
  mkdir -p mmslite_ed2/cmd/gnu/obj_hvdc_scl_srvr_ld$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_hvdc_scl_srvr_n$CROSSDIR
  
  mkdir -p mmslite_ed2/cmd/gnu/obj_ositpxs_l$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_ositpxs_n$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_ositpxs_ld$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_ositpxs_nd$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_cositpxs0_n$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_cositpxs0_ld$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_sositpxs0_ld$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_scl_tpxs0_n$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_scl_tpxs0_ld$CROSSDIR
# kjn 2019-10-08 10:16오전
  mkdir -p mmslite_ed2/cmd/gnu/obj_hvdc_scl_tpxs0_n$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_hvdc_scl_tpxs0_ld$CROSSDIR

  mkdir -p mmslite_ed2/cmd/gnu/obj_iecgoose_ld$CROSSDIR
  mkdir -p mmslite_ed2/cmd/gnu/obj_gse_mgmt_ld$CROSSDIR

# set path to GNU make
if [ "$1" = "AIX" ]
then
  alias make='/usr/local/bin/make'
fi

echo STARTING MAKE OF meml_l.a LIBRARY for $1  >> mmslite_ed2/cmd/gnu/cc.lst 2>&1
#make -f mmslite_ed2/cmd/gnu/meml.mak
#make -f mmslite_ed2/cmd/gnu/meml.mak $OPT2             DFLAG=_l   DEFS=-DDEBUG_SISCO   # logging    / no debug
#echo STARTING MAKE OF meml_n.a LIBRARY for $1  >> cc.lst 2>&1
#make -f meml.mak $OPT2             DFLAG=_n                        # no logging / no debug
#echo STARTING MAKE OF meml_ld.a LIBRARY for $1  >> cc.lst 2>&1
#make -f meml.mak $OPT2      OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#echo STARTING MAKE OF meml_nd.a LIBRARY for $1  >> cc.lst 2>&1
#make -f meml.mak $OPT2      OPT=-g DFLAG=_nd                       # no logging / debug
#
#echo STARTING MAKE OF mem_l.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mem.mak $OPT2              DFLAG=_l   DEFS=-DDEBUG_SISCO   # logging    / no debug
#echo STARTING MAKE OF mem_n.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mem.mak $OPT2              DFLAG=_n                        # no logging / no debug
#echo STARTING MAKE OF mem_ld.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mem.mak $OPT2       OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#echo STARTING MAKE OF mem_nd.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mem.mak $OPT2       OPT=-g DFLAG=_nd                       # no logging / debug
#
#echo STARTING MAKE OF smem_l.a LIBRARY for $1  >> cc.lst 2>&1
#make -f smem.mak $OPT2             DFLAG=_l   DEFS=-DDEBUG_SISCO   # logging    / no debug
#echo STARTING MAKE OF smem_n.a LIBRARY for $1  >> cc.lst 2>&1
#make -f smem.mak $OPT2             DFLAG=_n                        # no logging / no debug
#echo STARTING MAKE OF smem_ld.a LIBRARY for $1  >> cc.lst 2>&1
#make -f smem.mak $OPT2      OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#echo STARTING MAKE OF smem_nd.a LIBRARY for $1  >> cc.lst 2>&1
#make -f smem.mak $OPT2      OPT=-g DFLAG=_nd                       # no logging / debug
#
#echo STARTING MAKE OF slog_l.a LIBRARY for $1  >> cc.lst 2>&1
#make -f slog.mak $OPT2             DFLAG=_l   DEFS=-DDEBUG_SISCO   # logging    / no debug
#echo STARTING MAKE OF slog_n.a LIBRARY for $1  >> cc.lst 2>&1
#make -f slog.mak $OPT2             DFLAG=_n                        # no logging / no debug
#echo STARTING MAKE OF slog_ld.a LIBRARY for $1  >> cc.lst 2>&1
#make -f slog.mak $OPT2      OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#echo STARTING MAKE OF slog_nd.a LIBRARY for $1  >> cc.lst 2>&1
#make -f slog.mak $OPT2      OPT=-g DFLAG=_nd                       # no logging / debug
#
#echo STARTING MAKE OF asn1l_l.a LIBRARY for $1  >> cc.lst 2>&1
#make -f asn1l.mak $OPT2            DFLAG=_l   DEFS=-DDEBUG_SISCO   # logging    / no debug
#echo STARTING MAKE OF asn1l_n.a LIBRARY for $1  >> cc.lst 2>&1
#make -f asn1l.mak $OPT2            DFLAG=_n                        # no logging / no debug
#echo STARTING MAKE OF asn1l_ld.a LIBRARY for $1  >> cc.lst 2>&1
#make -f asn1l.mak $OPT2     OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#echo STARTING MAKE OF asn1l_nd.a LIBRARY for $1  >> cc.lst 2>&1
#make -f asn1l.mak $OPT2     OPT=-g DFLAG=_nd                       # no logging / debug
#
#echo STARTING MAKE OF mmsl_l.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mmsl.mak $OPT2             DFLAG=_l   DEFS=-DDEBUG_SISCO   # logging    / no debug
#echo STARTING MAKE OF mmsl_n.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mmsl.mak $OPT2             DFLAG=_n                        # no logging / no debug
#echo STARTING MAKE OF mmsl_ld.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mmsl.mak $OPT2      OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#echo STARTING MAKE OF mmsl_nd.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mmsl.mak $OPT2      OPT=-g DFLAG=_nd                       # no logging / debug
#
#echo STARTING MAKE OF mmsle_l.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mmsle.mak $OPT2            DFLAG=_l   DEFS=-DDEBUG_SISCO   # logging    / no debug
#echo STARTING MAKE OF mmsle_n.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mmsle.mak $OPT2            DFLAG=_n                        # no logging / no debug
#echo STARTING MAKE OF mmsle_ld.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mmsle.mak $OPT2     OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#echo STARTING MAKE OF mmsle_nd.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mmsle.mak $OPT2     OPT=-g DFLAG=_nd                       # no logging / debug
#
#echo STARTING MAKE OF ositcps_l.a LIBRARY for $1  >> cc.lst 2>&1
#make -f ositcps.mak $OPT2          DFLAG=_l   DEFS=-DDEBUG_SISCO   # logging    / no debug
#echo STARTING MAKE OF ositcps_n.a LIBRARY for $1  >> cc.lst 2>&1
#make -f ositcps.mak $OPT2          DFLAG=_n                        # no logging / no debug
#echo STARTING MAKE OF ositcps_ld.a LIBRARY for $1  >> cc.lst 2>&1
#make -f ositcps.mak $OPT2   OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#echo STARTING MAKE OF ositcps_nd.a LIBRARY for $1  >> cc.lst 2>&1
#make -f ositcps.mak $OPT2   OPT=-g DFLAG=_nd                       # no logging / debug
#
## CANNOT MAKE THESE ON QNX BECAUSE 'TP4' TRANPORT NOT PORTED
#if [ "$1" != "QNX" ]
#then
#
#echo STARTING MAKE OF ositpxs_l.a LIBRARY for $1  >> cc.lst 2>&1
#make -f ositpxs.mak $OPT2        DFLAG=_l   DEFS=-DDEBUG_SISCO   # logging    / no debug
#echo STARTING MAKE OF ositpxs_n.a LIBRARY for $1  >> cc.lst 2>&1
#make -f ositpxs.mak $OPT2        DFLAG=_n                        # no logging / no debug
#echo STARTING MAKE OF ositpxs_ld.a LIBRARY for $1  >> cc.lst 2>&1
#make -f ositpxs.mak $OPT2 OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#echo STARTING MAKE OF ositpxs_nd.a LIBRARY for $1  >> cc.lst 2>&1
#make -f ositpxs.mak $OPT2 OPT=-g DFLAG=_nd                       # no logging / debug
#
#echo STARTING MAKE OF gse_mgmt_l.a LIBRARY for $1  >> cc.lst 2>&1
#make -f gse_mgmt.mak $OPT2        DFLAG=_l   DEFS=-DDEBUG_SISCO   # logging    / no debug
#echo STARTING MAKE OF gse_mgmt_n.a LIBRARY for $1  >> cc.lst 2>&1
#make -f gse_mgmt.mak $OPT2        DFLAG=_n                        # no logging / no debug
#echo STARTING MAKE OF gse_mgmt_ld.a LIBRARY for $1  >> cc.lst 2>&1
#make -f gse_mgmt.mak $OPT2 OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#echo STARTING MAKE OF gse_mgmt_nd.a LIBRARY for $1  >> cc.lst 2>&1
#make -f gse_mgmt.mak $OPT2 OPT=-g DFLAG=_nd                       # no logging / debug
#
#echo STARTING MAKE OF smpval_l.a LIBRARY for $1  >> cc.lst 2>&1
##make -f smpval.mak $OPT2        DFLAG=_l   DEFS=-DDEBUG_SISCO   # logging    / no debug
#make -f smpval_6_2000_1.mak $OPT2        DFLAG=_l   DEFS=-DDEBUG_SISCO   # logging    / no debug
#echo STARTING MAKE OF smpval_n.a LIBRARY for $1  >> cc.lst 2>&1
##make -f smpval.mak $OPT2        DFLAG=_n                        # no logging / no debug
#make -f smpval_6_2000_1.mak $OPT2        DFLAG=_n                        # no logging / no debug
#echo STARTING MAKE OF smpval_ld.a LIBRARY for $1  >> cc.lst 2>&1
##make -f smpval.mak $OPT2 OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#make -f smpval_6_2000_1.mak $OPT2 OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#echo STARTING MAKE OF smpval_nd.a LIBRARY for $1  >> cc.lst 2>&1
##make -f smpval.mak $OPT2 OPT=-g DFLAG=_nd                       # no logging / debug
#make -f smpval_6_2000_1.mak $OPT2 OPT=-g DFLAG=_nd                       # no logging / debug
#
#fi
#
#echo STARTING MAKE OF mvl_l.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mvl.mak $OPT2              DFLAG=_l   DEFS=-DDEBUG_SISCO   # logging    / no debug
#echo STARTING MAKE OF mvl_n.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mvl.mak $OPT2              DFLAG=_n                        # no logging / no debug
#echo STARTING MAKE OF mvl_ld.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mvl.mak $OPT2       OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#echo STARTING MAKE OF mvl_nd.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mvl.mak $OPT2       OPT=-g DFLAG=_nd                       # no logging / debug
#
#echo STARTING MAKE OF mvlu_l.a LIBRARY for $1  >> cc.lst 2>&1
##make -f mvlu.mak $OPT2             DFLAG=_l   DEFS=-DDEBUG_SISCO   # logging    / no debug
#make -f mvlu_6_2000_1.mak $OPT2             DFLAG=_l   DEFS=-DDEBUG_SISCO   # logging    / no debug
#echo STARTING MAKE OF mvlu_n.a LIBRARY for $1  >> cc.lst 2>&1
##make -f mvlu.mak $OPT2             DFLAG=_n                        # no logging / no debug
#make -f mvlu_6_2000_1.mak $OPT2             DFLAG=_n                        # no logging / no debug
#echo STARTING MAKE OF mvlu_ld.a LIBRARY for $1  >> cc.lst 2>&1
##make -f mvlu.mak $OPT2      OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#make -f mvlu_6_2000_1.mak $OPT2      OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#echo STARTING MAKE OF mvlu_nd.a LIBRARY for $1  >> cc.lst 2>&1
##make -f mvlu.mak $OPT2      OPT=-g DFLAG=_nd                       # no logging / debug
#make -f mvlu_6_2000_1.mak $OPT2      OPT=-g DFLAG=_nd                       # no logging / debug
#
#echo STARTING MAKE OF util_l.a LIBRARY for $1  >> cc.lst 2>&1
#make -f util.mak $OPT2             DFLAG=_l   DEFS=-DDEBUG_SISCO   # logging    / no debug
#echo STARTING MAKE OF util_n.a LIBRARY for $1  >> cc.lst 2>&1
#make -f util.mak $OPT2             DFLAG=_n                        # no logging / no debug
#echo STARTING MAKE OF util_ld.a LIBRARY for $1  >> cc.lst 2>&1
#make -f util.mak $OPT2      OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#echo STARTING MAKE OF util_nd.a LIBRARY for $1  >> cc.lst 2>&1
#make -f util.mak $OPT2      OPT=-g DFLAG=_nd                       # no logging / debug
#
#echo STARTING MAKE OF mlogl_l.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mlogl.mak $OPT2            DFLAG=_l   DEFS=-DDEBUG_SISCO   # logging    / no debug
#echo STARTING MAKE OF mlogl_n.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mlogl.mak $OPT2            DFLAG=_n                        # no logging / no debug
#echo STARTING MAKE OF mlogl_ld.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mlogl.mak $OPT2     OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#echo STARTING MAKE OF mlogl_nd.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mlogl.mak $OPT2     OPT=-g DFLAG=_nd                       # no logging / debug
#
#echo STARTING MAKE OF mlog_l.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mlog.mak $OPT2            DFLAG=_l   DEFS=-DDEBUG_SISCO   # logging    / no debug
#echo STARTING MAKE OF mlog_n.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mlog.mak $OPT2            DFLAG=_n                        # no logging / no debug
#echo STARTING MAKE OF mlog_ld.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mlog.mak $OPT2     OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#echo STARTING MAKE OF mlog_nd.a LIBRARY for $1  >> cc.lst 2>&1
#make -f mlog.mak $OPT2     OPT=-g DFLAG=_nd                       # no logging / debug
#
##if [ "$2" != "PPC" ]
#if [ "$2" != "ARM" ]
#then
#echo STARTING MAKE OF findalgn_ld EXECUTABLE for $1 >> cc.lst 2>&1
#make -f findalgn.mak $OPT2  OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#
#echo STARTING MAKE OF foundry_ld EXECUTABLE for $1 >> cc.lst 2>&1
#make -f foundry.mak $OPT2   OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#
#echo STARTING MAKE OF mmslog_ld EXECUTABLE for $1 >> cc.lst 2>&1
#make -f mmslog.mak $OPT2    OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#fi
#
##
## The following executables link to the "ositcps" library.
##
#echo STARTING MAKE OF cositcps0_ld EXECUTABLE for $1 >> cc.lst 2>&1
#make -f cositcps0.mak $OPT2    OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#
#echo STARTING MAKE OF sositcps0_ld EXECUTABLE for $1 >> cc.lst 2>&1
#make -f sositcps0.mak $OPT2    OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#
#
#echo STARTING MAKE OF scl_srvr_ld EXECUTABLE for $1 >> cc.lst 2>&1
#make -f scl_srvr.mak $OPT2     OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#
#echo STARTING MAKE OF scl_test_ld EXECUTABLE for $1 >> cc.lst 2>&1
#make -f scl_test.mak $OPT2     OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#
## kjn 2019-09-30 9:46오전
#echo STARTING MAKE OF hvdc_scl_srvr_ld EXECUTABLE for $1 >> cc.lst 2>&1
#make -f hvdc_scl_srvr.mak $OPT2     OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#echo STARTING MAKE OF hvdc_scl_srvr_n EXECUTABLE for $1 >> cc.lst 2>&1
#make -f hvdc_scl_srvr.mak $OPT2     OPT=-g DFLAG=_n                        # no logging / no debug
#cp ../../mvl/usr/hvdc_scl_srvr/hvdc_scl_srvr_n_arm ../../../user_app/output/Bin/hvdc_scl_srvr_n_arm_ed2
## CANNOT MAKE THESE ON QNX BECAUSE 'TP4' TRANPORT NOT PORTED
#if [ "$1" != "QNX" ]
#then
#
##
## The following executables link to the "ositpxs" library.
##
#echo STARTING MAKE OF cositpxs0_ld EXECUTABLE for $1 >> cc.lst 2>&1
##make -f cositpxs0.mak $OPT2           DFLAG=_n                        # no logging / no debug
##make -f cositpxs0.mak $OPT2    OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
##make -f cositpxs0_6_2000_1.mak $OPT2           DFLAG=_n                        # no logging / no debug
#make -f cositpxs0_6_2000_1.mak $OPT2    OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#
#echo STARTING MAKE OF sositpxs0_ld EXECUTABLE for $1 >> cc.lst 2>&1
#make -f sositpxs0.mak $OPT2    OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#
#echo STARTING MAKE OF scl_tpxs0_ld EXECUTABLE for $1 >> cc.lst 2>&1
##make -f scl_tpxs0.mak $OPT2     OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#make -f scl_tpxs0_6_2000_1.mak $OPT2     OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
## kjn 2019-10-08 10:14오전
#echo STARTING MAKE OF hvdc_scl_tpxs0_ld EXECUTABLE for $1 >> cc.lst 2>&1
#make -f hvdc_scl_tpxs0_6_2000_1.mak $OPT2     OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#
##
## The following executable tests the IEC-61850 GOOSE Framework.
##
#echo STARTING MAKE OF iecgoose_ld EXECUTABLE for $1 >> cc.lst 2>&1
##make -f iecgoose.mak $OPT2  OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#make -f iecgoose_6_2000_1.mak $OPT2  OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#
##
## The following executable tests the IEC 61850 GSE Management.
##
#echo STARTING MAKE OF gse_mgmt_ld EXECUTABLE for $1 >> cc.lst 2>&1
#make -f gse_mgmt_test.mak $OPT2  OPT=-g DFLAG=_ld  DEFS=-DDEBUG_SISCO   # logging    / debug
#
#fi
#

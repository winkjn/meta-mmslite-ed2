SUMMARY = "A simple Hello World application"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
SRC_URI = "file://compile_do.sh"
SRC_URI += "file://scl-srvr.c"

# append : johnkim
MMS_BASE = "${S}/mmslite_ed2/cmd/gnu"

TARGET_CC_ARCH += "${LDFLAGS}"

S = "${WORKDIR}"

do_compile() {
  ${CC} -Wall scl-srvr.c -o scl-srvr
  cp ${THISDIR}/scl-srvr/scl-srvr-sh.c ${S}
  cp ${THISDIR}/scl-srvr/MMSLITE_MAIN ${S}
  cp ${THISDIR}/scl-srvr/SNTP ${S}
  cp ${THISDIR}/scl-srvr/scl_srvr_n_arm_ed2 ${S}
  cp ${THISDIR}/scl-srvr/scl_srvr_ld_arm_ed2 ${S}
  cp ${THISDIR}/scl-srvr/startup_ed2.cfg ${S}
  cp ${THISDIR}/scl-srvr/osicfg_ed2.xml ${S}
  cp ${THISDIR}/scl-srvr/logcfg_ed2.xml ${S}
  cp ${THISDIR}/scl-srvr/datamap.cfg ${S}
  cp ${THISDIR}/scl-srvr/genadsys.cid ${S}
#  cp ${THISDIR}/scl-srvr/mmslite_ed2.tar.bz2 ${S}
#  tar -xvzf mmslite_ed2.tar.bz2
#  rm -rf mmslite_ed2.tar.bz2
#  cp ${THISDIR}/scl-srvr/mmslite802_aarch64_yocto.sh ./mmslite_ed2/cmd/gnu
#  cp ${THISDIR}/scl-srvr/meml.mak ./mmslite_ed2/cmd/gnu
#  cp ${THISDIR}/scl-srvr/platform_aarch64.mak ./mmslite_ed2/cmd/gnu
#  cp ${THISDIR}/scl-srvr/Rules.make ./mmslite_ed2/cmd/gnu
#  echo start compile_do.sh >> johnkimCheck.txt
  ./compile_do.sh
# echo done compile_do.sh >> johnkimCheck.txt
# echo start mmslite_aarc64_yocto.sh >> johnkimCheck.txt
#  ./mmslite_ed2/cmd/gnu/mmslite802_aarch64_yocto.sh LINUX ARM 64
#  echo done mmslite_aarc64_yocto.sh !! >> johnkimCheck.txt
#  ./mmslite_ed2/cmd/gnu/mmslite802_aarch64.sh LINUX ARM 64
#  ${THISDIR}/scl-srvr/compile_do.sh
}

do_install() {
  install -d ${D}${bindir}
  install -m 0755 ${S}/scl-srvr ${D}${bindir}
  install -m 0755 ${S}/scl-srvr-sh ${D}${bindir}
  install -m 0755 ${S}/MMSLITE_MAIN ${D}${bindir}
  install -m 0755 ${S}/SNTP ${D}${bindir}
  install -m 0755 ${S}/scl_srvr_n_arm_ed2 ${D}${bindir}
  install -m 0755 ${S}/scl_srvr_ld_arm_ed2 ${D}${bindir}
  install -m 0755 ${S}/startup_ed2.cfg ${D}${bindir}
  install -m 0755 ${S}/osicfg_ed2.xml ${D}${bindir}
  install -m 0755 ${S}/logcfg_ed2.xml ${D}${bindir}
  install -m 0755 ${S}/datamap.cfg ${D}${bindir}
  install -m 0755 ${S}/genadsys.cid ${D}${bindir}
#  install -m 0755 ${S}/mmslite_ed2/mvl/usr/hvdc_scl_srvr/hvdc_scl_srvr_n_arm ${D}${bindir}
#  echo S : ${S} >> johnkimCheck.txt
#  echo D : ${D} >> johnkimCheck.txt
#  echo MMS_BASE : ${MMS_BASE} >> johnkimCheck.txt
#  echo bindir : ${bindir} >> johnkimCheck.txt
#  echo WORKDIR : ${WORKDIR} >> johnkimCheck.txt
#  echo THISDIR : ${THISDIR} >> johnkimCheck.txt
#  echo LDFLAGS : ${LDFLAGS} >> johnkimCheck.txt
#  cp ${THISDIR}/scl-srvr/hvdc_scl_srvr_ld_arm ${D}${bindir}
#  install -m 0755 ${THISDIR}/scl-srvr/hvdc_scl_srvr_ld_arm ${D}${bindir}
}

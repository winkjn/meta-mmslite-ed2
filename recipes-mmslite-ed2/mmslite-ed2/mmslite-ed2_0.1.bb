SUMMARY = "A simple Hello World application"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
SRC_URI = "file://mmslite-ed2.c"

TARGET_CC_ARCH += "${LDFLAGS}"

S = "${WORKDIR}"

do_compile() {
  ${CC} -Wall mmslite-ed2.c -o mmslite-ed2
#  echo D : ${D} >> chk_mms.txt
#  echo S : ${S} >> chk_mms.txt
}

do_install() {
  install -d ${D}${bindir}
  install -m 0755 ${S}/mmslite-ed2 ${D}${bindir}
}

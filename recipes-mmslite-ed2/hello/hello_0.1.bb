SUMMARY = "A simple Hello World application"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
SRC_URI = "file://hello.c"

TARGET_CC_ARCH += "${LDFLAGS}"

S = "${WORKDIR}"

do_compile() {
  ${CC} -Wall hello.c -o hello
#  cp hello hello-johnkim
#  echo S : ${S} >> johnkimCheck.txt
#  echo D : ${D} >> johnkimCheck.txt
#  echo bindir : ${bindir} >> johnkimCheck.txt
#  echo WORKDIR : ${WORKDIR} >> johnkimCheck.txt
}

do_install() {
  install -d ${D}${bindir}
  install -m 0755 ${S}/hello ${D}${bindir}
  echo S : ${S} >> johnkimCheck.txt
  echo D : ${D} >> johnkimCheck.txt
  echo bindir : ${bindir} >> johnkimCheck.txt
  echo WORKDIR : ${WORKDIR} >> johnkimCheck.txt
}

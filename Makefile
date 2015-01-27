##################################################################
# Directories
# Install dirs
INSTALL_PREFIX = /usr/local

# Full default path is /usr/local/bin
APG_BIN_DIR = /bin

# Full default path is /usr/local/man/man1
APG_MAN_DIR = /man/man1

# Full default path is /usr/local/sbin
APGD_BIN_DIR = /sbin

# Full default path is /usr/local/man/man8
APGD_MAN_DIR = /man/man8

# You should not edit 2 lines below
APGBFM_CLIBS = -lm
APG_CLIBS = -lm

##################################################################
# Support for crypted passwords
# If you do not want to use crypted passwords output then you must
# comment the folowing 2 line.
#
# NOTE#1: You should comment the line 'APG_CLIBS += -lcrypt' for QNX
#         RTP 6.1.0, OpenBSD 2.8 and for WIN32.
#
# NOTE#2: If ld (linker) could not find `crypt' library try to
#         replace line
#           'APG_CLIBS += -lcrypt'
#         with line
#           'APG_CLIBS += -lcrypto'
#         This works on MacOS X
#
STANDALONE_OPTIONS += -DAPG_USE_CRYPT
APG_CLIBS += -lcrypt

##################################################################
# Support for cracklib
# NOTE: Cracklib can be found at
#       http://www.crypticide.org/users/alecm/
# If you want to use cracklib for password quality check then you
# must uncomment the folowing 4 lines (you must not do this for WIN32)
#
#CRACKLIB_DICTPATH = "/usr/local/lib/pw_dict"
#STANDALONE_OPTIONS += -DAPG_USE_CRACKLIB '-DCRACKLIB_DICTPATH=${CRACKLIB_DICTPATH}' -I/usr/local/include -L/usr/local/lib
#CLISERV_OPTIONS += -DAPG_USE_CRACKLIB '-DCRACKLIB_DICTPATH=${CRACKLIB_DICTPATH}' -I/usr/local/include -L/usr/local/lib
#APG_CLIBS += -lcrack

##################################################################
# Support for ANSI X9.17/SHA1 PRNG
# If you want to use SHA1 for random number genetation then you
# must uncomment the folowing 2 lines
#
#STANDALONE_OPTIONS += -DAPG_USE_SHA
#CLISERV_OPTIONS += -DAPG_USE_SHA

##################################################################
# You can modify CC variable if you have compiler other than GCC
# But the code was designed and tested with GCC
CC = gcc

##################################################################
# Compilation flags
# You should comment the line below for AIX+native cc
CFLAGS = -Wall

####################################################################
# If you plan to install APG daemon you should look at lines below #
####################################################################

####################################################################
# FreeBSD
#
# Uncoment NOTHING for FreeBSD
#

####################################################################
# Linux
#
# Uncoment line below for LINUX
#APG_CS_CLIBS += -lnsl

####################################################################
# Solaris
#
# Uncoment line below for Solaris
#APG_CS_CLIBS += -lnsl -lsocket

####################################################################
# QNX RTP 6.1.0
#
# Uncoment line below for QNX RTP 6.1.0
#APG_CS_CLIBS += -lsocket

####################################################################
####################################################################
# THE FOLOWING IS USED BY DEVELOPER AND YOU PROBABLY DO NOT NEED TO
# MODIFY THIS LINE
# STANDALONE_OPTIONS += -DAPG_DEBUG

####################################################################
# ======= YOU DO NOT NEED TO MODIFY ANYTHING BELOW THIS LINE =======
####################################################################

APG_CS_CLIBS += ${APG_CLIBS}

# Find group ID for user root
FIND_GROUP = `grep '^root:' /etc/passwd | awk -F: '{ print $$4 }'`

PROGNAME = apg
CS_PROGNAME = apgd
BFM_PROGNAME = apgbfm
BFM_SOURCES = apgbfm.c bloom.c sha/sha.c errors.c getopt.c convert.c
SOURCES = bloom.c ./sha/sha.c ./cast/cast.c rnd.c pronpass.c \
randpass.c restrict.c errors.c apg.c getopt.c convert.c
HEADERS = owntypes.h pronpass.h randpass.h restrict.h errs.h rnd.h \
./cast/cast.h ./cast/cast_sboxes.h getopt.h convert.h
OBJECTS = rnd.o ./cast/cast.o pronpass.o randpass.o restrict.o apg.o errors.o

standalone: apg apgbfm

all: standalone cliserv

cliserv: apgd apgbfm 

cygwin: standalone

apg:
	${CC} ${CFLAGS} ${STANDALONE_OPTIONS} -o ${PROGNAME} ${SOURCES} ${APG_CLIBS}

apgd:
	${CC} ${CFLAGS} -DCLISERV ${CLISERV_OPTIONS} -o ${CS_PROGNAME} ${SOURCES} ${APG_CS_CLIBS}

apgbfm:
	${CC} ${FLAGS} -DAPGBFM -o ${BFM_PROGNAME} ${BFM_SOURCES} ${APGBFM_CLIBS}

strip:
	strip ${PROGNAME}
	strip ${CS_PROGNAME}
	strip ${BFM_PROGNAME}

install:
	if test -x ./apg; then \
./mkinstalldirs ${INSTALL_PREFIX}${APG_BIN_DIR}; \
./mkinstalldirs ${INSTALL_PREFIX}${APG_MAN_DIR}; \
./install-sh -c -m 0755 -o root -g ${FIND_GROUP} ./apg ${INSTALL_PREFIX}${APG_BIN_DIR}; \
./install-sh -c -m 0444 ./doc/man/apg.1 ${INSTALL_PREFIX}${APG_MAN_DIR}; \
fi
	if test -x ./apgd; then \
./mkinstalldirs ${INSTALL_PREFIX}${APGD_BIN_DIR}; \
./mkinstalldirs ${INSTALL_PREFIX}${APGD_MAN_DIR}; \
./install-sh -c -m 0755 -o root -g ${FIND_GROUP} ./apgd ${INSTALL_PREFIX}${APGD_BIN_DIR}; \
./install-sh -c -m 0444 ./doc/man/apgd.8 ${INSTALL_PREFIX}${APGD_MAN_DIR}; \
fi
	if test -x ./apgbfm; then \
./mkinstalldirs ${INSTALL_PREFIX}${APG_BIN_DIR}; \
./mkinstalldirs ${INSTALL_PREFIX}${APG_MAN_DIR}; \
./install-sh -c -m 0755 -o root -g ${FIND_GROUP} ./apgbfm ${INSTALL_PREFIX}${APG_BIN_DIR}; \
./install-sh -c -m 0444 ./doc/man/apgbfm.1 ${INSTALL_PREFIX}${APG_MAN_DIR}; \
fi

install-cygwin:
	if test -x ./apg.exe; then \
./mkinstalldirs ${INSTALL_PREFIX}${APG_BIN_DIR}; \
./mkinstalldirs ${INSTALL_PREFIX}${APG_MAN_DIR}; \
./install-sh -c -m 0755 ./apg.exe ${INSTALL_PREFIX}${APG_BIN_DIR}; \
./install-sh -c -m 0444 ./doc/man/apg.1 ${INSTALL_PREFIX}${APG_MAN_DIR}; \
fi
	if test -x ./apgbfm.exe; then \
./mkinstalldirs ${INSTALL_PREFIX}${APG_BIN_DIR}; \
./mkinstalldirs ${INSTALL_PREFIX}${APG_MAN_DIR}; \
./install-sh -c -m 0755 ./apgbfm.exe ${INSTALL_PREFIX}${APG_BIN_DIR}; \
./install-sh -c -m 0444 ./doc/man/apgbfm.1 ${INSTALL_PREFIX}${APG_MAN_DIR}; \
fi

clean:
	rm -f ${CS_PROGNAME} ${PROGNAME} ${BFM_PROGNAME} ${OBJECTS} *core*

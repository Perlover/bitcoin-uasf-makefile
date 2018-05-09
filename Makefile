# Copyright (c) 2017 Perlover
# Distributed under the MIT software license, see the accompanying
# file COPYING or http://www.opensource.org/licenses/mit-license.php.

# Makefile for CentOS to compile full bitcoin core node for UASF
# This make does many things under user local folder ( NOT root! ;-) ):
#   Compiling and installing from fresh sources (actual at 2017-06-06):
#   - autotools
#   - pkg-config
#   - libevent
#   - openssl
#   - automake
#   - m4
#   - gcc 7.1
#   - bitcoin core node v0.14.1 with UASF/SegWit patch
# To run from /home/bitcoin/bitcoin-core-makefile for example

SHELL := /bin/bash --login

# MAKE_COMPILE: make or make -jN, where N = amount processors in system - 4
MAKE_COMPILE := $(MAKE) $(shell nproc=$$((`cat /proc/cpuinfo|grep processor|wc -l`-4));nproc=$$(($$nproc<=0?0:$$nproc));if [ $$nproc -le 0 ] ; then echo -n '' ; else echo "-j$$nproc" ; fi)

# For configure script: make variables for implicit rules
CONFIGURE_VARS += LDFLAGS="$(patsubst %,-L%,$(subst :, ,$(shell bash -c '. bitcoin_envs.sh; echo $$LD_LIBRARY_PATH')))"
CONFIGURE_VARS += CPPFLAGS="$(patsubst %,-I%,$(subst :, ,$(shell bash -c '. bitcoin_envs.sh; echo $$CPATH')))"

help:
	@echo $$'*******************************************************************************\n\n  HELP \n\n*******************************************************************************\n'
	@echo $$'make bitcoin-core_install\t- install bitcoind in $$HOME/bin\n'\
	$$'make bitcoin-core_update\t- update already installed bitcoind in $$HOME/bin\n'\
	$$'\n\nFROM ROOT:\n\nmake iptables_install\n\tThe setup of my example iptables config.\n\tToo see the iptables.template file here (there are no bitcoin rules)\n\tBE CAREFULLY! It'\'$$'s risk!\n\n'\
	$$'make bitcoin_iptables_install\n\tpatch iptables config for bitcoin node\n\t(To do after "make iptables_install" for example)\n\tYou will need to press ENTER twice when will be asked!\n\tIf you will not press ENTER twiceyour firewall settings will be reset to full access again\n\t(it prevents from wrong firewall rules through network)\n\n'\
	$$'make [bitcoind-start|bitcoind-stop|bitcoind-restart]\n\tThe helper - to start/stop/restart daemon after installation ;-)\n\n'\
	$$'*******************************************************************************\n'

bitcoind-start:
	nice -n 20 bitcoind -daemon -upnp=0 -maxconnections=500 -maxmempool=100 -mempoolexpiry=24
	@echo "The bitcoind started"

bitcoind-stop:
	bitcoin-cli stop
	@echo "The bitcoind stoped"

bitcoind-restart:
	sleep 5 && $(MAKE) stop && sleep 5 && $(MAKE) start
	@echo "The bitcoind restarted"

.PHONY: start stop restart

include mk/common.mk
include mk/autotools.mk
include mk/gcc.mk
include mk/tools.mk
include mk/libs.mk
include mk/bitcoind.mk
include mk/electrumx.mk
include mk/python3.mk
include mk/python2.mk
include mk/sqlite3.mk
include mk/binutils.mk
include mk/c-lightning.mk
include mk/nodejs.mk
include mk/golang.mk
include mk/lnd.mk
include mk/iptables.mk
include mk/dev-rsync.mk
include mk/zeromq.mk

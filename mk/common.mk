# ~/.bash_profile of .profile patch...
$(HOME)/.bitcoin_envs: bitcoin_envs.sh
	cp -f $< $@
	if [ "x`grep '$(HOME)/.bitcoin_envs' $(PROFILE_FILE)`" = "x" ]; then echo $$'\n. $(HOME)/.bitcoin_envs' >> $(PROFILE_FILE); fi

# ~/.bash_profile of .profile patch...
$(HOME)/.bitcoin_aliases: configs/aliases.sh
	cp -f $< $@
	if [ "x`grep '$(HOME)/.bitcoin_aliases' $(BASHRC_FILE)`" = "x" ]; then echo $$'\n. $(HOME)/.bitcoin_aliases' >> $(BASHRC_FILE); fi

git_submodule_install: .gitmodules
	git submodule update --init --recursive
	@touch $@

this_repo_update:
	git pull
	git submodule update --recursive

MAKE_DIRS += $(HOME)/bin

required_for_configure_install: |\
    $(HOME)/.bitcoin_envs\
    autotools_install\
    autoconf_install\
    gcc_install\
    pkg-config_install
	@touch $@

clean:
	rm -rf build network_*

GENERATE_PASSWORD = $(shell cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $(1) | head -n 1)

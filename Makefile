# User-configurable parameters
GITHUB_ORIGIN_REMOTE_NAME ?= origin


# Constants
SUBMODULES = apis deployment perl-sdk services/*


# User-facing targets
init: parent-repo-remotes $(SUBMODULES)


# Internal implementation targets
verify-github-parameters:
ifndef GITHUB_USERNAME
	$(error GITHUB_USERNAME is required to init. Set GITHUB_USERNAME and try again)
endif
ifndef GITHUB_UPSTREAM_REMOTE_NAME
	$(error GITHUB_UPSTREAM_REMOTE_NAME is required to init. Set GITHUB_UPSTREAM_REMOTE_NAME and try again)
endif

git-submodule-update:
	git submodule update --init

$(SUBMODULES): git-submodule-update
	cd $(CURDIR)/$@ ; git remote rename origin $(GITHUB_UPSTREAM_REMOTE_NAME) ; git remote add $(GITHUB_ORIGIN_REMOTE_NAME) git@github.com/$(GITHUB_USERNAME)/ptero-$(basename $@).git

parent-repo-remotes: verify-github-parameters
	git remote add $(GITHUB_UPSTREAM_REMOTE_NAME) https://github.com/genome/ptero.git

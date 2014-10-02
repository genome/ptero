# Constants
SUBMODULES = apis deployment perl-sdk services/*


# User-facing targets
init: parent-repo-remotes $(SUBMODULES)


# Internal implementation targets
verify-github-parameters:
ifndef GITHUB_USERNAME
	$(error GITHUB_USERNAME is required to init. Set GITHUB_USERNAME and try again)
endif
ifndef GITHUB_PULL_REMOTE_NAME
	$(error GITHUB_PULL_REMOTE_NAME is required to init. Set GITHUB_PULL_REMOTE_NAME and try again)
endif
ifndef GITHUB_PUSH_REMOTE_NAME
	$(error GITHUB_PUSH_REMOTE_NAME is required to init. Set GITHUB_PUSH_REMOTE_NAME and try again)
endif

git-submodule-update:
	$(info Updating git submodules...)
	@git submodule update --init

define git-repo-setup
$(info Setting remotes and git config for $1)
@cd $(CURDIR)/$2 ; git remote | xargs -n 1 git remote remove
@cd $(CURDIR)/$2 ; git remote add $(GITHUB_PULL_REMOTE_NAME) https://github.com/genome/$1.git
@cd $(CURDIR)/$2 ; git remote add $(GITHUB_PUSH_REMOTE_NAME) git@github.com:$(GITHUB_USERNAME)/$1.git
@cd $(CURDIR)/$2 ; git config --replace-all remote.pushdefault $(GITHUB_PUSH_REMOTE_NAME)
@cd $(CURDIR)/$2 ; git config --replace-all push.default current
endef

$(SUBMODULES): git-submodule-update verify-github-parameters
	$(call git-repo-setup,ptero-$(lastword $(subst /, ,$@)),$@)

parent-repo-remotes: verify-github-parameters
	$(call git-repo-setup,ptero,.)

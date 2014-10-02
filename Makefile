# Constants
SUBMODULES = apis deployment perl-sdk services/*


# User-facing targets
all:
	$(info Manage deployment and testing of the PTero system.)
	$(info $())
	$(info Targets:)
	$(info $()  help - Get detailed help.)
	$(info $()  init - Setup git repos.)
	$(info $())
	$(info Examples:)
	$(info $()  make help)
	$(info $()  make init GITHUB_USERNAME=$$USER GITHUB_PULL_REMOTE=upstream GITHUB_PUSH_REMOTE=origin)
	$(info $())

help:
	$(info help)
	$(info $()  Actions:)
	$(info $()    1. Displays this message.)
	$(info $())

	$(info init)
	$(info $()  Actions:)
	$(info $()    1. Updates all submodules.)
	$(info $()    2. Removes all existing remotes from all repos (including the parent repo).)
	$(info $()    3. Sets push and pull remotes for all repos.)
	$(info $()    4. Fetches all branches from both push and pull remotes for all repos.)
	$(info $())
	$(info $()  Required Parameters:)
	$(info $()    GITHUB_USERNAME    - Your username on github.com.)
	$(info $()    GITHUB_PULL_REMOTE - What you want to call the `genome` remote.)
	$(info $()    GITHUB_PUSH_REMOTE - What you want to call the $$GITHUB_USERNAME remote.)
	$(info $())

init: parent-repo-remotes $(SUBMODULES)


# Internal implementation targets
verify-github-parameters:
ifndef GITHUB_USERNAME
	$(error GITHUB_USERNAME is required to init. Set GITHUB_USERNAME and try again)
endif
ifndef GITHUB_PULL_REMOTE
	$(error GITHUB_PULL_REMOTE is required to init. Set GITHUB_PULL_REMOTE and try again)
endif
ifndef GITHUB_PUSH_REMOTE
	$(error GITHUB_PUSH_REMOTE is required to init. Set GITHUB_PUSH_REMOTE and try again)
endif

git-submodule-update:
	$(info Updating git submodules...)
	@git submodule update --init

define git-repo-setup
$(info Setting remotes and git config for $1)
@cd $(CURDIR)/$2 ; git remote | xargs -n 1 git remote remove
@cd $(CURDIR)/$2 ; git remote add $(GITHUB_PULL_REMOTE) https://github.com/genome/$1.git
@cd $(CURDIR)/$2 ; git remote add $(GITHUB_PUSH_REMOTE) git@github.com:$(GITHUB_USERNAME)/$1.git
@cd $(CURDIR)/$2 ; git config --replace-all remote.pushdefault $(GITHUB_PUSH_REMOTE)
@cd $(CURDIR)/$2 ; git config --replace-all push.default current
@cd $(CURDIR)/$2 ; git fetch --all
endef

$(SUBMODULES): git-submodule-update verify-github-parameters
	$(call git-repo-setup,ptero-$(lastword $(subst /, ,$@)),$@)

parent-repo-remotes: verify-github-parameters
	$(call git-repo-setup,ptero)

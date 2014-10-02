# Constants
SUBMODULES = apis deployment perl-sdk services/*
GITHUB_PULL_REMOTE ?= upstream
GITHUB_PUSH_REMOTE ?= origin


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
	$(info $()  make init GITHUB_USERNAME=$$USER)
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
	$(info $()    3. Sets the pull remote for all repos to point at the `genome` organization.)
	$(info $()    4. If GITHUB_USERNAME is specified, sets the push remote for all repos to point at that user's forks.)
	$(info $()    5. Fetches all branches from both push and pull remotes for all repos.)
	$(info $())
	$(info $()  Parameters:)
	$(info $()    GITHUB_PULL_REMOTE - What you want to call the `genome` remote (default: upstream).)
	$(info $()    GITHUB_PUSH_REMOTE - What you want to call the $$GITHUB_USERNAME remote (default: origin).)
	$(info $()    GITHUB_USERNAME    - Your username on github.com (optional).)
	$(info $())

init: parent-repo-remotes $(SUBMODULES)


# Internal implementation targets
git-submodule-update:
	@git submodule update --init

define git-repo-setup
@cd $(CURDIR)/$2 ; git remote | xargs -n 1 git remote remove
@cd $(CURDIR)/$2 ; git remote add $(GITHUB_PULL_REMOTE) https://github.com/genome/$1.git
$(if $(shell curl -f -s -I --head -X HEAD https://api.github.com/repos/$(GITHUB_USERNAME)/$1),
@cd $(CURDIR)/$2 ; git remote add $(GITHUB_PUSH_REMOTE) git@github.com:$(GITHUB_USERNAME)/$1.git ; \
git config --replace-all remote.pushdefault $(GITHUB_PUSH_REMOTE) ; \
git config --replace-all push.default current,
$(warning Warning: Did not find a fork of $1 for user $(GITHUB_USERNAME).)
)

@cd $(CURDIR)/$2 ; git fetch --all &> /dev/null
endef

$(SUBMODULES): git-submodule-update
	$(call git-repo-setup,ptero-$(lastword $(subst /, ,$@)),$@)

parent-repo-remotes:
	$(call git-repo-setup,ptero)

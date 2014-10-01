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
	git submodule update --init

$(SUBMODULES): git-submodule-update verify-github-parameters
	cd $(CURDIR)/$@ ; \
	git remote | xargs -n 1 git remote remove; \
	git remote add $(GITHUB_PULL_REMOTE_NAME) git@github.com/genome/ptero-$(basename $@).git ; \
	git remote add $(GITHUB_PUSH_REMOTE_NAME) git@github.com/$(GITHUB_USERNAME)/ptero-$(basename $@).git

parent-repo-remotes: verify-github-parameters
	git remote | xargs -n 1 git remote remove; \
	git remote add $(GITHUB_PULL_REMOTE_NAME) https://github.com/genome/ptero.git ; \
	git remote add $(GITHUB_PUSH_REMOTE_NAME) https://github.com/$(GITHUB_USERNAME)/ptero.git

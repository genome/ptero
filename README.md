# PTero Workflow Management System

## Setup
The first time you clone this repo, you should run the following command:

```bash
make init GITHUB_USERNAME=<username> GITHUB_PULL_REMOTE=upstream GITHUB_PUSH_REMOTE=origin
```

This will clone all needed submodules and setup remotes for your forks of those
repos.  It will not directly fork those repos on github.

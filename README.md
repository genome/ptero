# PTero Workflow Management System

## Setup
Before starting, you need to install `curl`.  On Ubuntu, try:

```bash
sudo apt-get update
sudo apt-get install curl
```

If you just want to experiment with running PTero, then simply run:

```bash
make init
```

If you want to get started developing PTero, then you should also fork all the
submodule repositories and specify your `GITHUB_USERNAME` before running:

```bash
make init GITHUB_USERNAME=<username>
```

This will clone all needed submodules and setup remotes for your forks of those
repos.  It will not directly fork those repos on github.

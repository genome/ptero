# PTero Workflow Management System

## Getting Started
Before starting, you need to install `curl`.  On Ubuntu, try:

```bash
sudo apt-get update
sudo apt-get install curl
```

If you just want to experiment with running PTero, then simply run:

```bash
./ptero init
```

If you want to get started developing PTero, then you should also fork all the
submodule repositories and specify your [GitHub](https://github.com/) username
before running:

```bash
./ptero init -u <username>
```

This will clone all needed submodules and setup remotes for your forks of those
repos.  It will not directly fork those repos on github.

## Running PTero on Vagrant
Before running PTero on Vagrant, you must make sure Vagrant 1.6 or newer is
installed on your machine.  To setup Vagrant to run PTero, including the
installation of required Vagrant plugins, run this:

```bash
./ptero deploy vagrant init
```

Once Vagrant has been initialized for PTero, run PTero on Vagrant by running
this:

```bash
./ptero deploy vagrant create
```

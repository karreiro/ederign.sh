Developing on the workbench
==========================

Quick start
===========

To work with forks, first fork all repositories on [`scripts/repository-list.txt`](https://github.com/ederign/ederign.sh/tree/master/scripts/repository-list.txt) and [this repository](https://github.com/ederign/ederign.sh) too. Then run:

```shell
$ git clone git@github.com:MY_GITHUB_USERNAME/ederign.sh.git
$ ederign.sh/scripts/git-clone-workbench.sh
$ ederign.sh/scripts/mvn-workbench.sh clean install
```

or:

```shell
$ ederign.sh/scripts/setup-workbench-environment.sh
```
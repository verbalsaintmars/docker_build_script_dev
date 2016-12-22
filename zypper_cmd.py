#!/usr/bin/env python
"""
Referred example:
https://github.com/openSUSE/libzypp-bindings/blob/master/examples/python/SimpleWalkthrough.py

Headers:
https://github.com/openSUSE/libzypp/tree/master/zypp
"""
import zypp


def remove_repo(rm):
    for repo in rm.knownRepositories():
        rm.removeRepository(repo)


def add_repo(rm, repo):
    rm.addRepository(repo)
    rm.refreshMetadata(repo)


def create_repo(name, alias, priority, gpgchk, url):
    repo = zypp.RepoInfo()
    repo.setBaseUrl(zypp.Url(url))
    repo.setEnabled(True)
    repo.setName(name)
    repo.setPriority(priority)
    repo.setAutorefresh(True)
    repo.setGpgCheck(gpgchk)
    repo.setAlias(alias)
    repo.setKeepPackages(False)
    return repo


def update_package(zp):
    # https://github.com/openSUSE/libzypp/blob/master/zypp/Resolver.h
    zp.resolver().doUpdate()


def poolPrintTransaction(zp):
    # https://github.com/openSUSE/libzypp/blob/master/zypp/sat/Transaction.h
    todo = zp.pool().getTransaction()

    for item in todo._toDelete:
        print '-- %s | %s-%s | %s' % \
            (item.repoInfo().alias(),
             item.name(), item.edition(), item.status())

    for item in todo._toInstall:
        print '++ %s | %s-%s | %s' % \
            (item.repoInfo().alias(),
             item.name(), item.edition(), item.status())


def poolInstall(zp, capstr):
    # https://github.com/openSUSE/libzypp/blob/master/zypp/Resolver.h
    # https://github.com/openSUSE/libzypp/blob/master/zypp/Capability.h
    zp.resolver().addRequire(zypp.Capability(capstr))

    if not zp.resolver().resolvePool():
        zp.resolver().undo()


def commit(zp):
    # finally install
    # https://github.com/openSUSE/libzypp/blob/master/zypp/ZYppCommitPolicy.h
    policy = zypp.ZYppCommitPolicy()

    # Kepp pool in sync with the Target databases after commit (default: true)
    policy.syncPoolAfterCommit(True)
    policy.dryRun(False)

    # https://github.com/openSUSE/libzypp/blob/master/zypp/ZYpp.h
    result = zp.commit(policy)
    print result


REPOS = {"C++": ("C++", 1, False, r"http://download.opensuse.org/repositories/devel:/libraries:/c_c++/openSUSE_Leap_42.2/"),
         "Compiler": ("Compiler", 1, False, r"http://download.opensuse.org/repositories/devel:/tools:/compiler/openSUSE_Leap_42.2/"),
         "Python": ("Python", 1, False, r"http://download.opensuse.org/repositories/devel:/languages:/python/openSUSE_Tumbleweed/"),
         "Packman": ("Packman", 1, False, r"http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/"),
         "openSUSE-Tumbleweed-Oss": ("Oss", 3, False, r"http://download.opensuse.org/tumbleweed/repo/oss/"),
         "openSUSE-Tumbleweed-Non-Oss": ("None-Oss", 3, False, r"http://download.opensuse.org/tumbleweed/repo/non-oss/"),
         "openSUSE-Tumbleweed-Update": ("Update", 2, False, r"http://download.opensuse.org/update/tumbleweed/")}


PATTERN = ("devel_basis", "devel_kernel", "devel_C_C++", "devel_python", "devel_rpm_build")


PACKAGES = ("clang",
            "cmake",
            "cscope",
            "curl",
            "git-core",
            "lua-devel",
            "psmisc",
            "python-devel",
            "shadow",
            "sudo",
            "tmux",
            "util-linux",
            "vim",
            "wget",
            "zsh")


if __name__ == "__main__":
    zp = zypp.ZYppFactory_instance().getZYpp()

    # Must init.
    # https://github.com/openSUSE/libzypp/blob/master/zypp/ZYpp.h
    zp.initializeTarget(zypp.Pathname("/"))

    # https://github.com/openSUSE/libzypp/blob/master/zypp/Target.h
    zp.target().load()

    # https://github.com/openSUSE/libzypp/blob/master/zypp/RepoManager.h
    rm = zypp.RepoManager()
    # remove current repos
    remove_repo(rm)

    # add repos
    for name, details in REPOS.iteritems():
        repo = create_repo(
            name, details[0], details[1], details[2], details[3])
        add_repo(rm, repo)

    # Load all enabled repositories
    for repo in rm.knownRepositories():
        if not repo.enabled():
            continue

        if not rm.isCached(repo):
            rm.buildCache(repo)

        rm.loadFromCache(repo)

    # do current packages upgrade
    update_package(zp)
    poolPrintTransaction(zp)
    commit(zp)

    # install packages based on pattern
    for pat in PATTERN:
        poolInstall(zp, "pattern:" + pat)

    poolPrintTransaction(zp)
    commit(zp)

    # install packages
    for package in PACKAGES:
        poolInstall(zp, package)

    poolPrintTransaction(zp)
    commit(zp)

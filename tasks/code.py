import os
import sys

from git import Repo, Actor
from invoke import task


def force_master():
    repo = Repo(os.environ['PROJECT_ROOT'])
    if repo.active_branch.name != 'master':
        sys.exit("Sorry, this command can only be run on master branch.")

@task()
def save(c):
    "Saves changes locally (in git)"
    force_master()
    repo = Repo(os.environ['PROJECT_ROOT'])
    modified_files = [item.a_path for item in repo.index.diff(None) if not item.deleted_file]
    deleted_files = [item.a_path for item in repo.index.diff(None) if item.deleted_file]
    perform_commit = False
    if repo.untracked_files:
        # Generally, all newly creatd files
        print("Saving {} untracked files".format(len(repo.untracked_files)))
        repo.index.add(repo.untracked_files)
        perform_commit = True
    if modified_files:
        # Generally, only files that have previously been committed
        # and subsequently changed will appear in index (as opposed to
        # new files that have been staged)
        print("Saving {} modified files".format(len(modified_files)))
        repo.index.add(modified_files)
        perform_commit = True
    if deleted_files:
        # Students working manually (outside of git) will
        # naturally delete files without removing them from the index
        print("Removing {} deleted files".format(len(deleted_files)))
        repo.index.remove(deleted_files)
        perform_commit = True
    if perform_commit:
        config_reader = repo.config_reader()
        name = config_reader.get_value("user", "name")
        email = config_reader.get_value("user", "email")
        committer = Actor(name, email)
        repo.index.commit("automated commit", author=committer, committer=committer)

@task(save)
def push(c):
    "Saves local work and pushes changes to GitHub"
    print("Pushing changes to GitHub...")
    repo = Repo(os.environ['PROJECT_ROOT'])
    repo.remotes.origin.push()


## Git Commands
### 0. Most Commonly used:
```bash
# clone repo
$ git clone http://github.com/some.repo.git

# add files and push to remote repo
$ git add file1.txt file2.txt ...
$ git commit -m "any words here"
$ git push

# merge local code from remote repo
$ git pull

# other very useful cmd
$ git status  
$ git diff
$ git checkout 
$ git merge
```

### 1. Delete a local branch:
```bash
$ git branch -d local_branch
```
### 2. Delete a remote branch:
 ```bash   
$ git push origin :remote_branch
# or
$ git push origin --delete remote_branch
```
### 3. Syncing a fork
```bash
$ git pull upstream master
# or
$ git fetch upstream
$ git merge upstream/master
```
### 4. Specify a new remote upstream repository that will be synced with the fork.
```bash
$ git remote add upstream https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITROY.git
$ git remote -v
```

### 5. Modify local commit message
```bash
$ git commit --amend -m "your new message"
```
### 6. Modify remote commit message

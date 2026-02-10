# Git Workflow Scripts for fabric-generic-cluster-ansible

Two scripts to help you manage your Git workflow efficiently.

## 📁 Files

- **`git_workflow.sh`** - Full-featured interactive menu system
- **`quick_git.sh`** - Quick command-line shortcuts for common tasks

## 🚀 Quick Start (Recommended for Beginners)

### Initial Setup

```bash
# 1. Make scripts executable
chmod +x git_workflow.sh quick_git.sh

# 2. Clone repo and create your branch
./quick_git.sh setup
# Enter branch name when prompted: feature/ansible-variables

# 3. Make your changes to the files
# (Add your group_vars, host_vars, etc.)

# 4. Push your changes
./quick_git.sh push
# Enter commit message when prompted
```

That's it! The script will give you a URL to create a Pull Request.

## 📋 quick_git.sh - Command Reference

Simple command-line interface for common operations.

### Commands

```bash
# Clone repo and create a branch
./quick_git.sh setup

# Add all changes, commit, and push
./quick_git.sh push

# Sync your branch with latest main
./quick_git.sh sync
```

### Example Workflow

```bash
# Day 1: Start work
./quick_git.sh setup
# Branch: feature/ansible-variables

# Make changes...
# Edit files, create new files, etc.

# Push changes
./quick_git.sh push
# Commit: "Add initial group_vars and host_vars structure"

# Day 2: Continue work
# Make more changes...

./quick_git.sh push
# Commit: "Add verification playbook and documentation"

# Day 3: Sync with main before final push
./quick_git.sh sync
./quick_git.sh push
# Commit: "Final updates after sync with main"
```

## 🎯 git_workflow.sh - Interactive Menu

Full-featured menu system for all git operations.

### Launch

```bash
./git_workflow.sh
```

### Menu Options

```
1)  Clone repository          - Clone the repo for first time
2)  Create new branch         - Create and switch to new branch
3)  Show current status       - Display git status
4)  Add and commit changes    - Stage and commit files
5)  Push branch to origin     - Push commits to GitHub
6)  Pull latest changes       - Pull updates from remote
7)  Switch branch             - Change to different branch
8)  List all branches         - Show local and remote branches
9)  Delete branch             - Remove local/remote branches
10) Full workflow             - Add, commit, and push in one step
0)  Exit
```

### Common Workflows

#### First Time Setup
1. Run `./git_workflow.sh`
2. Choose option `1` - Clone repository
3. Choose option `2` - Create new branch

#### Daily Work
1. Make your changes
2. Choose option `10` - Full workflow (add + commit + push)

#### Check Status
- Choose option `3` - Show current status
- Choose option `8` - List all branches

## 🔧 Detailed Usage Examples

### Example 1: Starting Fresh

```bash
# Run the interactive script
./git_workflow.sh

# Menu appears:
# Choose: 1 (Clone repository)
# Repo will be cloned

# Choose: 2 (Create new branch)
# Enter: feature/ansible-variables
# Branch created and checked out

# Exit menu (0)
# Make your changes...

# Run again
./git_workflow.sh

# Choose: 10 (Full workflow)
# Select: 1 (Add all changes)
# Enter commit message: "Add ansible variables structure"
# Choose: Y (Push to origin)
```

### Example 2: Quick Daily Updates

```bash
# Make changes to files...

./quick_git.sh push
# Enter: "Update database role variables"

# Done! Changes pushed.
```

### Example 3: Creating Multiple Commits

```bash
./git_workflow.sh

# Choose: 4 (Add and commit)
# Select: 2 (Specific files)
# Enter: group_vars/role_database.yml
# Commit: "Update database configuration"

# Make more changes...

# Choose: 4 (Add and commit)
# Select: 1 (All changes)
# Commit: "Add host-specific overrides"

# Choose: 5 (Push to origin)
```

### Example 4: Syncing with Main Branch

```bash
# Using quick script
./quick_git.sh sync

# OR using interactive menu
./git_workflow.sh
# Choose: 7 (Switch branch) -> main
# Choose: 6 (Pull latest changes)
# Choose: 7 (Switch branch) -> your-feature-branch
# Choose: Merge main into current branch (manual)
```

## 🌿 Branch Naming Conventions

Good branch names help organize work:

- **feature/*** - New features
  - `feature/ansible-variables`
  - `feature/monitoring-setup`

- **fix/*** - Bug fixes
  - `fix/inventory-paths`
  - `fix/variable-precedence`

- **docs/*** - Documentation
  - `docs/update-readme`
  - `docs/add-examples`

- **refactor/*** - Code refactoring
  - `refactor/role-structure`

## 📝 Commit Message Best Practices

Good commit messages:
```
✅ "Add group_vars for all OS types"
✅ "Update database role with backup configuration"
✅ "Fix variable precedence in site_DALL"
✅ "Add verification playbook for testing variables"
```

Poor commit messages:
```
❌ "update"
❌ "fix"
❌ "changes"
❌ "wip"
```

## 🔄 Typical Development Workflow

### Option A: Using quick_git.sh (Fastest)

```bash
# Start
./quick_git.sh setup
# Branch: feature/your-feature

# Work → Push cycle
# (make changes)
./quick_git.sh push

# (make more changes)
./quick_git.sh push

# Sync before final push
./quick_git.sh sync
./quick_git.sh push
```

### Option B: Using git_workflow.sh (More Control)

```bash
# Start
./git_workflow.sh
# → 1: Clone
# → 2: Create branch

# Work
# (make changes)
./git_workflow.sh
# → 10: Full workflow

# Or for more control:
./git_workflow.sh
# → 4: Add and commit (specific files)
# → 3: Show status
# → 5: Push to origin
```

## 🎓 Git Concepts Quick Reference

### Branches
- **main/master**: Default branch, production-ready code
- **feature branches**: Your working branches
- Think of branches as parallel universes for your code

### Common Operations
- **clone**: Download repo from GitHub
- **add**: Stage files for commit
- **commit**: Save changes locally
- **push**: Upload commits to GitHub
- **pull**: Download changes from GitHub
- **merge**: Combine branches

### Workflow States
```
Working Directory → Staging Area → Local Repo → Remote Repo
     (edit)      →    (add)      →  (commit)  →   (push)
```

## 🆘 Troubleshooting

### Script won't run
```bash
chmod +x git_workflow.sh quick_git.sh
```

### Can't push - authentication required
```bash
# Configure git credentials
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# May need to set up SSH keys or personal access token
# See: https://docs.github.com/en/authentication
```

### Merge conflicts
```bash
# After pull/merge, if conflicts occur:
# 1. Edit conflicting files manually
# 2. Remove conflict markers (<<<, ===, >>>)
# 3. Run:
git add .
git commit -m "Resolve merge conflicts"
git push
```

### Want to undo last commit (not pushed)
```bash
git reset --soft HEAD~1
# Your changes remain, just uncommitted
```

### Accidentally committed to wrong branch
```bash
# Create new branch from current state
git branch feature/correct-branch

# Reset current branch
git reset --hard HEAD~1

# Switch to new branch
git checkout feature/correct-branch
```

## 🔗 Useful Resources

- Repository: https://github.com/mcevik0/fabric-generic-cluster-ansible
- Create PR: After pushing, the script provides a direct URL
- GitHub Docs: https://docs.github.com/en/pull-requests

## 💡 Pro Tips

1. **Commit often**: Small, focused commits are easier to review
2. **Pull before push**: Avoid conflicts by staying up-to-date
3. **Descriptive messages**: Future you will thank present you
4. **Test before commit**: Make sure changes work
5. **One feature per branch**: Easier to review and merge

## 🎯 Quick Command Cheatsheet

```bash
# Quick workflow
./quick_git.sh setup              # Start new work
./quick_git.sh push               # Save and push
./quick_git.sh sync               # Update from main

# Interactive workflow
./git_workflow.sh                 # Menu appears
# → 10 (full workflow)            # Fastest way to push
# → 3 (status)                    # Check what changed
# → 8 (list branches)             # See all branches

# Manual git commands (if needed)
git status                        # Check current state
git log --oneline                 # View commit history
git branch                        # List local branches
git diff                          # See uncommitted changes
```

## 📧 Getting Help

If you encounter issues:
1. Check `git status` to see current state
2. Check the troubleshooting section above
3. Use the interactive menu's status option (option 3)
4. For GitHub-specific issues, check GitHub's documentation

---

**Happy Coding! 🚀**

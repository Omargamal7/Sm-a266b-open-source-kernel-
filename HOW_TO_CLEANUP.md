# How to Clean Up Your Branches

## Quick Start (Recommended)

I've created a script to automate the cleanup for you. Here's what to do:

### Option 1: Run the Automated Script (Easiest)

1. Make sure you're in the repository root:
   ```bash
   cd /path/to/Sm-a266b-open-source-kernel-
   ```

2. Make the script executable and run it:
   ```bash
   chmod +x cleanup_branches.sh
   ./cleanup_branches.sh
   ```

3. Review the list of branches to be deleted and type `yes` to confirm.

That's it! The script will handle everything.

---

## Option 2: Manual Deletion (Step by Step)

If you prefer to do it manually, follow these steps:

### Step 1: Navigate to Your Repository
```bash
cd /path/to/Sm-a266b-open-source-kernel-
```

### Step 2: Fetch Latest Changes
```bash
git fetch origin
```

### Step 3: Delete Branches One by One

**Merged branches (safe to delete):**
```bash
git push origin --delete copilot/fix-checks-references-issue
git push origin --delete copilot/keep-repo-synced-and-clean
git push origin --delete copilot/sub-pr-27
git push origin --delete copilot/sub-pr-27-again
git push origin --delete copilot/sub-pr-27-another-one
git push origin --delete copilot/update-action-workflows
git push origin --delete copilot/update-kernel-configuration
```

**Abandoned branches (only planning commits, no real work):**
```bash
git push origin --delete copilot/fix-kconfig-issues-again
git push origin --delete copilot/fix-kconfig-issues-yet-again
```

**Development artifact branches (VS Code config only):**
```bash
git push origin --delete patch-wildksu-susfs
```

### Step 4: Clean Up Local References
```bash
git fetch --prune
```

### Step 5: Verify Cleanup
```bash
git branch -r
```

You should now see only:
- `origin/main`
- `origin/copilot/cleanup-accidental-branches` (this current PR branch)

---

## Option 3: Delete Through GitHub Web Interface

You can also delete branches through GitHub's web interface:

1. Go to https://github.com/Omargamal7/Sm-a266b-open-source-kernel-
2. Click on the **branches** link (above the file list, shows number of branches)
3. Find each branch in the list
4. Click the **trash can icon** (🗑️) next to each branch to delete it
5. Confirm the deletion

**Branches to delete:**
- copilot/fix-checks-references-issue
- copilot/keep-repo-synced-and-clean
- copilot/sub-pr-27
- copilot/sub-pr-27-again
- copilot/sub-pr-27-another-one
- copilot/update-action-workflows
- copilot/update-kernel-configuration
- copilot/fix-kconfig-issues-again
- copilot/fix-kconfig-issues-yet-again
- patch-wildksu-susfs

**Branches to keep:**
- main (your primary branch)
- copilot/cleanup-accidental-branches (this current cleanup PR)

---

## What Not to Do (Important!)

### ❌ DON'T Delete These:
- `main` - Your primary development branch
- `copilot/cleanup-accidental-branches` - The current cleanup branch (delete after PR is merged)

### ❌ DON'T Force Push to Main:
Never use `git push --force` on the main branch, as it can cause problems for anyone else working on the repository.

### ❌ DON'T Worry About Making Mistakes:
- Git keeps a reflog of all operations for 90 days
- You can recover deleted branches if needed (see BRANCH_CLEANUP_GUIDE.md)
- These branches are already merged or contain no important work

---

## After Cleanup

Once you've deleted the branches, here's what to do:

### 1. Review the Remaining Branches
```bash
git branch -r
```

You should see only active branches.

### 2. Enable Auto-Delete in GitHub Settings
To prevent future branch accumulation:

1. Go to your repository Settings
2. Scroll to "Pull Requests" section  
3. Check ✅ "Automatically delete head branches"

This will auto-delete branches after their PRs are merged.

### 3. Read the Best Practices Guide
Open `BRANCH_CLEANUP_GUIDE.md` and review the section on "Best Practices to Avoid Accidental Branches."

### 4. Merge This PR
Once you've cleaned up the branches:
1. Review this PR
2. Merge it to add the cleanup guide and .gitignore to your main branch
3. The `copilot/cleanup-accidental-branches` branch will be auto-deleted (if you enabled auto-delete)

---

## Summary of What's Being Deleted

### Total: 10 Branches

**7 Merged Branches** (their changes are already in main):
- ✓ copilot/fix-checks-references-issue
- ✓ copilot/keep-repo-synced-and-clean
- ✓ copilot/sub-pr-27
- ✓ copilot/sub-pr-27-again
- ✓ copilot/sub-pr-27-another-one
- ✓ copilot/update-action-workflows
- ✓ copilot/update-kernel-configuration

**2 Abandoned Branches** (only planning commits, no actual code):
- ✓ copilot/fix-kconfig-issues-again
- ✓ copilot/fix-kconfig-issues-yet-again

**1 Development Artifact** (only VS Code config):
- ✓ patch-wildksu-susfs

**All deletions are safe!** No work will be lost.

---

## Troubleshooting

### "Authentication Failed" Error
Make sure you have:
- Git credentials set up properly
- Permission to delete branches (you should, as the repository owner)
- Try using `gh` CLI: `gh auth login`

### "Branch Not Found" Error
The branch may have already been deleted. That's fine, just skip it.

### Need Help?
If you encounter any issues:
1. Check the BRANCH_CLEANUP_GUIDE.md for more details
2. Run `git status` and `git branch -r` to see current state
3. The cleanup script (`cleanup_branches.sh`) handles errors gracefully

---

## Questions?

**Q: Will I lose any code?**  
A: No! All important changes from these branches are already in `main`. The branches being deleted either have no unique code or only contain planning commits.

**Q: Can I recover a deleted branch?**  
A: Yes, if needed. See the "Recovering a Deleted Branch" section in BRANCH_CLEANUP_GUIDE.md.

**Q: What if I'm not sure about a branch?**  
A: Before deletion, check what it contains:
```bash
git log origin/branch-name --oneline
git diff origin/main...origin/branch-name --stat
```

**Q: How do I prevent this in the future?**  
A: Follow the best practices in BRANCH_CLEANUP_GUIDE.md, especially:
- Enable auto-delete of merged branches
- Delete branches after PR merge
- Use descriptive branch names
- Review branches regularly

---

## Ready to Clean Up?

Choose your preferred method above and get started! The script (Option 1) is the easiest and safest way.

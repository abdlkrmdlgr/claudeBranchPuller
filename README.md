# Git Pull Request Auto-Checkout Script

A bash/zsh function that automatically checks out the newest open Pull Request from your GitHub repository. This script simplifies the workflow of testing and reviewing the latest PR by automatically switching to the PR branch.

## Features

- 🔍 Automatically detects the newest open Pull Request
- ⚡ Quick checkout with a single command
- 🔄 Falls back to standard `git pull` if no PR is found
- 📦 Works with GitHub CLI (`gh`)
- 🎯 Smart branch switching to `main` before PR checkout
- 🔁 **Auto-rebase:** Automatically rebases the PR branch onto the latest base branch (e.g., `main` or `master`)

## Prerequisites

Before using this script, ensure you have:

1. **GitHub CLI (`gh`) installed and authenticated**
   ```bash
   # Install GitHub CLI (macOS)
   brew install gh

   # Authenticate with GitHub
   gh auth login
   ```

2. **Git installed** (usually pre-installed on macOS/Linux)

3. **Bash or Zsh shell**

## Installation

### Method 1: Direct Installation (Recommended)

1. Clone or download this repository:
   ```bash
   git clone https://github.com/abdlkrmdlgr/claudeBranchPuller.git
   cd claudeBranchPuller
   ```

2. Make the script executable:
   ```bash
   chmod +x gpr.sh
   ```

3. **Important:** If your default branch is not `main` (e.g., `master`, `develop`, etc.), you'll need to modify the script before installation. See the [Customization](#customization) section below.

4. Add the function to your shell configuration:

   **For Zsh (macOS default):**
   ```bash
   echo "source $(pwd)/gpr.sh" >> ~/.zshrc
   source ~/.zshrc
   ```

   **For Bash:**
   ```bash
   echo "source $(pwd)/gpr.sh" >> ~/.bashrc
   source ~/.bashrc
   ```

### Method 2: Manual Installation

1. Open your shell configuration file:
   - **Zsh:** `~/.zshrc`
   - **Bash:** `~/.bashrc`

2. Copy and paste the entire `gpr()` function from `gpr.sh` into your configuration file.

3. Save the file and reload your shell:
   ```bash
   # For Zsh
   source ~/.zshrc

   # For Bash
   source ~/.bashrc
   ```

## Usage

Simply navigate to any Git repository and run:

```bash
gpr
```

### What it does:

1. Switches to the default branch (default: `main` - see [Customization](#customization) if your default branch has a different name)
2. Checks for the newest open Pull Request using GitHub CLI
3. If a PR is found:
   - Displays the PR number and branch name
   - Automatically checks out the PR branch
   - **Automatically rebases the PR branch onto the latest base branch** (e.g., `main` or `master`)
   - This ensures the PR branch includes any changes that were merged to the base branch after the PR was opened
4. If no PR is found:
   - Falls back to running `git pull` on the current branch

> **Note:** The script assumes your default branch is named `main`. If your repository uses `master`, `develop`, or another branch name as the default, you'll need to customize the script. See the [Customization](#customization) section below.

### Example Output

When a PR is found:
```
🔍 Checking for the newest open Pull Request...
PR Info: 42    feature/new-feature
🚀 Newest PR found: #42 (feature/new-feature)
⬇️ Fetching the PR locally and switching to this branch...
✅ PR #42 successfully checked out. You are currently on branch 'feature/new-feature'.
🔄 Rebasing 'feature/new-feature' onto 'main'...
✅ Successfully rebased onto 'main'. Branch is now up-to-date!
```

When no PR is found:
```
🔍 Checking for the newest open Pull Request...
PR Info: 
✅ No new active open PR was found.
🔄 Running standard 'git pull' command...
```

## Troubleshooting

### "command not found: gh"
- Make sure GitHub CLI is installed: `brew install gh`
- Verify installation: `gh --version`
- Authenticate: `gh auth login`

### "error: pathspec 'main' did not match any file(s) known to git"
- This means your repository doesn't have a branch named `main`. The script defaults to `main`, but your repository might use `master`, `develop`, or another branch name.
- **Solution:** Customize the script to use your default branch name. See the [Customization](#customization) section below.

### "fatal: not a git repository"
- Make sure you're in a Git repository directory
- Initialize a Git repo if needed: `git init`

### "git switch: command not found"
- Your Git version might be outdated. Update Git:
  ```bash
  brew install git
  ```
- Alternatively, replace `git switch main` with `git checkout main` in the script

### Function not available after installation
- Make sure you've reloaded your shell: `source ~/.zshrc` or `source ~/.bashrc`
- Verify the function is loaded: `type gpr`
- Check if the script path is correct in your configuration file

### Rebase conflicts during PR checkout
- If the PR branch has conflicts with the base branch, the rebase will pause
- You'll see a message: "⚠️ Rebase encountered conflicts. Please resolve them manually."
- To resolve:
  1. Fix the conflicts in the affected files
  2. Stage the resolved files: `git add <file>`
  3. Continue the rebase: `git rebase --continue`
- To abort the rebase and return to the pre-rebase state: `git rebase --abort`

## Customization

### ⚠️ Change Default Branch (Important!)

**The script defaults to `main` branch. If your repository uses a different default branch name (like `master`, `develop`, `trunk`, etc.), you must modify the script before using it.**

To change the default branch, edit the script file (`gpr.sh`) or your shell configuration file and modify the following line:

```bash
# Change this line in gpr.sh:
git switch main

# To your default branch, e.g.:
git switch master
# or
git switch develop
# or
git switch trunk
```

**Example:** If your default branch is `master`:
```bash
# Before:
git switch main

# After:
git switch master
```

After making this change, reload your shell configuration:
```bash
source ~/.zshrc  # or source ~/.bashrc
```

### Modify PR Search

To change the PR search criteria, modify the `gh pr list` command:

```bash
# Example: Search for PRs by a specific author
PR_INFO=$(gh pr list --state open --author "@me" --limit 1 ...)

# Example: Search for PRs with specific labels
PR_INFO=$(gh pr list --state open --label "ready-for-review" --limit 1 ...)
```

## License

This project is open source and available under the [MIT License](LICENSE).

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/abdlkrmdlgr/claudeBranchPuller/issues).

## Author

Created for simplifying GitHub PR checkout workflow.

---

**Note:** This script requires active internet connection to query GitHub API via `gh` CLI.


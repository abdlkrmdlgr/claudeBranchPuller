# Git Pull Request Auto-Checkout Script

A bash/zsh function that automatically checks out the newest open Pull Request from your GitHub repository. This script simplifies the workflow of testing and reviewing the latest PR by automatically switching to the PR branch.

## Features

- 🔍 Automatically detects the newest open Pull Request
- ⚡ Quick checkout with a single command
- 🔄 Falls back to standard `git pull` if no PR is found
- 📦 Works with GitHub CLI (`gh`)
- 🎯 Smart branch switching to `main` before PR checkout

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
   git clone https://github.com/yourusername/claudeBranchPuller.git
   cd claudeBranchPuller
   ```

2. Make the script executable:
   ```bash
   chmod +x gpr.sh
   ```

3. Add the function to your shell configuration:

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

1. Switches to the `main` branch
2. Checks for the newest open Pull Request using GitHub CLI
3. If a PR is found:
   - Displays the PR number and branch name
   - Automatically checks out the PR branch
4. If no PR is found:
   - Falls back to running `git pull` on the current branch

### Example Output

When a PR is found:
```
🔍 Checking for the newest open Pull Request...
PR Info: 42    feature/new-feature
🚀 Newest PR found: #42 (feature/new-feature)
⬇️ Fetching the PR locally and switching to this branch...
✅ PR #42 successfully checked out. You are currently on branch 'feature/new-feature'.
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

## Customization

### Change Default Branch

If your default branch is not `main`, modify the script:

```bash
# Change this line:
git switch main

# To your default branch, e.g.:
git switch master
# or
git switch develop
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

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/yourusername/claudeBranchPuller/issues).

## Author

Created for simplifying GitHub PR checkout workflow.

---

**Note:** This script requires active internet connection to query GitHub API via `gh` CLI.


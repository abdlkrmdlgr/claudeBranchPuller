#!/bin/bash

# gpr - Git Pull Request Checkout Script
# Automatically checks out the newest open Pull Request from GitHub
# Author: https://github.com/abdlkrmdlgr

function gpr() {
  echo "🔍 Checking for the newest open Pull Request..."

  git switch main

  # The gh command finds the newest PR (number and branch name)
  PR_INFO=$(gh pr list --state open --limit 1 --json number,headRefName --template '{{range .}}{{.number}}{{"\t"}}{{.headRefName}}{{end}}' 2>/dev/null)

  echo "PR Info: $PR_INFO"

  if [ -z "$PR_INFO" ]; then
    echo "✅ No new active open PR was found."
    echo "🔄 Running standard 'git pull' command..."
    git pull
  else
    read -r PR_NUMBER PR_BRANCH_NAME <<< "$PR_INFO"

    echo "🚀 Newest PR found: #$PR_NUMBER ($PR_BRANCH_NAME)"
    echo "⬇️ Fetching the PR locally and switching to this branch..."

    gh pr checkout "$PR_NUMBER"

    if [ $? -ne 0 ]; then
      echo "⚠️ An error occurred while checking out PR #$PR_NUMBER."
    else
      echo "✅ PR #$PR_NUMBER successfully checked out. You are currently on branch '$PR_BRANCH_NAME'."
    fi
  fi
}


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

      # Get the base branch of the PR
      BASE_BRANCH=$(gh pr view "$PR_NUMBER" --json baseRefName --template '{{.baseRefName}}' 2>/dev/null)

      if [ -n "$BASE_BRANCH" ]; then
        echo "🔄 Rebasing '$PR_BRANCH_NAME' onto '$BASE_BRANCH'..."

        # Fetch the latest changes from the base branch
        git fetch origin "$BASE_BRANCH"

        if [ $? -ne 0 ]; then
          echo "⚠️ Failed to fetch updates from '$BASE_BRANCH'."
        else
          # Rebase the PR branch onto the base branch
          git rebase "origin/$BASE_BRANCH"

          if [ $? -ne 0 ]; then
            echo "⚠️ Rebase encountered conflicts. Please resolve them manually."
            echo "💡 After resolving conflicts, run: git rebase --continue"
            echo "💡 To abort the rebase, run: git rebase --abort"
          else
            echo "✅ Successfully rebased onto '$BASE_BRANCH'. Branch is now up-to-date!"
          fi
        fi
      else
        echo "⚠️ Could not determine base branch for PR #$PR_NUMBER."
      fi
    fi
  fi
}


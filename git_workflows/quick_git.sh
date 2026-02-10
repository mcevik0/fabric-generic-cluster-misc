#!/bin/bash
# quick_git.sh
# Quick git commands for common workflows

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

REPO_URL="https://github.com/mcevik0/fabric-generic-cluster-ansible.git"
GITHUB_USERNAME="mcevik0"
REPO_NAME="fabric-generic-cluster-ansible"

# Function to setup (clone and create branch)
quick_setup() {
    echo -e "${YELLOW}Quick Setup: Clone and Create Branch${NC}"

    read -p "Enter branch name (e.g., feature/ansible-variables): " branch_name

    if [ -z "$branch_name" ]; then
        echo "Branch name required!"
        exit 1
    fi

    echo -e "${CYAN}Step 1: Cloning repository...${NC}"
    git clone "$REPO_URL"
    cd "$REPO_NAME"

    echo -e "${CYAN}Step 2: Creating branch '$branch_name'...${NC}"
    git checkout -b "$branch_name"

    echo -e "${GREEN}✓ Setup complete!${NC}"
    echo -e "${BLUE}You are now on branch: $branch_name${NC}"
    echo -e "${YELLOW}Next: Make your changes, then run: ./quick_git.sh push${NC}"
}

# Function to push changes
quick_push() {
    echo -e "${YELLOW}Quick Push: Add, Commit, and Push${NC}"

    current_branch=$(git branch --show-current)
    echo -e "Current branch: ${CYAN}$current_branch${NC}"

    read -p "Commit message: " commit_msg

    if [ -z "$commit_msg" ]; then
        echo "Commit message required!"
        exit 1
    fi

    echo -e "${CYAN}Adding all changes...${NC}"
    git add .

    echo -e "${CYAN}Committing...${NC}"
    git commit -m "$commit_msg"

    echo -e "${CYAN}Pushing to origin...${NC}"
    git push -u origin "$current_branch"

    echo -e "${GREEN}✓ Changes pushed!${NC}"
    echo ""
    echo -e "${CYAN}Create Pull Request:${NC}"
    echo -e "${BLUE}https://github.com/$GITHUB_USERNAME/$REPO_NAME/compare/$current_branch?expand=1${NC}"
}

# Function to sync with main
quick_sync() {
    echo -e "${YELLOW}Quick Sync: Pull latest from main${NC}"

    current_branch=$(git branch --show-current)

    echo -e "${CYAN}Fetching latest...${NC}"
    git fetch origin

    echo -e "${CYAN}Switching to main...${NC}"
    git checkout main

    echo -e "${CYAN}Pulling latest main...${NC}"
    git pull origin main

    echo -e "${CYAN}Switching back to $current_branch...${NC}"
    git checkout "$current_branch"

    echo -e "${CYAN}Merging main into $current_branch...${NC}"
    git merge main

    echo -e "${GREEN}✓ Synced with main!${NC}"
}

# Main
case "$1" in
    setup)
        quick_setup
        ;;
    push)
        quick_push
        ;;
    sync)
        quick_sync
        ;;
    *)
        echo "Usage:"
        echo "  $0 setup    - Clone repo and create a new branch"
        echo "  $0 push     - Add, commit, and push changes"
        echo "  $0 sync     - Sync current branch with latest main"
        echo ""
        echo "Examples:"
        echo "  $0 setup"
        echo "  $0 push"
        exit 1
        ;;
esac

#!/bin/bash
# git_workflow.sh
# Script to manage git workflow for fabric-generic-cluster-ansible repository

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/mcevik0/fabric-generic-cluster-ansible.git"
GITHUB_USERNAME="mcevik0"
REPO_NAME="fabric-generic-cluster-ansible"
DEFAULT_BRANCH="main"  # Change to 'master' if that's your default branch

# Function to display menu
show_menu() {
    echo ""
    echo -e "${CYAN}=====================================${NC}"
    echo -e "${CYAN}  Git Workflow Manager${NC}"
    echo -e "${CYAN}=====================================${NC}"
    echo ""
    echo "1) Clone repository"
    echo "2) Create new branch"
    echo "3) Show current status"
    echo "4) Add and commit changes"
    echo "5) Push branch to origin"
    echo "6) Pull latest changes"
    echo "7) Switch branch"
    echo "8) List all branches"
    echo "9) Delete branch"
    echo "10) Full workflow (add, commit, push)"
    echo "0) Exit"
    echo ""
}

# Function to clone repository
clone_repo() {
    echo -e "${YELLOW}Cloning repository...${NC}"

    if [ -d "$REPO_NAME" ]; then
        echo -e "${RED}Directory $REPO_NAME already exists!${NC}"
        read -p "Do you want to remove it and clone fresh? (y/N): " choice
        if [[ $choice =~ ^[Yy]$ ]]; then
            rm -rf "$REPO_NAME"
        else
            echo -e "${YELLOW}Skipping clone.${NC}"
            return
        fi
    fi

    git clone "$REPO_URL"
    cd "$REPO_NAME"

    echo -e "${GREEN}Repository cloned successfully!${NC}"
    echo -e "${BLUE}Current directory: $(pwd)${NC}"

    # Configure git user if not set
    if [ -z "$(git config user.name)" ]; then
        echo ""
        read -p "Enter your Git name: " git_name
        read -p "Enter your Git email: " git_email
        git config user.name "$git_name"
        git config user.email "$git_email"
        echo -e "${GREEN}Git user configured locally.${NC}"
    fi
}

# Function to create new branch
create_branch() {
    echo -e "${YELLOW}Create new branch${NC}"
    echo ""

    # Show current branch
    current_branch=$(git branch --show-current 2>/dev/null || echo "Not in a git repo")
    echo -e "Current branch: ${CYAN}$current_branch${NC}"
    echo ""

    # Get branch name
    read -p "Enter new branch name (e.g., feature/ansible-variables): " branch_name

    if [ -z "$branch_name" ]; then
        echo -e "${RED}Branch name cannot be empty!${NC}"
        return
    fi

    # Check if branch already exists
    if git rev-parse --verify "$branch_name" >/dev/null 2>&1; then
        echo -e "${RED}Branch '$branch_name' already exists!${NC}"
        read -p "Do you want to switch to it? (y/N): " choice
        if [[ $choice =~ ^[Yy]$ ]]; then
            git checkout "$branch_name"
            echo -e "${GREEN}Switched to existing branch '$branch_name'${NC}"
        fi
        return
    fi

    # Ask if they want to base it on current branch or main
    echo ""
    echo "Base new branch on:"
    echo "1) Current branch ($current_branch)"
    echo "2) $DEFAULT_BRANCH (after pulling latest)"
    read -p "Choice (1/2): " base_choice

    if [ "$base_choice" = "2" ]; then
        echo -e "${YELLOW}Switching to $DEFAULT_BRANCH and pulling latest...${NC}"
        git checkout "$DEFAULT_BRANCH"
        git pull origin "$DEFAULT_BRANCH"
    fi

    # Create and checkout new branch
    git checkout -b "$branch_name"
    echo -e "${GREEN}Created and switched to new branch: $branch_name${NC}"
}

# Function to show status
show_status() {
    echo -e "${YELLOW}Git Status:${NC}"
    echo ""

    current_branch=$(git branch --show-current)
    echo -e "Current branch: ${CYAN}$current_branch${NC}"
    echo ""

    git status
}

# Function to add and commit
add_commit() {
    echo -e "${YELLOW}Add and commit changes${NC}"
    echo ""

    # Show current status
    git status
    echo ""

    # Ask what to add
    echo "What would you like to add?"
    echo "1) All changes (git add .)"
    echo "2) Specific files"
    echo "3) Interactive (git add -p)"
    read -p "Choice (1/2/3): " add_choice

    case $add_choice in
        1)
            git add .
            echo -e "${GREEN}Added all changes${NC}"
            ;;
        2)
            read -p "Enter file paths (space-separated): " files
            git add $files
            echo -e "${GREEN}Added specified files${NC}"
            ;;
        3)
            git add -p
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            return
            ;;
    esac

    echo ""
    git status
    echo ""

    # Get commit message
    read -p "Enter commit message: " commit_msg

    if [ -z "$commit_msg" ]; then
        echo -e "${RED}Commit message cannot be empty!${NC}"
        return
    fi

    git commit -m "$commit_msg"
    echo -e "${GREEN}Changes committed successfully!${NC}"
}

# Function to push to origin
push_to_origin() {
    echo -e "${YELLOW}Push to origin${NC}"
    echo ""

    current_branch=$(git branch --show-current)
    echo -e "Current branch: ${CYAN}$current_branch${NC}"
    echo ""

    # Check if there are commits to push
    if ! git log origin/"$current_branch".."$current_branch" >/dev/null 2>&1; then
        # Branch doesn't exist on remote
        echo -e "${YELLOW}Branch '$current_branch' doesn't exist on remote yet.${NC}"
        read -p "Push and set upstream? (Y/n): " choice
        if [[ ! $choice =~ ^[Nn]$ ]]; then
            git push -u origin "$current_branch"
            echo -e "${GREEN}Branch pushed and upstream set!${NC}"
        fi
    else
        # Check if there are commits to push
        commits_ahead=$(git rev-list --count origin/"$current_branch".."$current_branch" 2>/dev/null || echo "0")

        if [ "$commits_ahead" -eq 0 ]; then
            echo -e "${YELLOW}No new commits to push.${NC}"
            return
        fi

        echo -e "${CYAN}$commits_ahead commit(s) ready to push${NC}"
        echo ""
        git log origin/"$current_branch".."$current_branch" --oneline
        echo ""

        read -p "Push these commits? (Y/n): " choice
        if [[ ! $choice =~ ^[Nn]$ ]]; then
            git push
            echo -e "${GREEN}Changes pushed successfully!${NC}"
        fi
    fi

    # Provide GitHub URL for creating PR
    echo ""
    echo -e "${CYAN}To create a Pull Request, visit:${NC}"
    echo -e "${BLUE}https://github.com/$GITHUB_USERNAME/$REPO_NAME/compare/$current_branch?expand=1${NC}"
}

# Function to pull latest changes
pull_changes() {
    echo -e "${YELLOW}Pull latest changes${NC}"
    echo ""

    current_branch=$(git branch --show-current)
    echo -e "Current branch: ${CYAN}$current_branch${NC}"
    echo ""

    read -p "Pull from origin/$current_branch? (Y/n): " choice
    if [[ ! $choice =~ ^[Nn]$ ]]; then
        git pull origin "$current_branch"
        echo -e "${GREEN}Changes pulled successfully!${NC}"
    fi
}

# Function to switch branch
switch_branch() {
    echo -e "${YELLOW}Switch branch${NC}"
    echo ""

    echo "Available branches:"
    git branch -a
    echo ""

    read -p "Enter branch name to switch to: " branch_name

    if [ -z "$branch_name" ]; then
        echo -e "${RED}Branch name cannot be empty!${NC}"
        return
    fi

    git checkout "$branch_name"
    echo -e "${GREEN}Switched to branch: $branch_name${NC}"
}

# Function to list branches
list_branches() {
    echo -e "${YELLOW}All branches:${NC}"
    echo ""
    echo -e "${CYAN}Local branches:${NC}"
    git branch
    echo ""
    echo -e "${CYAN}Remote branches:${NC}"
    git branch -r
    echo ""
    echo -e "${CYAN}Current branch:${NC}"
    git branch --show-current
}

# Function to delete branch
delete_branch() {
    echo -e "${YELLOW}Delete branch${NC}"
    echo ""

    current_branch=$(git branch --show-current)
    echo -e "Current branch: ${CYAN}$current_branch${NC}"
    echo ""

    echo "Available local branches:"
    git branch
    echo ""

    read -p "Enter branch name to delete: " branch_name

    if [ -z "$branch_name" ]; then
        echo -e "${RED}Branch name cannot be empty!${NC}"
        return
    fi

    if [ "$branch_name" = "$current_branch" ]; then
        echo -e "${RED}Cannot delete the current branch! Switch to another branch first.${NC}"
        return
    fi

    if [ "$branch_name" = "$DEFAULT_BRANCH" ] || [ "$branch_name" = "main" ] || [ "$branch_name" = "master" ]; then
        echo -e "${RED}Cannot delete the main branch!${NC}"
        return
    fi

    read -p "Delete local branch '$branch_name'? (y/N): " choice
    if [[ $choice =~ ^[Yy]$ ]]; then
        git branch -d "$branch_name" 2>/dev/null || git branch -D "$branch_name"
        echo -e "${GREEN}Local branch deleted${NC}"
    fi

    read -p "Delete remote branch 'origin/$branch_name'? (y/N): " choice
    if [[ $choice =~ ^[Yy]$ ]]; then
        git push origin --delete "$branch_name"
        echo -e "${GREEN}Remote branch deleted${NC}"
    fi
}

# Function for full workflow
full_workflow() {
    echo -e "${YELLOW}Full workflow: Add → Commit → Push${NC}"
    echo ""

    add_commit
    if [ $? -eq 0 ]; then
        echo ""
        push_to_origin
    fi
}

# Main script
echo -e "${GREEN}Git Workflow Manager for fabric-generic-cluster-ansible${NC}"
echo -e "${BLUE}Repository: $REPO_URL${NC}"
echo ""

# Check if we're in the repo directory
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}Not currently in a git repository.${NC}"
    read -p "Do you want to clone the repository? (Y/n): " choice
    if [[ ! $choice =~ ^[Nn]$ ]]; then
        clone_repo
    fi
fi

# Main loop
while true; do
    show_menu
    read -p "Enter your choice: " choice

    case $choice in
        1)
            clone_repo
            ;;
        2)
            create_branch
            ;;
        3)
            show_status
            ;;
        4)
            add_commit
            ;;
        5)
            push_to_origin
            ;;
        6)
            pull_changes
            ;;
        7)
            switch_branch
            ;;
        8)
            list_branches
            ;;
        9)
            delete_branch
            ;;
        10)
            full_workflow
            ;;
        0)
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice. Please try again.${NC}"
            ;;
    esac

    read -p "Press Enter to continue..."
done

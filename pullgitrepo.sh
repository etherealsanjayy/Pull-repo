#!/bin/bash
# Script: clone_with_git.sh

read -p "Enter Your GitHub Username: " GITHUB_USER
read -s -p "Enter GitHub Token (PAT): " GITHUB_TOKEN
echo ""
read -p "Enter Repo Owner (leave blank if same as your username): " REPO_OWNER
read -p "Enter Repository Name: " REPO_NAME

# Use your username if Repo Owner is left blank
REPO_OWNER=${REPO_OWNER:-$GITHUB_USER}

echo "Cloning repository..."

# Clone using the token, then immediately remove the token from the saved config
if git clone "https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/${REPO_OWNER}/${REPO_NAME}.git"; then
    cd "$REPO_NAME" || exit
    # remove from git/config
    git remote set-url origin "https://github.com/${REPO_OWNER}/${REPO_NAME}.git"
    echo "Done! your repo securely clone "
else
    echo "Error: Clone fail check username, token, or check repo name"
fi

# before run this script run this command "sed -i 's/\r$//' fileanme"

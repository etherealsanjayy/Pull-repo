#!/bin/bash
# Script: download_no_git.sh

read -p "Enter Your GitHub Username: " GITHUB_USER
read -s -p "Enter GitHub Token (PAT): " GITHUB_TOKEN
echo ""
read -p "Enter Repo Owner (leave blank if same as your username): " REPO_OWNER
read -p "Enter Repository Name: " REPO_NAME

REPO_OWNER=${REPO_OWNER:-$GITHUB_USER}

echo "Downloading repository archive..."

# curl -f to find error
if curl -f -L -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/tarball/main" -o "${REPO_NAME}.tar.gz"; then
    echo "Extracting files..."
    
    # New file
    mkdir -p "$REPO_NAME"
    tar -xzf "${REPO_NAME}.tar.gz" -C "$REPO_NAME" --strip-components=1
    
    # Cleanup: download zip file delete 
    rm "${REPO_NAME}.tar.gz" 
    
    echo "Done! repo securely download '$REPO_NAME'"
else
    echo "Error: Download fail check token, owner, or check repo name"
fi

# before run this script run this command "sed -i 's/\r$//' (fileanme)"

#!/bin/bash
# Download and extract private repo safely without Git

read -r -p "GitHub Username: " GITHUB_USER
read -r -s -p "GitHub Token (PAT): " GITHUB_TOKEN
echo ""
read -r -p "Repo Owner (Enter for same): " REPO_OWNER
read -r -p "Repo Name: " REPO_NAME

REPO_OWNER=${REPO_OWNER:-$GITHUB_USER}
ARCHIVE="_tmp_${REPO_NAME}.tar.gz"
DEST="$REPO_NAME"

echo "Downloading..."

# No branch specified = auto-downloads repo's default branch (main/master/etc.)
if curl -fL -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/tarball" -o "$ARCHIVE"; then
    # Ask before overwriting an existing folder
    if [ -d "$DEST" ]; then
        read -r -p "Folder '$DEST' already exists. Overwrite? (y/N): " CHOICE
        if [[ "$CHOICE" == "y" || "$CHOICE" == "Y" ]]; then
            rm -rf "$DEST"
        else
            DEST="${REPO_NAME}_$(date +%Y%m%d_%H%M%S)"
        fi
    fi

    echo "Extracting..."
    mkdir -p "$DEST"

    # --strip-components=1 removes GitHub's random hash folder automatically
    if tar -xzf "$ARCHIVE" -C "$DEST" --strip-components=1; then
        rm -f "$ARCHIVE"
        echo "Done: Extracted cleanly to '$DEST'."
    else
        rm -f "$ARCHIVE"
        echo "Error: Extraction failed."
    fi
else
    rm -f "$ARCHIVE"
    echo "Error: Download failed. Check credentials or repo name."
fi

# before run this script run this command "sed -i 's/\r$//' fileanme"

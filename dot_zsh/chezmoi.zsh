# Define files to include in chezmoi
# In this list, don't include globs, just files/directories
CHEZMOI_INCLUDE=(
  "$HOME/.zsh"
  "$HOME/.zshrc"
  "$HOME/.config/nvim"
  "$HOME/.tmux.conf"
  "$HOME/.bashrc"
  "$HOME/.bash_profile"
  "$HOME/.zprofile"
  "$HOME/.zshenv"
  "$HOME/Brewfile"
)

# Define patterns to exclude
CHEZMOI_EXCLUDE=(
  "**/secrets.zsh"
  "**/.DS_Store"
  "**/.config/chezmoi/**"
  "**/node_modules/**"
  "**/.git/**"
)

function chezmoi_manage() {
  # Store the full path to chezmoi before doing anything else
  (

    local CHEZMOI_BIN=$(which chezmoi)
    
    # Check if chezmoi is installed
    if [ -z "$CHEZMOI_BIN" ]; then
      echo "Error: chezmoi is not installed or not in PATH."
      return 1
    fi

    # Get the source directory (use the full path to chezmoi)
    local SOURCE_DIR=$("$CHEZMOI_BIN" source-path)
    if [ -z "$SOURCE_DIR" ]; then
      echo "Error: Could not determine chezmoi source directory."
      return 1
    fi

    # Update the ignore file
    echo "Updating .chezmoiignore..."
    echo "# Generated on $(date)" > "$SOURCE_DIR/.chezmoiignore"
    for pattern in "${CHEZMOI_EXCLUDE[@]}"; do
      echo "$pattern" >> "$SOURCE_DIR/.chezmoiignore"
    done

    # Add files to chezmoi
    echo "Adding files to chezmoi..."
    for path in "${CHEZMOI_INCLUDE[@]}"; do
    # Remove trailing slashes if any
    path="${path%/}"
    
    if [ -e "$path" ]; then
      echo "Adding $path"
      # For directories, add -r for recursive
      if [ -d "$path" ]; then
        "$CHEZMOI_BIN" add -r "$path"
      else
        "$CHEZMOI_BIN" add "$path"
      fi
    else
      echo "Skipping $path (not found)"
    fi
  done

    echo "✅ Done! To see changes, run: chezmoi status"
  )
}

# Function to check git status of chezmoi source directory
function chezmoi_git_status() {
  # Store the full path to chezmoi
  local CHEZMOI_BIN=$(which chezmoi)
  
  # Check if chezmoi is installed
  if [ -z "$CHEZMOI_BIN" ]; then
    echo "Error: chezmoi is not installed or not in PATH."
    return 1
  fi

  # Get the source directory
  local SOURCE_DIR=$("$CHEZMOI_BIN" source-path)
  if [ -z "$SOURCE_DIR" ]; then
    echo "Error: Could not determine chezmoi source directory."
    return 1
  fi

  echo "Checking git status in $SOURCE_DIR..."
  
  # Check if the source directory is a git repository
  if [ ! -d "$SOURCE_DIR/.git" ]; then
    echo "Error: $SOURCE_DIR is not a git repository."
    return 1
  fi
  
  # Navigate to the source directory and run git status
  (cd "$SOURCE_DIR" && git status)
}

# Function to commit and push changes from chezmoi source directory
function chezmoi_git_sync() {
  # Store the full path to chezmoi
  local CHEZMOI_BIN=$(which chezmoi)
  
  # Check if chezmoi is installed
  if [ -z "$CHEZMOI_BIN" ]; then
    echo "Error: chezmoi is not installed or not in PATH."
    return 1
  fi

  # Get the source directory
  local SOURCE_DIR=$("$CHEZMOI_BIN" source-path)
  if [ -z "$SOURCE_DIR" ]; then
    echo "Error: Could not determine chezmoi source directory."
    return 1
  fi 
  
  # Check if the source directory is a git repository
  if [ ! -d "$SOURCE_DIR/.git" ]; then
    echo "Error: $SOURCE_DIR is not a git repository."
    return 1
  fi
  
  # Navigate to the source directory
  cd "$SOURCE_DIR" || return 1
  
  # Check if there are changes to commit
  if [ -z "$(git status --porcelain)" ]; then
    echo "No changes to commit in $SOURCE_DIR"
    return 0
  fi
  
  # Get commit message from argument or use default
  local COMMIT_MSG=${1:-"Update dotfiles $(date +%Y-%m-%d)"}
  
  echo "Committing changes with message: $COMMIT_MSG"
  git add .
  git commit -m "$COMMIT_MSG"
  
  # Push changes
  echo "Pushing changes to remote repository..."
  git push
  
  # Return to original directory
  cd - > /dev/null
  
  echo "✅ Changes pushed successfully!"
}

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
  (
    # Check if chezmoi is installed
    local CHEZMOI_BIN=$(which chezmoi)
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

    # Always regenerate the ignore file
    echo "Updating .chezmoiignore..."
    echo "# This file is automatically generated. Update ignore list in ~/.zsh/chezmoi.zsh" > "$SOURCE_DIR/.chezmoiignore"
    
    # Add our standard exclusion patterns
    for pattern in "${CHEZMOI_EXCLUDE[@]}"; do
      echo "$pattern" >> "$SOURCE_DIR/.chezmoiignore"
    done
    
    # Always include gitignore patterns
    echo "# Patterns from .gitignore files" >> "$SOURCE_DIR/.chezmoiignore"
    
    # Global gitignore
    if [ -f "$HOME/.gitignore_global" ]; then
      echo "# From global gitignore" >> "$SOURCE_DIR/.chezmoiignore"
      cat "$HOME/.gitignore_global" >> "$SOURCE_DIR/.chezmoiignore"
    fi
    
    # Local gitignore if it exists
    if [ -f "$HOME/.gitignore" ]; then
      echo "# From local gitignore" >> "$SOURCE_DIR/.chezmoiignore"
      cat "$HOME/.gitignore" >> "$SOURCE_DIR/.chezmoiignore"
    fi

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

#
# Function to fetch latest changes from remote chezmoi repository
function chezmoi_fetch() {
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
  
  echo "Fetching latest changes from remote repository..."
  (cd "$SOURCE_DIR" && git pull)
  
  echo "✅ Latest changes fetched successfully!"
}

# Function to apply the latest chezmoi configuration
function chezmoi_apply() {
  local CHEZMOI_BIN=$(which chezmoi)
  
  # Check if chezmoi is installed
  if [ -z "$CHEZMOI_BIN" ]; then
    echo "Error: chezmoi is not installed or not in PATH."
    return 1
  fi
  
  echo "Applying latest chezmoi configuration..."
  "$CHEZMOI_BIN" apply
  
  echo "✅ Configuration applied successfully!"
}

# Function to sync to chezmoi local repo and  push to remote
function chezmoi_push() {
  echo "===== Chezmoi Sync and Push to Remote ====="
  
  # Step 1: Manage files
  echo "Step 1: Add files to chezmoi"
  echo -n "Do you want to add files to chezmoi? (y/n): "
  read confirm
  if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    chezmoi_manage
  else
    echo "Skipping file management step."
  fi
  
  # Step 2: Show git status
  echo "Step 2: Check git status"
  echo -n "Do you want to check git status? (y/n): "
  read confirm
  if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    chezmoi_git_status
  else
    echo "Skipping git status step."
  fi
  
  # Step 3: Sync changes
  echo "Step 3: Commit and push changes"
  echo -n "Do you want to commit and push changes? (y/n): "
  read confirm
  if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    chezmoi_git_sync
  else
    echo "Skipping git sync step."
  fi
  
  echo "✅ Chezmoi workflow completed!"
}

# Function to sync from remote and apply changes
function chezmoi_pull() {
  echo "===== Chezmoi Pull from Remote and Sync ====="
  
  # Step 1: Fetch latest changes
  echo "Step 1: Fetch latest changes from remote"
  echo -n "Do you want to fetch the latest changes? (y/n): "
  read confirm
  if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    chezmoi_fetch
  else
    echo "Skipping fetch step."
  fi
  
  # Step 2: Apply configuration
  echo "Step 2: Apply configuration changes"
  echo -n "Do you want to apply the configuration changes? (y/n): "
  read confirm
  if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    chezmoi_apply
  else
    echo "Skipping apply step."
  fi
  
  echo "✅ Chezmoi sync from remote completed!"
}

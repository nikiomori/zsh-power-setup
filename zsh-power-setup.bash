#!/usr/bin/env bash
set -e

# Function to detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)   echo "linux";;
        Darwin*)  echo "macos";;
        *)        echo "other";;
    esac
}

# Function for logging
log() {
    echo ">>> $1"
}

# Function to check dependencies
check_dependencies() {
    local missing_deps=()
    local deps=("zsh" "git" "curl")

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done

    echo "${missing_deps[@]}"
}

# Function to install dependencies
install_dependencies() {
    local os=$1
    log "Checking required dependencies..."

    # Get list of missing dependencies
    local missing_deps=($(check_dependencies))

    # Skip installation if all dependencies are installed
    if [ ${#missing_deps[@]} -eq 0 ]; then
        log "All required dependencies are already installed."
        return 0
    fi

    log "Missing dependencies: ${missing_deps[*]}"
    log "Installing missing dependencies..."

    if [ "$os" = "linux" ]; then
        if command -v apt-get &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y "${missing_deps[@]}"
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y "${missing_deps[@]}"
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm "${missing_deps[@]}"
        elif command -v yum &> /dev/null; then
            sudo yum install -y "${missing_deps[@]}"
        elif command -v zypper &> /dev/null; then
            sudo zypper install -y "${missing_deps[@]}"
        else
            log "Package manager not found. Please install the following dependencies manually: ${missing_deps[*]}"
            exit 1
        fi
    elif [ "$os" = "macos" ]; then
        if ! command -v brew &> /dev/null; then
            log "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install "${missing_deps[@]}"
    else
        log "Unsupported OS. Please install the following dependencies manually: ${missing_deps[*]}"
        exit 1
    fi

    # Check if all dependencies were installed successfully
    local failed_deps=($(check_dependencies))
    if [ ${#failed_deps[@]} -ne 0 ]; then
        log "Error: Failed to install the following dependencies: ${failed_deps[*]}"
        exit 1
    fi

    log "All dependencies successfully installed!"
}

# Function to install Oh My Zsh and plugins
install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log "Installing Oh My Zsh..."
        RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        log "Oh My Zsh is already installed"
    fi

    # Define custom settings path
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # Install powerlevel10k theme
    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        log "Installing powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    fi

    # Install main plugins
    local plugins=(
        "zsh-autosuggestions:https://github.com/zsh-users/zsh-autosuggestions"
        "zsh-syntax-highlighting:https://github.com/zsh-users/zsh-syntax-highlighting"
        "zsh-completions:https://github.com/zsh-users/zsh-completions"
        "zsh-history-substring-search:https://github.com/zsh-users/zsh-history-substring-search"
    )

    for plugin in "${plugins[@]}"; do
        IFS=: read -r name url <<< "$plugin"
        if [ ! -d "$ZSH_CUSTOM/plugins/$name" ]; then
            log "Installing plugin $name..."
            git clone "$url" "$ZSH_CUSTOM/plugins/$name"
        fi
    done
}

# Function to configure .zshrc
configure_zshrc() {
    # Create backup of existing .zshrc
    if [ -f "$HOME/.zshrc" ]; then
        local backup_file="$HOME/.zshrc.backup.$(date +%s)"
        cp "$HOME/.zshrc" "$backup_file"
        log "Created backup of .zshrc: $backup_file"
    fi

    log "Configuring .zshrc..."
    cat > "$HOME/.zshrc" <<'EOF'
# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme configuration
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins configuration
plugins=(
    git
    docker
    docker-compose
    kubectl
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    zsh-history-substring-search
)

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY_TIME

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# User configuration
export LANG=en_US.UTF-8
export EDITOR='vim'

# Powerlevel10k configuration
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Completion configuration
autoload -Uz compinit
compinit

# Useful aliases
alias ll='ls -lah'
alias h='history'
alias grep='grep --color=auto'
alias docker-clean='docker system prune -af'
EOF
}

# Main script logic
main() {
    log "Starting ZSH installation and configuration..."

    # Detect OS
    OS=$(detect_os)
    log "Detected operating system: $OS"

    # Install dependencies
    install_dependencies "$OS"

    # Install Oh My Zsh and plugins
    install_oh_my_zsh

    # Configure .zshrc
    configure_zshrc

    # Set ZSH as default shell
    if [ "$SHELL" != "$(command -v zsh)" ]; then
        log "Setting ZSH as default shell..."
        chsh -s "$(command -v zsh)" || log "Failed to automatically change shell. Please change it manually."
    else
        log "ZSH is already the default shell."
    fi

    log "Installation completed successfully!"
    log "The Powerlevel10k configuration wizard will now start."
    log "Press any key to continue..."
    read -n 1 -s

    # Launch powerlevel10k configuration
    if [ -f "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k/powerlevel10k.zsh-theme" ]; then
        # Create temporary configuration file for zsh with powerlevel10k
        temp_zshrc=$(mktemp)
        cat > "$temp_zshrc" <<EOL
source "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k/powerlevel10k.zsh-theme"
source "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
p10k configure
EOL
        # Launch zsh with temporary configuration for powerlevel10k setup
        zsh -f "$temp_zshrc"
        rm "$temp_zshrc"

        log "Powerlevel10k configuration completed!"
        log "To apply all settings:"
        log "1. Restart your terminal"
        log "2. Or run the command: exec zsh"
    else
        log "ERROR: Powerlevel10k theme not found. Please configure it manually later using 'p10k configure'"
    fi
}

# Run script
main

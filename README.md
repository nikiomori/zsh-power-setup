# ZSH Setup Script

A comprehensive installation script for setting up ZSH with Oh My Zsh, Powerlevel10k theme, and essential plugins.

## Features

- Automatic OS detection (Linux/macOS)
- Installation of required dependencies
- Oh My Zsh installation
- Powerlevel10k theme setup
- Essential ZSH plugins:
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - zsh-completions
  - zsh-history-substring-search
- Automatic shell configuration
- Backup of existing configurations
- Interactive Powerlevel10k configuration wizard

## Prerequisites

The script will automatically check and install missing dependencies. Base requirements:
- System: Linux (Debian/Ubuntu, Fedora, CentOS, Arch) or macOS
- Internet connection
- Sudo privileges

## Installation

1. Download the script:
```bash
curl -O https://github.com/nikiomori/zsh-power-setup/blob/main/zsh-power-setup.sh
```

2. Make it executable:
```bash
chmod +x zsh-power-setup.sh
```

3. Run the script:
```bash
./zsh-power-setup.sh
```

## What the Script Does

1. Detects your operating system
2. Checks and installs required dependencies:
   - zsh
   - git
   - curl
3. Installs Oh My Zsh
4. Sets up Powerlevel10k theme
5. Installs and configures essential plugins
6. Creates backup of existing configurations
7. Sets up new ZSH configuration
8. Launches Powerlevel10k configuration wizard

## Installed Plugins

- **zsh-autosuggestions**: Suggests commands based on history
- **zsh-syntax-highlighting**: Provides syntax highlighting for commands
- **zsh-completions**: Additional completion definitions
- **zsh-history-substring-search**: Fish-like history search

## Configuration

The script sets up a default configuration that includes:
- Powerlevel10k theme
- Enhanced command history settings
- Useful aliases
- Git integration
- Docker and Kubernetes support

### Default Aliases

```bash
ll='ls -lah'           # Detailed directory listing
h='history'            # Show command history
grep='grep --color=auto' # Colored grep output
docker-clean='docker system prune -af' # Clean Docker resources
```

## Troubleshooting

### Common Issues

1. **Dependencies Installation Failed**
   - Ensure you have sudo privileges
   - Check your internet connection
   - Try running package manager update manually

2. **Shell Change Failed**
   - Run `chsh -s $(which zsh)` manually
   - Ensure zsh is installed properly

3. **Plugin Installation Failed**
   - Check your internet connection
   - Ensure git is installed and configured
   - Try cloning plugins manually

### Manual Steps if Needed

If the automatic installation fails, you can perform these steps manually:

1. Install ZSH:
   ```bash
   # Debian/Ubuntu
   sudo apt-get install zsh
   # Fedora
   sudo dnf install zsh
   # macOS
   brew install zsh
   ```

2. Install Oh My Zsh:
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

3. Install Powerlevel10k:
   ```bash
   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
   ```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [ZSH Plugin Authors](https://github.com/zsh-users)

## Support

If you encounter any issues or have questions, please create an issue in the repository.

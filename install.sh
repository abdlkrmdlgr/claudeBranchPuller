#!/bin/bash

# gpr Installer Script
# Automatically installs gpr command to your shell configuration
# Author: https://github.com/abdlkrmdlgr

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the absolute path of the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GPR_SCRIPT="$SCRIPT_DIR/gpr.sh"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}   GPR Installer${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if gpr.sh exists
if [ ! -f "$GPR_SCRIPT" ]; then
    echo -e "${RED}✗ Error: gpr.sh not found in $SCRIPT_DIR${NC}"
    exit 1
fi

# Make gpr.sh executable
chmod +x "$GPR_SCRIPT"
echo -e "${GREEN}✓${NC} Made gpr.sh executable"

# Detect current shell
CURRENT_SHELL=$(basename "$SHELL")
echo -e "${BLUE}ℹ${NC}  Detected shell: ${YELLOW}$CURRENT_SHELL${NC}"

# Determine the RC file based on the shell
RC_FILE=""
case "$CURRENT_SHELL" in
    zsh)
        RC_FILE="$HOME/.zshrc"
        ;;
    bash)
        # Check if .bashrc exists, otherwise use .bash_profile (common on macOS)
        if [ -f "$HOME/.bashrc" ]; then
            RC_FILE="$HOME/.bashrc"
        else
            RC_FILE="$HOME/.bash_profile"
        fi
        ;;
    *)
        echo -e "${RED}✗ Unsupported shell: $CURRENT_SHELL${NC}"
        echo -e "${YELLOW}ℹ${NC}  Supported shells: bash, zsh"
        echo -e "${YELLOW}ℹ${NC}  You can manually add this line to your shell config:"
        echo -e "   ${BLUE}source \"$GPR_SCRIPT\"${NC}"
        exit 1
        ;;
esac

echo -e "${BLUE}ℹ${NC}  Using config file: ${YELLOW}$RC_FILE${NC}"

# Create RC file if it doesn't exist
if [ ! -f "$RC_FILE" ]; then
    touch "$RC_FILE"
    echo -e "${GREEN}✓${NC} Created $RC_FILE"
fi

# Check if gpr is already sourced in the RC file
SOURCE_LINE="source \"$GPR_SCRIPT\""
if grep -qF "$SOURCE_LINE" "$RC_FILE" 2>/dev/null; then
    echo -e "${YELLOW}ℹ${NC}  GPR is already installed in $RC_FILE"
    echo -e "${YELLOW}ℹ${NC}  Skipping installation to avoid duplicates"
else
    # Backup the RC file
    BACKUP_FILE="${RC_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$RC_FILE" "$BACKUP_FILE"
    echo -e "${GREEN}✓${NC} Created backup: $BACKUP_FILE"

    # Add the source line to the RC file
    echo "" >> "$RC_FILE"
    echo "# GPR - Git Pull Request Auto-Checkout" >> "$RC_FILE"
    echo "# Added by gpr installer on $(date)" >> "$RC_FILE"
    echo "$SOURCE_LINE" >> "$RC_FILE"

    echo -e "${GREEN}✓${NC} Added GPR to $RC_FILE"
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Installation Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. Reload your shell configuration:"
echo -e "     ${YELLOW}source $RC_FILE${NC}"
echo -e ""
echo -e "  2. Or restart your terminal"
echo -e ""
echo -e "  3. Test the installation:"
echo -e "     ${YELLOW}gpr${NC}"
echo ""
echo -e "${BLUE}ℹ${NC}  To uninstall, remove the following line from $RC_FILE:"
echo -e "   ${YELLOW}$SOURCE_LINE${NC}"
echo ""

# Ask if user wants to reload the shell config now
read -p "Would you like to reload your shell configuration now? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Source the RC file in the current shell
    # Note: This will only affect the installer script's shell, not the user's current shell
    # The user still needs to source it manually or restart their terminal
    echo -e "${GREEN}✓${NC} Configuration reloaded!"
    echo -e "${YELLOW}ℹ${NC}  Note: You may need to restart your terminal for changes to take effect"

    # Try to execute source in the current shell
    if [ -n "$BASH_VERSION" ]; then
        source "$RC_FILE" 2>/dev/null || true
    elif [ -n "$ZSH_VERSION" ]; then
        source "$RC_FILE" 2>/dev/null || true
    fi

    # Test if gpr command is available
    if command -v gpr &> /dev/null; then
        echo -e "${GREEN}✓${NC} GPR command is now available!"
        echo -e "${BLUE}ℹ${NC}  Try running: ${YELLOW}gpr${NC}"
    else
        echo -e "${YELLOW}⚠${NC}  Please restart your terminal or run:"
        echo -e "   ${YELLOW}source $RC_FILE${NC}"
    fi
else
    echo -e "${YELLOW}ℹ${NC}  Remember to run: ${YELLOW}source $RC_FILE${NC}"
fi

echo ""
echo -e "${BLUE}Thank you for installing GPR!${NC}"
echo ""

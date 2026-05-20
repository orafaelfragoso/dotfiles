#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${DOTFILES_REPO_URL:-https://github.com/orafaelfragoso/dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
NIX_PROFILE="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"

info() {
  printf '\033[1;34m==>\033[0m %s\n' "$*"
}

fail() {
  printf '\033[1;31merror:\033[0m %s\n' "$*" >&2
  exit 1
}

need_command() {
  command -v "$1" >/dev/null 2>&1 || fail "missing required command: $1"
}

install_nix() {
  if command -v nix >/dev/null 2>&1; then
    info "Nix is already installed"
    return
  fi

  info "Installing Nix"
  sh <(curl -L https://nixos.org/nix/install)

  if [ -f "$NIX_PROFILE" ]; then
    # shellcheck source=/dev/null
    . "$NIX_PROFILE"
  fi

  command -v nix >/dev/null 2>&1 || fail "Nix was installed, but 'nix' is not on PATH. Open a new shell and rerun this script."
}

load_nix() {
  if [ -f "$NIX_PROFILE" ]; then
    # shellcheck source=/dev/null
    . "$NIX_PROFILE"
  fi

  need_command nix
}

ensure_dotfiles_repo() {
  if [ -d "$DOTFILES_DIR/.git" ]; then
    info "Using dotfiles repo at $DOTFILES_DIR"
    return
  fi

  need_command git
  info "Cloning dotfiles into $DOTFILES_DIR"
  git clone "$REPO_URL" "$DOTFILES_DIR"
}

nix_cmd() {
  nix --extra-experimental-features 'nix-command flakes' "$@"
}

configure_macos() {
  info "Applying nix-darwin configuration"
  nix_cmd run github:nix-darwin/nix-darwin -- switch --flake "$DOTFILES_DIR#rafael-mac"
}

configure_linux() {
  local system
  case "$(uname -m)" in
    x86_64) system="linux-x86_64" ;;
    aarch64 | arm64) system="linux-aarch64" ;;
    *) fail "unsupported Linux architecture: $(uname -m)" ;;
  esac

  info "Applying Home Manager configuration for $system"
  nix_cmd run github:nix-community/home-manager -- switch --flake "$DOTFILES_DIR#rafael@$system"
}

main() {
  need_command curl
  install_nix
  load_nix
  ensure_dotfiles_repo

  info "Validating flake"
  nix_cmd flake check "$DOTFILES_DIR" --all-systems

  case "$(uname -s)" in
    Darwin) configure_macos ;;
    Linux) configure_linux ;;
    *) fail "unsupported operating system: $(uname -s)" ;;
  esac

  info "Done"
}

main "$@"

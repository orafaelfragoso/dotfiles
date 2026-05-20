# Dotfiles

Validate-only Nix, nix-darwin, and Home Manager configuration for Rafael's development environment.

## Scope

- Local git repository only for now.
- Does not activate or replace the current macOS setup.
- Command line tools are managed first in `modules/home/programs/cli.nix`.
- Works as a nix-darwin + Home Manager config on macOS.
- Works as a standalone Home Manager config on Linux.
- Requires Homebrew on macOS and uses nix-darwin's Homebrew module only for mac-specific essentials.
- Keeps Neovim plugins managed by `vim.pack`.
- Keeps tmux plugins managed by TPM.
- Includes Kitty config.
- Excludes Zed and all secrets from this first pass.

## Validate

Open a new shell, or source Nix manually:

```sh
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

Then run:

```sh
nix --extra-experimental-features 'nix-command flakes' flake check ~/.dotfiles
nix --extra-experimental-features 'nix-command flakes' eval ~/.dotfiles#darwinConfigurations.rafael-mac.system --raw
nix --extra-experimental-features 'nix-command flakes' eval ~/.dotfiles#homeConfigurations.'rafael@linux-x86_64'.activationPackage.drvPath --raw
nix --extra-experimental-features 'nix-command flakes' eval ~/.dotfiles#homeConfigurations.'rafael@linux-aarch64'.activationPackage.drvPath --raw
```

Do not run `darwin-rebuild switch` until you are ready to let the configuration manage the machine.

## Future Activation

Install Nix, clone this repo into `~/.dotfiles` if needed, validate the flake, and apply the matching macOS/Linux configuration:

```sh
curl -L https://raw.githubusercontent.com/orafaelfragoso/dotfiles/main/install.sh | bash
```

From an existing clone:

```sh
./install.sh
```

macOS:

```sh
darwin-rebuild switch --flake ~/.dotfiles#rafael-mac
```

Linux:

```sh
home-manager switch --flake ~/.dotfiles#rafael@linux-x86_64
```

# cdmation

Automations for your `cd`s.

`cdmation` is a zsh CLI that binds scripts to directories.  
When you `cd` into a tracked repo (or any of its subdirectories), the automation runs automatically.

## Requirements

- `zsh`
- macOS/Linux shell environment

## Installation

### Homebrew (recommended)

```bash
brew tap adamzafir/cdmation
brew install cdmation
echo 'source "$(brew --prefix)/opt/cdmation/cdmation-hook.zsh"' >> ~/.zshrc
source ~/.zshrc
```

### Manual

Clone the repo and enter it:

```bash
git clone https://github.com/adamzafir/cdmation.git
cd cdmation
```

Run the installer:

```bash
./install.sh
```

This script will:

- symlink `cdmation` to `~/.local/bin/cdmation`
- add `~/.local/bin` to your `PATH` in `~/.zshrc` (if missing)
- add the `cdmation-hook.zsh` source line to `~/.zshrc` (if missing)

Then reload:

```bash
source ~/.zshrc
```

Verify:

```bash
cdmation help
```

## Usage

Add automation for a named directory:

```bash
cdmation add pull-main ~/code/my-repo
```

Add automation for current directory (name auto-generated from folder):

```bash
cdmation add .
```

The built-in TUI editor opens. Enter one command per line.

Editor controls:

- `/done` save
- `/undo` remove last line
- `/clear` clear all lines
- `/abort` cancel

Example automation script content:

```zsh
git pull
echo "git has been pulled"
```

Now every time you enter that repo, `cdmation` runs those commands.

## Command Reference

```bash
cdmation add <name> <path>
cdmation add <path>
cdmation add .
cdmation list
cdmation rename <oldname> <newname>
cdmation remove <automationname>
cdmation help
```

`add:`, `list:`, `rename:`, and `remove:` (colon form) are also supported.

## Data Storage

- Registry: `~/.cdmation/automations.tsv`
- Scripts: `~/.cdmation/scripts/*.zsh`

## Notes

- Names support letters, numbers, `.`, `_`, and `-`.
- Name matching for `remove` and `rename` is case-insensitive.

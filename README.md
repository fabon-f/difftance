# difftance

A diff tool to show edit distance. Works well with Git.

## Installation

### Homebrew (Mac)

```sh
brew tap fabon-f/tap
brew install difftance
```

### AUR (for Arch Linux users)

* binary release: https://aur.archlinux.org/packages/difftance-bin/
* git(upstream): https://aur.archlinux.org/packages/difftance-git/

### Binary release(Windows, Linux)

You can download Windows or Linux(x86_64) executable from [GitHub release](https://github.com/fabon-f/difftance/releases).

### Manual installation

```sh
# default install directory: /usr/local/bin
make install INSTALL_DIR=install_path
```

## Usage

```sh
difftance before_file after_file
# You can calculate edit distance for files under directory
difftance before_dir after_dir
```

### Git integration

```sh
# Use as a custom diff tool for Git
git -c diff.external=difftance diff
# options can be passed
git -c diff.external="difftance --allow-substitution" diff
# other git subcommands via `--ext-diff`
git -c diff.external=difftance show --ext-diff

# or set environment variable
GIT_EXTERNAL_DIFF="difftance" git --no-pager diff
GIT_EXTERNAL_DIFF="difftance --allow-substitution" git --no-pager diff

# via difftool
git difftool --extcmd=difftance --no-prompt
git difftool --extcmd=difftance --no-prompt --dir-diff
# You can pass options by using DIFFTANCE_OPTS environment variable
DIFFTANCE_OPTS="--allow-substitution" git difftool --extcmd=difftance --no-prompt
```

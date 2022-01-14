# difftance

A diff tool to show edit distance. Works well with Git.

## Installation

### Homebrew (Mac)

```sh
brew tap fabon-f/tap
brew install difftance
```

### AUR (for Arch Linux users)

binary release: https://aur.archlinux.org/packages/difftance-bin/
git(upstream): https://aur.archlinux.org/packages/difftance-git/

### Binary release(Linux)

You can download x86_64 executable from [GitHub release](https://github.com/fabon-f/difftance/releases).

### Manual installation

```sh
# default install directory: /usr/local/bin
make install INSTALL_DIR=install_path
```

## Usage

```sh
difftance file1 file2

# Use as a custom diff tool for Git
git difftool --extcmd=difftance
git difftool --extcmd=difftance --dir-diff

# or
GIT_EXTERNAL_DIFF="difftance" git diff
# options can be passed
GIT_EXTERNAL_DIFF="difftance --no-substitution" git diff
```

# difftance

A diff tool to show edit distance. Works well with Git.

## Installation

### AUR (for Arch users)

git(upstream): https://aur.archlinux.org/packages/difftance-git/

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

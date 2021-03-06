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
difftance file1 file2

# Use as a custom diff tool for Git
git difftool --extcmd=difftance --no-prompt
git difftool --extcmd=difftance --no-prompt --dir-diff
# You can pass options by using DIFFTANCE_OPTS environment variable
DIFFTANCE_OPTS="--allow-substitution" git difftool --extcmd=difftance --no-prompt

# or
GIT_EXTERNAL_DIFF="difftance" git --no-pager diff
# options can be passed
GIT_EXTERNAL_DIFF="difftance --allow-substitution" git --no-pager diff
```

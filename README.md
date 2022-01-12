# difftance

A diff tool to show edit distance. Works well with Git.

## Installation

```sh
# default install directory: /usr/local/bin
make install INSTALL_DIR=install_path
```

## Usage

```sh
difftance file1 file2

# Use as a custom diff tool for Git
GIT_EXTERNAL_DIFF="difftance" git diff
```

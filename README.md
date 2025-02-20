# Configuration Directory Overview

This directory contains configuration files and scripts for customizing your development environment on macOS. It includes settings for your shell, terminal emulator, and Neovim editor as well as git configuration.

---

## Shell Configuration

- Configure oh-my-zsh and its plugins
- Some helper commands

---

## Terminal Emulator: Kitty

- Set cursorline color of tokyonight semi transparent
- Set darkened background image
- Make terminal as minimal as possible (running in fullscreen all the time)

---

## Neovim Configuration

- At the moment I am mainly using it for js/ts
- I use nightly build with vim.pack
- Stick to blink.nvim for now, since native completion doesn't look or perform as well
- Organise everything based on feature, e.g. put vim.pack.add together with plugin config and keybinds for this plugin in one file (e.g. fuzz-find.lua)

---

## Git Configuration

- **.gitconfig**  
  Configures Git behavior and appearance. Notable settings include:
  - Uses Neovim (`nvim`) as the default editor and merge tool.
  - Defines a custom alias (`jump`) for quickly navigating Git repositories.

---

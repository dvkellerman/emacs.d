# Emacs Configuration

Personal Emacs configuration focused on Swift/iOS development with Evil mode, modern completion, and a polished UI.

## Features

- **Evil mode** with SPC leader key (Vim-style editing)
- **LSP/Eglot** for intelligent code completion and navigation
- **Swift/iOS development** with periphery, swift-format, simulator integration
- **Modern completion** via Corfu, Vertico, Consult, Embark
- **punch-line** mode line with weather, git, battery, music, and task management
- **kanagawa** color theme
- **Treemacs** project sidebar
- **AI assistance** integration

## Setup

```bash
git clone --recursive <repo-url> ~/.emacs.d
```

If already cloned without `--recursive`:

```bash
git submodule update --init --recursive
```

## Structure

```
init.el                 Entry point
early-init.el           Pre-GUI optimizations
modules/                Configuration modules
  mk-core.el             Package management, load paths
  mk-evil.el             Evil mode and leader bindings
  mk-completion.el       Vertico, Corfu, Consult, Embark
  mk-development.el      LSP, Flycheck, project tools
  mk-ios-development.el  Swift/iOS tooling
  mk-ui.el               Mode line, window rules, visual modes
  mk-theme.el            Theme configuration
  mk-vc.el               Magit and version control
  ...
localpackages/          Local elisp packages
  periphery/              Swift linting and diagnostics
  punch-line/             Mode line (submodule)
  kanagawa-emacs/         Theme (submodule)
  ...
themes/                 Additional color themes
```

## Key Bindings (SPC leader)

| Key         | Action                  |
|-------------|-------------------------|
| `SPC b b`   | Switch buffer           |
| `SPC b d`   | Kill buffer             |
| `SPC f f`   | Find file               |
| `SPC f s`   | Save file               |
| `SPC p s`   | Switch project          |
| `SPC p d`   | Kill project buffers    |
| `SPC w d`   | Delete window           |
| `SPC s s`   | Search                  |
| `SPC v v`   | Magit status            |
| `SPC TAB`   | Last buffer             |
| `SPC .`     | Embark act              |

## Requirements

- Emacs 30+
- Nerd Fonts (for icons)
- ripgrep (for search)

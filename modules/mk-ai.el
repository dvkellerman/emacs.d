;;; mk-ai.el --- AI integrations -*- lexical-binding: t; -*-
;;; Commentary:
;; Claude Code IDE and OpenCode integrations.
;;; Code:

(use-package claude-code-ide
  :ensure t
  :defer t
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :commands (claude-code-ide-menu)
  :config
  (setopt claude-code-ide-vterm-anti-flicker t
          claude-code-ide-vterm-render-delay 0.2)
  (claude-code-ide-emacs-tools-setup))

(use-package opencode
  :ensure t
  :defer t
  :vc (:url "https://codeberg.org/sczi/opencode.el" :rev :newest)
  :commands (opencode))

(provide 'mk-ai)
;;; mk-ai.el ends here

;;; mk-treemacs.el --- Treemacs file explorer -*- lexical-binding: t; -*-
;;; Commentary:
;; Treemacs sidebar with nerd icons, magit, and evil integration.
;;; Code:

(use-package treemacs
  :ensure t
  :commands (treemacs treemacs-select-window treemacs-find-file)
  :hook (treemacs-mode . treemacs-project-follow-mode)
  :config
  ;; Use the same font as the rest of Emacs, slightly smaller
  (let ((font-family (face-attribute 'default :family))
        (font-height 0.85))
    (dolist (face '(treemacs-directory-face
                    treemacs-directory-collapsed-face
                    treemacs-file-face
                    treemacs-tags-face
                    treemacs-git-unmodified-face
                    treemacs-git-untracked-face
                    treemacs-git-added-face
                    treemacs-git-renamed-face
                    treemacs-git-modified-face
                    treemacs-root-face))
      (set-face-attribute face nil :family font-family :height font-height))
    (dolist (face '(treemacs-git-ignored-face
                    treemacs-git-conflict-face))
      (set-face-attribute face nil :family font-family :height font-height :slant 'italic)))

  (setq treemacs-follow-after-init t
        treemacs-project-follow-cleanup t
        treemacs-width-is-initially-locked nil
        treemacs-collapse-dirs 3
        treemacs-display-in-side-window t
        treemacs-is-never-other-window nil
        treemacs-indentation 2
        treemacs-indentation-string " "
        treemacs-git-mode 'deferred
        treemacs-move-files-by-mouse-dragging nil
        treemacs-move-forward-on-expand t
        treemacs-pulse-on-success t
        treemacs-show-hidden-files nil
        treemacs-sorting 'treemacs--sort-alphabetic-case-insensitive-asc
        treemacs-width 40)

  (treemacs-hide-gitignored-files-mode 1)
  (treemacs-filewatch-mode 1))

(use-package treemacs-nerd-icons
  :ensure t
  :after treemacs
  :config
  (treemacs-load-theme "nerd-icons"))

(use-package treemacs-magit
  :ensure t
  :after (treemacs magit))

(use-package treemacs-evil
  :ensure t
  :after (treemacs evil))

(use-package project-treemacs
  :ensure t
  :after treemacs)

(provide 'mk-treemacs)
;;; mk-treemacs.el ends here

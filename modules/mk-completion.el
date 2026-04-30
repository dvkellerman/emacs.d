;;; mk-completion.el --- Completion configuration -*- lexical-binding: t; -*-
;;; Commentary:
;; Vertico + Consult + Embark + Orderless completion stack.
;;; Code:

(defun mk/consult-line-at-point ()
  "Search current buffer with symbol at point."
  (interactive)
  (consult-line (thing-at-point 'symbol)))

(use-package vertico
  :ensure t
  :hook (after-init . vertico-mode)
  :bind
  (:map vertico-map
        ("C-j" . vertico-next)
        ("C-k" . vertico-previous)
        ("<down>" . vertico-next)
        ("<up>" . vertico-previous)
        ("C-d" . vertico-scroll-down)
        ("C-u" . vertico-scroll-up)
        ("C-g" . abort-recursive-edit))
  :config
  (advice-add #'vertico--format-candidate :around
              (lambda (orig cand prefix suffix index _)
                (setq cand (funcall orig cand prefix suffix index _))
                (concat
                 (if (= vertico--index index)
                     (propertize "» " 'face '(:inherit font-lock-operator-face :weight black))
                   "  ")
                 cand)))
  (setq vertico-resize t
        vertico-count 15
        vertico-cycle t))

(use-package vertico-posframe
  :ensure t
  :after vertico
  :config
  (setq vertico-posframe-poshandler #'posframe-poshandler-frame-center
        vertico-posframe-min-height 2
        vertico-posframe-truncate-lines nil
        vertico-posframe-min-width 120
        vertico-posframe-border-width 20
        vertico-posframe-parameters '((alpha . 1.0)))
  (setq vertico-multiform-commands
        '((consult-line (:not posframe))
          (xref-find-references (:not posframe))
          (consult-eglot-symbols (:not posframe))
          (consult-ripgrep (:not posframe))
          (mk/project-search-from-isearch (:not posframe))
          (consult-xref (:not posframe))
          (t posframe)))
  (vertico-multiform-mode)
  (vertico-posframe-cleanup)
  (custom-set-faces
   '(vertico-posframe-border ((t (:inherit vertico-posframe))))))

(use-package vertico-directory
  :after vertico
  :ensure nil
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy)
  :bind (:map vertico-map
              ("<tab>" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word)))

(use-package marginalia
  :ensure t
  :after vertico
  :config
  (marginalia-mode)
  (setopt marginalia--ellipsis "…"
          marginalia-align 'left
          marginalia-align-offset -1)
  (add-to-list 'marginalia-command-categories
               '(project-find-file . project-file))
  (add-to-list 'marginalia-annotators
               '(project-file none)))

(use-package nerd-icons-completion
  :ensure t
  :after (nerd-icons marginalia)
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup)
  :config
  (nerd-icons-completion-mode))

(use-package nerd-icons-dired
  :ensure t
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package consult
  :ensure t
  :defer t
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :bind
  (("<backtab>" . consult-buffer)
   ("C-<tab>" . consult-project-buffer)
   :map isearch-mode-map
   ("C-M-e" . consult-isearch-history)
   ("M-s e" . consult-isearch-history)
   ("M-s L" . consult-line-multi)
   ("M-s l" . consult-line))
  :init
  (setq register-preview-delay 0.4
        register-preview-function #'consult-register-format
        xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  (advice-add #'register-preview :override #'consult-register-window)
  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   :preview-key '(:debounce 0.4 any))
  (setq consult-narrow-key "<"))

(use-package embark
  :ensure t
  :commands (embark-act embark-collect-snapshot embark-collect-live)
  :bind
  (("C-." . embark-act)
   :map minibuffer-local-map
   ("C-." . embark-act))
  :custom
  (embark-quit-after-action t))

(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completions-detailed t)
  (completion-ignore-case t)
  (completions-format 'one-column)
  (completion-category-overrides '((file (styles basic partial-completion)))))

(provide 'mk-completion)
;;; mk-completion.el ends here

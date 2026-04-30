;;; mk-code-completion.el --- Code completion configuration -*- lexical-binding: t; -*-
;;; Commentary:
;; In-buffer completion (Corfu + Cape) and LSP (Eglot) configuration.
;;; Code:

(defun mk/setup-elisp-capf ()
  "Set up rich completion sources for Emacs Lisp."
  (setq-local completion-at-point-functions
              (list (cape-capf-super
                     #'cape-elisp-symbol
                     #'cape-elisp-block
                     #'cape-dabbrev
                     #'cape-file
                     #'cape-keyword
                     #'elisp-completion-at-point))))

(use-package cape
  :ensure t
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-keyword)
  (add-hook 'emacs-lisp-mode-hook #'mk/setup-elisp-capf)
  :config
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-silent))

(use-package eglot
  :ensure nil
  :defer t
  :hook ((swift-ts-mode) . (lambda ()
                             (require 'swift-lsp)
                             (eglot-ensure)))
  :custom
  (eglot-autoshutdown t)
  (eglot-extend-to-xref t)
  (eglot-ignored-server-capabilities '(:semanticTokensProvider))
  (eglot-connect-timeout 90)
  (eglot-report-progress nil)
  (eglot-events-buffer-size 0)
  :config
  (add-to-list 'eglot-server-programs '(swift-ts-mode . swift-lsp-eglot-server-contact))
  (setq eglot-stay-out-of '(flycheck flymake)
        jsonrpc-event-hook nil)
  (advice-add 'jsonrpc--log-event :override #'ignore))

(use-package eldoc-box
  :ensure t
  :after eglot
  :hook (eglot-managed-mode . eldoc-box-hover-mode)
  :custom
  (eldoc-box-border-width 1)
  (eldoc-box-clear-with-C-g t))

(use-package corfu
  :ensure t
  :bind
  (:map corfu-map
        ("<escape>" . corfu-quit)
        ("C-g" . corfu-quit)
        ("<down>" . corfu-next)
        ("<up>" . corfu-previous)
        ("C-n" . corfu-next)
        ("C-p" . corfu-previous)
        ("C-j" . corfu-next)
        ("C-k" . corfu-previous)
        ("RET" . corfu-insert)
        ("SPC" . corfu-insert-separator)
        ("C-h" . corfu-info-documentation)
        ("M-RET" . corfu-complete))
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.1)
  (corfu-separator ?\s)
  (corfu-preselect 'valid)
  (corfu-preview-current nil)
  (corfu-quit-at-boundary 'separator)
  (corfu-quit-no-match t)
  (corfu-max-width 140)
  (corfu-scroll-margin 4)
  :init
  (global-corfu-mode)
  (corfu-history-mode))

(use-package corfu-popupinfo
  :after corfu
  :ensure nil
  :hook (corfu-mode . corfu-popupinfo-mode)
  :custom
  (corfu-popupinfo-delay '(0.25 . 0.1))
  (corfu-popupinfo-hide nil))

(use-package nerd-icons-corfu
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(provide 'mk-code-completion)
;;; mk-code-completion.el ends here

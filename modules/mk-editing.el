;;; mk-editing.el --- Editing enhancements -*- lexical-binding: t; -*-
;;; Commentary:
;; Isearch extensions, multi-edit, scrolling, search-and-replace tools.
;;; Code:

(use-package iedit
  :ensure t
  :defer t
  :init
  (setq iedit-toggle-key-default nil)
  :config
  (define-key iedit-mode-keymap (kbd "C-<return>") #'iedit-toggle-selection)
  (define-key iedit-mode-keymap (kbd "C-j") #'iedit-next-occurrence)
  (define-key iedit-mode-keymap (kbd "C-k") #'iedit-prev-occurrence)
  (define-key iedit-mode-keymap (kbd "C-g") #'iedit-mode))

(use-package isearch
  :ensure nil
  :config
  (setq isearch-allow-scroll t
        isearch-lazy-count t)

  (defun mk/isearch-to-iedit ()
    "Exit isearch and start iedit on all matches."
    (interactive)
    (require 'iedit)
    (isearch-exit)
    (iedit-mode))

  (defun mk/project-search-from-isearch ()
    "Ripgrep the project with current isearch string."
    (interactive)
    (let ((query (if isearch-regexp
                     isearch-string
                   (regexp-quote isearch-string))))
      (isearch-update-ring isearch-string isearch-regexp)
      (isearch-done t t)
      (consult-ripgrep (project-root (project-current)) query)))

  (defun mk/isearch-consult-line ()
    "Hand off isearch string to consult-line."
    (interactive)
    (let ((query (if isearch-regexp
                     isearch-string
                   (regexp-quote isearch-string))))
      (isearch-update-ring isearch-string isearch-regexp)
      (isearch-done t t)
      (consult-line query)))

  (defun mk/isearch-with-region-or-thing ()
    "Start isearch with region or symbol at point."
    (interactive)
    (let ((search-text
           (if (region-active-p)
               (buffer-substring-no-properties (region-beginning) (region-end))
             (thing-at-point 'symbol t))))
      (when search-text
        (deactivate-mark)
        (isearch-forward-regexp nil t)
        (setq isearch-case-fold-search nil
              isearch-string (format "\\<%s\\>" (regexp-quote search-text))
              isearch-message isearch-string)
        (isearch-search-and-update))))

  :bind
  (:map isearch-mode-map
        ("C-e" . mk/isearch-to-iedit)
        ("C-f" . mk/project-search-from-isearch)
        ("M-f" . mk/isearch-consult-line)
        ("C-d" . mk/isearch-with-region-or-thing)
        ("C-s" . isearch-repeat-forward)
        ("C-r" . isearch-repeat-backward)
        ("C-o" . isearch-occur)
        ("M-e" . isearch-edit-string)))

(use-package ultra-scroll
  :ensure t
  :vc (ultra-scroll :url "https://github.com/jdtsmith/ultra-scroll" :branch "main" :rev :newest)
  :init
  (setq scroll-conservatively 101
        scroll-margin 0)
  :config
  (ultra-scroll-mode 1))

(use-package wgrep
  :ensure t
  :defer t
  :custom
  (wgrep-auto-save-buffer t))

(use-package rg
  :ensure t
  :defer t)

(use-package visual-replace
  :ensure t
  :defer t
  :commands visual-replace
  :bind (:map isearch-mode-map
         ("C-c r" . visual-replace-from-isearch)))

(use-package avy
  :ensure t
  :defer t
  :commands avy-goto-word-1
  :bind (:map isearch-mode-map
         ("C-a" . avy-isearch))
  :custom
  (avy-single-candidate-jump t))

(provide 'mk-editing)
;;; mk-editing.el ends here

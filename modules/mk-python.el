;;; mk-python.el --- Python development -*- lexical-binding: t; -*-
;;; Commentary:
;; Python development using tree-sitter mode, eglot (pyright/pylsp), and venv support.
;;; Code:

(add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))

(use-package python-ts-mode
  :ensure nil
  :mode ("\\.py\\'" . python-ts-mode)
  :hook ((python-ts-mode . eglot-ensure))
  :custom
  (python-indent-offset 4)
  (python-indent-guess-indent-offset-verbose nil)
  :config
  (add-to-list 'treesit-language-source-alist '(python . ("https://github.com/tree-sitter/tree-sitter-python")))
  (unless (treesit-language-available-p 'python)
    (treesit-install-language-grammar 'python)))

(use-package pet
  :ensure t
  :hook (python-ts-mode . pet-mode))

(use-package pyvenv
  :ensure t
  :defer t
  :commands (pyvenv-activate pyvenv-workon)
  :hook (python-ts-mode . mk/python-auto-venv)
  :config
  (defun mk/python-auto-venv ()
    "Auto-activate .venv if found in project root."
    (when-let* ((root (project-root (project-current)))
                (venv (expand-file-name ".venv" root)))
      (when (file-directory-p venv)
        (pyvenv-activate venv)))))

(provide 'mk-python)
;;; mk-python.el ends here

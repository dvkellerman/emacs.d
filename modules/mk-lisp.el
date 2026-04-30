;;; mk-lisp.el --- Emacs Lisp editing enhancements -*- lexical-binding: t; -*-
;;; Commentary:
;; Packages that make editing Emacs Lisp more pleasant.
;;; Code:

(use-package page-break-lines
  :ensure t
  :hook (emacs-lisp-mode . page-break-lines-mode))

(use-package aggressive-indent
  :ensure t
  :hook (emacs-lisp-mode . aggressive-indent-mode))

(use-package highlight-defined
  :ensure t
  :hook (emacs-lisp-mode . highlight-defined-mode))

(use-package highlight-quoted
  :ensure t
  :hook (emacs-lisp-mode . highlight-quoted-mode))

(use-package colorful-mode
  :ensure t
  :hook (emacs-lisp-mode . colorful-mode)
  :custom
  (colorful-use-prefix t)
  (colorful-prefix-alignment 'left)
  (colorful-prefix-string "●"))

(provide 'mk-lisp)
;;; mk-lisp.el ends here

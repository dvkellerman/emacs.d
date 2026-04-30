;;; mk-theme.el --- Theme configuration -*- lexical-binding: t; -*-
;;; Commentary:
;; Theme load paths and active theme selection.
;;; Code:

(dolist (path '("themes"
                "localpackages/kanagawa-emacs"
                "localpackages/mito-laser-emacs"
                "localpackages/neofusion-emacs"))
  (add-to-list 'custom-theme-load-path (expand-file-name path user-emacs-directory)))

(use-package autothemer
  :ensure t
  :init
  (load-theme 'rose-pine t))

(provide 'mk-theme)
;;; mk-theme.el ends here

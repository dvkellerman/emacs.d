;;; mk-misc.el --- Miscellaneous packages -*- lexical-binding: t; -*-
;;; Commentary:
;; Packages that don't fit elsewhere.
;;; Code:

(use-package weather-scout
  :ensure t
  :commands weather-scout-show-forecast
  :init
  (with-eval-after-load 'evil
    (evil-set-initial-state 'weather-scout-mode 'motion)))

(provide 'mk-misc)
;;; mk-misc.el ends here

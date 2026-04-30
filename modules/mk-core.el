;;; mk-core.el --- Core initialization -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;; Package management, paths, fonts, and foundational settings.
;; Requires Emacs 30+.
;;; Code:

(require 'package)
(setopt package-archives '(("melpa" . "https://melpa.org/packages/")
                           ("gnu" . "https://elpa.gnu.org/packages/")
                           ("nongnu" . "https://elpa.nongnu.org/nongnu/"))
        package-archive-priorities '(("gnu" . 99)
                                     ("nongnu" . 80)
                                     ("melpa" . 70))
        package-check-signature nil
        package-quickstart t
        package-install-upgrade-built-in t)
(package-initialize)

(require 'use-package-ensure)
(setopt use-package-always-ensure t
        use-package-expand-minimally t
        use-package-compute-statistics t)

;; Local packages
(let ((dir (expand-file-name "localpackages" user-emacs-directory)))
  (when (file-directory-p dir)
    (add-to-list 'load-path dir)
    (let ((default-directory dir))
      (normal-top-level-add-subdirs-to-load-path))))

;; PATH (macOS)
(let* ((paths `("/opt/homebrew/bin"
                "/opt/homebrew/sbin"
                "/usr/local/bin"
                "/usr/bin"
                "/bin"
                "/usr/sbin"
                "/sbin"
                ,(expand-file-name "~/.local/bin")))
       (expanded (mapcar #'expand-file-name paths)))
  (setenv "PATH" (string-join expanded ":"))
  (setq exec-path expanded))

;; Identity
(setq user-full-name "Dmitry Keller"
      user-mail-address "dvkellerman@gmail.com")

;; Disable accidental zoom with ctrl+scroll
(global-unset-key (kbd "C-<wheel-up>"))
(global-unset-key (kbd "C-<wheel-down>"))
(global-unset-key [C-wheel-up])
(global-unset-key [C-wheel-down])
(global-set-key (kbd "M-w") 'ns-do-hide-emacs)

;; Fonts
(set-face-attribute 'default nil :family "Iosevka Fixed Curly" :width 'condensed :weight 'regular :height 240)
(set-face-attribute 'fixed-pitch nil :family "GitLab Mono")
(set-face-attribute 'variable-pitch nil :family "Iosevka Aile" :height 1.0)
(set-fontset-font t 'unicode (font-spec :family "Apple Color Emoji") nil 'append)

;; Essential packages
(use-package nerd-icons :demand t)
(use-package posframe :demand t)

(use-package auto-compile
  :defer 1
  :custom
  (auto-compile-display-buffer nil)
  (auto-compile-mode-line-counter nil)
  (auto-compile-use-mode-line nil)
  (auto-compile-update-autoloads t)
  :config
  (auto-compile-on-load-mode)
  (auto-compile-on-save-mode))

(provide 'mk-core)
;;; mk-core.el ends here

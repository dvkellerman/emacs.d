;;; init.el --- optimized init file -*- no-byte-compile: t; lexical-binding: t; -*-

;;; Commentary:
;; Personal Emacs configuration with optimized startup and modern packages.
;; Features include Evil mode, LSP support, project management, and development tools.

;;; Code:

;; Suppress all warnings when loading packages

(setopt debug-on-error nil)
;; (load (expand-file-name "suppress-warnings" cser-emacs-directory) nil t)

(dolist (path (list
               (expand-file-name "modules" user-emacs-directory)))
  (add-to-list 'load-path path))

(require 'mk-core)
(require 'mk-tty)
(require 'mk-theme)
(require 'mk-emacs)
(require 'mk-evil)
(require 'mk-completion)
(require 'mk-code-completion)
(require 'mk-development)
(require 'mk-editing)
(require 'mk-ios-development)
(require 'mk-cc-development)
(require 'mk-python)
(require 'mk-lisp)
(require 'mk-misc)
(require 'mk-notifications)
(require 'mk-web)
(require 'mk-vc)
(require 'mk-treemacs)
(require 'mk-ui)
(require 'mk-ai)

(use-package welcome-dashboard
  :ensure nil
  :config
  (setq welcome-dashboard-latitude 49.8397
        welcome-dashboard-longitude 24.0297
        welcome-dashboard-use-nerd-icons t
        welcome-dashboard-max-number-of-projects 8
        welcome-dashboard-show-weather-info t
        welcome-dashboard-use-fahrenheit nil
        welcome-dashboard-max-left-padding 1
        welcome-dashboard-max-number-of-todos 5
        welcome-dashboard-path-max-length 70
        welcome-dashboard-min-left-padding 10
        welcome-dashboard-title "Welcome Dmitry. Have a great day!")
  (when (display-graphic-p)
    (setq welcome-dashboard-image-file (expand-file-name "themes/emacs.png" user-emacs-directory)
          welcome-dashboard-image-width 200
          welcome-dashboard-image-height 200))
  (welcome-dashboard-create-welcome-hook)

  ;; Patch: add 'path property to project entries so RET works on them
  (advice-add 'welcome-dashboard--format-project :around
              (lambda (orig project)
                (let ((result (funcall orig project)))
                  (propertize result 'path project)))))

(provide 'init)
;;; init.el ends here

;;; early-init.el --- Pre-init performance and UI setup -*- lexical-binding: t; no-byte-compile: t; -*-

;;; Commentary:
;; Loaded before init.el and the package system.
;; Disables UI chrome early and maximizes startup performance.

;;; Code:

;; Defer file-name-handler for faster file loading during init
(defvar mk/file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Maximize GC threshold during init (restored after)
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.8)

;; Silence warnings during startup
(setq native-comp-async-report-warnings-errors nil
      native-comp-warning-on-missing-source nil
      warning-minimum-level :error
      warning-suppress-log-types '((comp) (bytecomp) (files))
      warning-suppress-types '((comp) (bytecomp) (files)))

;; Suppress startup UI
(setq inhibit-default-init t
      inhibit-startup-message t
      inhibit-startup-screen t
      inhibit-startup-echo-area-message (user-login-name)
      inhibit-splash-screen t
      inhibit-startup-buffer-menu t
      initial-scratch-message nil
      initial-major-mode 'fundamental-mode
      frame-inhibit-implied-resize t)

;; Hide mode-line until punch-line loads
(setq-default mode-line-format nil)

;; Frame defaults — applied before first frame renders
(setq default-frame-alist
      '((background-color . "#13131a")
        (foreground-color . "#a0a0ae")
        (height . 45)
        (width . 81)
        (internal-border-width . 1)
        (left-fringe . 8)
        (right-fringe . 4)
        (menu-bar-lines . 0)
        (tool-bar-lines . 0)
        (vertical-scroll-bars . nil)
        (ns-transparent-titlebar . t)
        (fullscreen . maximized)))

;; Restore sane defaults after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist mk/file-name-handler-alist-original
                  gc-cons-threshold (* 100 1024 1024)
                  gc-cons-percentage 0.2)
            (message "Emacs started in %.2f seconds with %d GCs"
                     (float-time (time-subtract after-init-time before-init-time))
                     gcs-done)))

(provide 'early-init)
;;; early-init.el ends here

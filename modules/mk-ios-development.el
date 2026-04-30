;;; mk-ios-development.el --- iOS/Swift development -*- lexical-binding: t; -*-
;;; Commentary:
;; Configuration for iOS and Swift development in Emacs.
;; Requires local packages: swift-ts-mode, swift-development, periphery.
;;; Code:

;;; --- Notifications ---

(defun mk/xcode-notify (&rest args)
  "Notify via knockknock for xcode-project build events.
Accepts :message, :seconds, and other plist args."
  (let* ((message-text (plist-get args :message))
         (seconds (or (plist-get args :seconds) 3))
         (icon (cond
                ((string-match-p "\\(success\\|complete\\|passed\\)" message-text) "nf-cod-check")
                ((string-match-p "\\(error\\|fail\\)" message-text) "nf-cod-error")
                ((string-match-p "\\(warning\\|warn\\)" message-text) "nf-cod-warning")
                ((string-match-p "\\(build\\|compil\\)" message-text) "nf-cod-tools")
                (t "nf-dev-xcode")))
         (parts (split-string message-text ": " t))
         (title (if (> (length parts) 1) (car parts) "Swift"))
         (msg (if (> (length parts) 1)
                  (string-join (cdr parts) ": ")
                message-text)))
    (knockknock-notify :title title :message msg :icon icon :duration seconds)))

(use-package knockknock
  :ensure nil
  :after (posframe nerd-icons)
  :config
  (knockknock-init)
  (setopt knockknock-border-color "#292929"
          knockknock-darken-background-percent 35))

;;; --- Swift mode ---

(use-package swift-ts-mode
  :ensure nil
  :mode ("\\.swift\\'" "\\.swiftinterface\\'")
  :bind (:map swift-ts-mode-map
              ("C-c t s" . swift-ts:split-func-list))
  :custom
  (swift-ts-basic-offset 4)
  (swift-ts:indent-trailing-call-member t))

(use-package localizeable-mode
  :ensure nil
  :after swift-ts-mode
  :mode "\\.strings\\'"
  :bind (:map localizeable-mode-map
              ("C-c C-k" . periphery-run-loco)))

;;; --- Swift tooling ---

(use-package ios-simulator
  :ensure nil
  :after swift-ts-mode)

(use-package swift-cache
  :ensure nil
  :after swift-ts-mode)

(use-package swift-features
  :ensure nil
  :after swift-ts-mode)

(use-package swift-development
  :ensure nil
  :after swift-ts-mode
  :bind (:map swift-ts-mode-map
              ("C-c d" . swift-development-transient))
  :custom
  (swift-development-use-periphery t))

(use-package xcode-project
  :ensure nil
  :after swift-ts-mode
  :config
  (setq xcode-project-notification-backend 'custom
        xcode-project-notification-function #'mk/xcode-notify))

(use-package xcode-build-config
  :ensure nil
  :after swift-ts-mode)

(use-package swift-refactor
  :ensure nil
  :after swift-ts-mode
  :bind (:map swift-ts-mode-map
              ("C-c R" . swift-refactor-transient)
              ("M-o" . swift-refactor-format-buffer)
              ("M-t" . swift-refactor-insert-todo)
              ("M-m" . swift-refactor-insert-mark)))

(use-package domain-blocker
  :ensure nil
  :after swift-ts-mode)

(use-package swift-development-mode
  :ensure nil
  :after swift-ts-mode)

;;; --- Periphery integration ---

(defun mk/disable-pulsar-in-periphery ()
  "Disable pulsar in periphery buffers."
  (pulsar-mode -1))

(add-hook 'periphery-mode-hook #'mk/disable-pulsar-in-periphery)

(provide 'mk-ios-development)
;;; mk-ios-development.el ends here

;;; mk-ui.el --- UI enhancements -*- lexical-binding: t; -*-
;;; Commentary:
;; Mode line, window management, spotlight, and visual UI packages.
;;; Code:

;;; --- Visual modes ---

(use-package spotlight-mode
  :ensure nil
  :hook (after-init . spotlight-mode)
  :config
  (setopt spotlight-mode-ignore-buffers '("*Messages*" "*scratch*")
          spotlight-mode-always-color-buffers '()
          spotlight-mode-always-darken-buffers-regexp '("\\*.*\\*")
          spotlight-active-dim-percentage 0
          spotlight-inactive-lighten-percentage 5
          spotlight-always-darken-percentage 15))

(use-package focus-delight-mode
  :ensure nil
  :defer t
  :commands focus-delight-mode-for-mode
  :config
  (setopt focus-delight-mode-margin-style 'fixed
          focus-delight-mode-left-margin 10
          focus-delight-mode-center-text t
          focus-delight-mode-scale-percent 120)
  (add-hook 'focus-delight-mode-enabled-hook (lambda () (breadcrumb-mode -1)))
  (add-hook 'focus-delight-mode-disabled-hook (lambda () (breadcrumb-mode 1))))

(use-package candyshop
  :ensure nil
  :commands (candyshop-toggle candyshop-init)
  :custom
  (candyshop-alpha-values '(100 92)))

;;; --- Mode line ---

(use-package punch-line
  :ensure nil
  :defer t
  :bind (("C-x t n" . punch-line-what-am-i-doing-next)
         ("C-x t N" . punch-line-what-am-i-doing-next-task)
         ("C-x t d" . punch-line-what-am-i-doing-done)
         ("C-x t a" . punch-line-what-am-i-doing-show-all)
         (:repeat-map punch-line-repeat-map
                      ("n" . punch-line-what-am-i-doing-next)
                      ("N" . punch-line-what-am-i-doing-next-task)
                      ("d" . punch-line-what-am-i-doing-done)
                      ("a" . punch-line-what-am-i-doing-show-all)))
  :init
  (defvar mk-ui--punch-line-activated nil)
  (defun mk-ui--activate-punch-line ()
    "Activate punch-line on first file or project visit."
    (unless mk-ui--punch-line-activated
      (setq mk-ui--punch-line-activated t)
      (require 'punch-line)
      (punch-line-mode 1)
      (punch-weather-update)
      (punch-load-tasks)))
  (add-hook 'find-file-hook #'mk-ui--activate-punch-line)
  (add-hook 'dired-mode-hook #'mk-ui--activate-punch-line)
  :config
  (setopt punch-show-project-info t
          punch-line-modal-use-fancy-icon t
          punch-line-modal-divider-style 'circle
          punch-line-modal-size 'large
          punch-line-left-separator " "
          punch-line-right-separator " "
          punch-line-section-padding 10
          punch-show-git-info t
          punch-show-lsp-info t
          punch-line-vc-use-github-icon t
          punch-show-copilot-info nil
          punch-show-battery-info t
          punch-show-flycheck-info t
          punch-show-weather-info t
          punch-show-column-info t
          punch-show-what-am-i-doing-info t
          punch-weather-latitude "49.8397"
          punch-weather-longitude "24.0297"
          punch-line-music-max-length 80
          punch-line-section-backgrounds 'auto
          punch-line-section-background-tint-step 5
          punch-line-music-info '(:service apple)))

(use-package mode-line-hud
  :ensure nil)

;;; --- UI utilities ---

(use-package imenu-list
  :ensure t
  :defer t
  :commands imenu-list-smart-toggle
  :custom
  (imenu-list-focus-after-activation t)
  (imenu-list-auto-resize t))

(use-package nerd-icons-ibuffer
  :ensure t
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode)
  :custom
  (nerd-icons-ibuffer-icon t)
  (nerd-icons-ibuffer-color-icon t)
  (nerd-icons-ibuffer-human-readable-size t))

(use-package dired
  :ensure nil
  :defer t
  :custom
  (dired-listing-switches "-aBhl --group-directories-first")
  :config
  (with-eval-after-load 'evil-collection
    (evil-collection-define-key 'normal 'dired-mode-map
      "h" 'dired-up-directory
      "l" 'dired-find-file)))

(use-package which-key
  :ensure nil
  :init
  (run-with-idle-timer 1.5 nil #'which-key-mode)
  :custom
  (which-key-use-C-h-commands t)
  (which-key-separator " → ")
  (which-key-side-window-location 'bottom)
  (which-key-sort-order #'which-key-prefix-then-key-order)
  (which-key-sort-uppercase-first nil)
  (which-key-add-column-padding 2)
  (which-key-min-display-lines 6)
  (which-key-idle-delay 1.0)
  (which-key-max-description-length 45)
  (which-key-allow-imprecise-window-fit t)
  :config
  (which-key-setup-minibuffer))

;;; --- Window management ---

(use-package window
  :ensure nil
  :custom
  (transient-display-buffer-action
   '(display-buffer-below-selected
     (window-height . fit-window-to-buffer)))
  (window-resize-pixelwise nil)
  (window-divider-default-places t)
  (window-divider-default-bottom-width 1)
  (window-divider-default-right-width 1)
  (display-buffer-alist
   '(("\\*Async Shell Command\\*" (display-buffer-no-window))
     ("\\*xwidget\\*\\|\\*xref\\*"
      (display-buffer-in-side-window display-buffer-reuse-mode-window display-buffer-reuse-window)
      (body-function . select-window)
      (window-width . 0.4)
      (slot . 1)
      (side . left))
     ("evil-marks\\*"
      (display-buffer-in-side-window)
      (body-function . select-window)
      (window-height . (lambda (win) (fit-window-to-buffer win 20 10)))
      (window-width . 0.10)
      (side . right)
      (slot . 0))
     ("\\*iOS Simulator\\|\\*swift package\\|\\*ios-device"
      (display-buffer-reuse-window display-buffer-in-side-window display-buffer-at-bottom)
      (window-height . (lambda (win) (fit-window-to-buffer win 20 10)))
      (window-parameters . ((mode-line-format . none)))
      (slot . 100))
     ("\\*Embark*"
      (display-buffer-in-side-window display-buffer-reuse-mode-window display-buffer-at-bottom)
      (window-height . (lambda (win) (fit-window-to-buffer win 20 10)))
      (window-parameters . ((select-window . t)))
      (slot . 5))
     ("\\*Periphery\\*\\|\\*compilation\\*"
      (display-buffer-reuse-window display-buffer-in-side-window display-buffer-at-bottom)
      (body-function . select-window)
      (window-height . (lambda (win) (fit-window-to-buffer win 20 10)))
      (slot . 10))
     ("\\*Faces\\|[Hh]elp\\*\\|\\*Occur\\*"
      (display-buffer-in-side-window)
      (body-function . select-window)
      (window-width . 0.4)
      (side . right)
      (slot . 1))
     ("\\*e?shell\\|\\*vterm\\*"
      (display-buffer-at-bottom display-buffer-reuse-window)
      (body-function . select-window)
      (window-height . 0.13)
      (window-parameters . ((mode-line-format . none)))
      (side . bottom)
      (slot . 10))
     ("\\*\\(Flycheck\\|Package-Lint\\).*"
      (display-buffer-reuse-window display-buffer-below-selected)
      (window-height . (lambda (win) (fit-window-to-buffer win 20 10)))
      (dedicated . t)
      (window-parameters . ((no-other-window . t)
                            (mode-line-format . none)))))))

(provide 'mk-ui)
;;; mk-ui.el ends here

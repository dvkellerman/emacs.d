;;; mk-evil.el --- Evil mode and keybindings -*- lexical-binding: t; -*-
;;; Commentary:
;; Evil mode configuration, leader keybindings, and related packages.
;;; Code:

(use-package undo-fu
  :ensure t
  :defer t
  :config
  (setq undo-limit (* 13 160000)
        undo-outer-limit (* 13 24000000)
        undo-strong-limit (* 13 240000)
        undo-fu-allow-undo-in-region t))

(use-package undo-fu-session
  :hook (after-init . undo-fu-session-global-mode)
  :config
  (setq undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'")
        undo-fu-session-file-limit 10))

(use-package savehist
  :init
  (setq savehist-file (expand-file-name "var/savehist.el" user-emacs-directory))
  :config
  (setq history-length 500
        savehist-additional-variables '(kill-ring search-ring))
  (savehist-mode 1))

(use-package no-littering
  :after savehist
  :ensure t
  :config
  (setopt auto-save-file-name-transforms
          `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  (setopt backup-directory-alist
          `(("." . ,(no-littering-expand-var-file-name "backups/"))))
  (setopt custom-file (no-littering-expand-etc-file-name "custom.el"))
  (require 'recentf)
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory))

;;; Named commands for which-key display

(defun mk/switch-to-last-buffer ()
  "Switch to the last visited buffer."
  (interactive)
  (switch-to-buffer nil))

(defun mk/switch-to-messages ()
  "Switch to *Messages* buffer."
  (interactive)
  (switch-to-buffer "*Messages*"))

(defun mk/switch-to-scratch ()
  "Switch to *scratch* buffer."
  (interactive)
  (switch-to-buffer "*scratch*"))

(defun mk/edit-init-file ()
  "Open init.el for editing."
  (interactive)
  (find-file user-init-file))

(defun mk/toggle-whitespace ()
  "Toggle whitespace-mode."
  (interactive)
  (whitespace-mode 'toggle))

(defun mk/toggle-line-numbers ()
  "Cycle line numbers: relative → absolute → off."
  (interactive)
  (cond
   ((not display-line-numbers)
    (setq-local display-line-numbers 'relative)
    (message "Line numbers: relative"))
   ((eq display-line-numbers 'relative)
    (setq-local display-line-numbers t)
    (message "Line numbers: absolute"))
   (t
    (setq-local display-line-numbers nil)
    (message "Line numbers: off"))))

(defun mk/enlarge-window-horizontally ()
  "Enlarge window horizontally by 10 columns."
  (interactive)
  (enlarge-window-horizontally 10))

(defun mk/shrink-window-horizontally ()
  "Shrink window horizontally by 10 columns."
  (interactive)
  (shrink-window-horizontally 10))

(defun mk/enlarge-window-vertically ()
  "Enlarge window vertically by 3 lines."
  (interactive)
  (enlarge-window 3))

(defun mk/shrink-window-vertically ()
  "Shrink window vertically by 3 lines."
  (interactive)
  (shrink-window 3))

(defun mk/escape-and-clear ()
  "Clear search highlight and quit."
  (interactive)
  (evil-ex-nohighlight)
  (keyboard-quit))

(use-package evil
  :ensure t
  :custom
  (evil-want-Y-yank-to-eol t)
  (evil-default-cursor t)
  (evil-search-module 'isearch)
  (evil-undo-system 'undo-fu)
  (evil-ex-search-case 'smart)
  (evil-ex-search-persistent-highlight t)
  (evil-want-minibuffer t)
  (evil-want-C-u-scroll t)
  (evil-want-fine-undo t)
  (evil-split-window-below t)
  (evil-vsplit-window-right t)
  (evil-respect-visual-line-mode t)
  :init
  (setq-default evil-symbol-word-search t)
  (setq evil-want-keybinding nil)
  :config
  (evil-set-leader 'normal (kbd "SPC"))
  (evil-set-leader 'visual (kbd "SPC"))

  ;; Top-level
  (evil-define-key 'normal 'global (kbd "<leader>SPC") 'execute-extended-command)
  (evil-define-key 'normal 'global (kbd "<leader> .") 'embark-act)
  (evil-define-key 'normal 'global (kbd "<leader> /") 'consult-ripgrep)
  (evil-define-key 'normal 'global (kbd "<leader> S") 'consult-line-multi)
  (evil-define-key 'normal 'global (kbd "<leader> F") 'consult-line)
  (evil-define-key 'normal 'global (kbd "<leader>TAB") 'mk/switch-to-last-buffer)

  ;;; Buffers
  (evil-define-key 'normal 'global (kbd "<leader> b b") 'consult-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> b x") 'bury-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> b i") 'ibuffer)
  (evil-define-key 'normal 'global (kbd "<leader> b d") 'kill-current-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> b p") 'project-list-buffers)
  (evil-define-key 'normal 'global (kbd "<leader> b m") 'mk/switch-to-messages)
  (evil-define-key 'normal 'global (kbd "<leader> b s") 'mk/switch-to-scratch)
  (which-key-add-key-based-replacements "<leader> b" "Buffers")

  ;;; Code / LSP
  (evil-define-key 'normal 'global (kbd "<leader> c e") 'consult-compile-error)
  (evil-define-key 'normal 'global (kbd "<leader> c l") 'mk/compilation-get-errors)
  (evil-define-key 'normal 'global (kbd "<leader> c n") 'flycheck-next-error)
  (evil-define-key 'normal 'global (kbd "<leader> c p") 'flycheck-previous-error)
  (evil-define-key 'normal 'global (kbd "<leader> c f") 'eglot-code-action-quickfix)
  (evil-define-key 'normal 'global (kbd "<leader> c a") 'eglot-code-actions)
  (evil-define-key 'normal 'global (kbd "<leader> c r") 'eglot-rename)
  (evil-define-key 'normal 'global (kbd "<leader> c d") 'eglot-find-declaration)
  (evil-define-key 'normal 'global (kbd "<leader> c D") 'eglot-find-typeDefinition)
  (evil-define-key 'normal 'global (kbd "<leader> c i") 'eglot-find-implementation)
  (evil-define-key 'normal 'global (kbd "<leader> c b") 'eglot-format-buffer)
  (which-key-add-key-based-replacements "<leader> c" "Code/LSP")

  ;;; Embark / Eval
  (evil-define-key 'normal 'global (kbd "<leader> e a") 'embark-act)
  (evil-define-key 'normal 'global (kbd "<leader> e b") 'eval-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> e l") 'eval-last-sexp)
  (which-key-add-key-based-replacements "<leader> e" "Eval/Embark")

  ;;; Files
  (evil-define-key 'normal 'global (kbd "<leader> f d") 'delete-file)
  (evil-define-key 'normal 'global (kbd "<leader> f e") 'mk/edit-init-file)
  (evil-define-key 'normal 'global (kbd "<leader> f f") 'consult-find)
  (evil-define-key 'normal 'global (kbd "<leader> f l") 'consult-focus-lines)
  (evil-define-key 'normal 'global (kbd "<leader> f n") 'create-file-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> f r") 'consult-recent-file)
  (evil-define-key 'normal 'global (kbd "<leader> f s") 'save-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> f i") 'consult-imenu-multi)
  (which-key-add-key-based-replacements "<leader> f" "File")

  ;;; Highlight
  (evil-define-key 'normal 'global (kbd "<leader> h s") 'highlight-symbol-at-point)
  (evil-define-key 'normal 'global (kbd "<leader> h r") 'highlight-symbol-remove-all)
  (evil-define-key 'normal 'global (kbd "<leader> h n") 'highlight-symbol-next)
  (evil-define-key 'normal 'global (kbd "<leader> h N") 'highlight-symbol-prev)
  (which-key-add-key-based-replacements "<leader> h" "Highlight")

  ;;; Misc
  (evil-define-key 'normal 'global (kbd "<leader> m l") 'imenu-list-smart-toggle)
  (evil-define-key 'normal 'global (kbd "<leader> m i") 'consult-imenu)
  (evil-define-key 'normal 'global (kbd "<leader> m b") 'consult-bookmark)
  (evil-define-key 'normal 'global (kbd "<leader> m c") 'consult-mode-command)
  (which-key-add-key-based-replacements "<leader> m" "Misc")

  ;;; Search
  (evil-define-key 'normal 'global (kbd "<leader> s s") 'isearch-forward)
  (evil-define-key 'normal 'global (kbd "<leader> s l") 'consult-line)
  (evil-define-key 'normal 'global (kbd "<leader> s f") 'mk/consult-line-at-point)
  (evil-define-key 'normal 'global (kbd "<leader> s h") 'consult-isearch-history)
  (evil-define-key 'normal 'global (kbd "<leader> s o") 'occur)
  (evil-define-key 'normal 'global (kbd "<leader> s r") 'visual-replace)
  (evil-define-key 'normal 'global (kbd "<leader> s g") 'avy-goto-word-1)
  (which-key-add-key-based-replacements "<leader> s" "Search")

  ;;; Toggle
  (evil-define-key 'normal 'global (kbd "<leader> t s") 'sort-lines)
  (evil-define-key 'normal 'global (kbd "<leader> t x") 'delete-trailing-whitespace)
  (evil-define-key 'normal 'global (kbd "<leader> t w") 'mk/toggle-whitespace)
  (evil-define-key 'normal 'global (kbd "<leader> t f") 'focus-delight-mode-for-mode)
  (evil-define-key 'normal 'global (kbd "<leader> t c") 'candyshop-toggle)
  (evil-define-key 'normal 'global (kbd "<leader> t l") 'mk/toggle-line-numbers)
  (which-key-add-key-based-replacements "<leader> t" "Toggle")

  ;;; Project
  (evil-define-key 'normal 'global (kbd "<leader> p f") 'project-find-file)
  (evil-define-key 'normal 'global (kbd "<leader> p d") 'project-kill-buffers)
  (evil-define-key 'normal 'global (kbd "<leader> p D") 'project-dired)
  (evil-define-key 'normal 'global (kbd "<leader> p g") 'project-find-regexp)
  (evil-define-key 'normal 'global (kbd "<leader> p s") 'project-switch-project)
  (evil-define-key 'normal 'global (kbd "<leader> p b") 'consult-project-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> p t") 'treemacs)
  (evil-define-key 'normal 'global (kbd "<leader> p T") 'treemacs-find-file)
  (evil-define-key 'normal 'global (kbd "<leader> p x") 'periphery-quick:find)
  (which-key-add-key-based-replacements "<leader> p" "Project")

  ;;; Version control
  (evil-define-key 'normal 'global (kbd "<leader> v s") 'magit-status)
  (evil-define-key 'normal 'global (kbd "<leader> v b") 'magit-diff-buffer-file)
  (evil-define-key 'normal 'global (kbd "<leader> v a") 'vc-annotate)
  (evil-define-key 'normal 'global (kbd "<leader> v l") 'magit-log-buffer-file)
  (evil-define-key 'normal 'global (kbd "<leader> v t") 'git-timemachine-toggle)
  (which-key-add-key-based-replacements "<leader> v" "VC")

  ;;; Windows
  (evil-define-key 'normal 'global (kbd "<leader> w d") 'delete-window)
  (evil-define-key 'normal 'global (kbd "<leader> w <up>") 'evil-window-up)
  (evil-define-key 'normal 'global (kbd "<leader> w <down>") 'evil-window-down)
  (evil-define-key 'normal 'global (kbd "<leader> w <left>") 'evil-window-left)
  (evil-define-key 'normal 'global (kbd "<leader> w <right>") 'evil-window-right)
  ;;(evil-define-key 'normal 'global (kbd "<leader> w t") 'window-layout-transpose)
  (evil-define-key 'normal 'global (kbd "<leader> w r") 'window-layout-rotate-clockwise)
  (evil-define-key 'normal 'global (kbd "<leader> w R") 'window-layout-rotate-anticlockwise)
  (evil-define-key 'normal 'global (kbd "<leader> w f") 'window-layout-flip-topdown)
  (evil-define-key 'normal 'global (kbd "<leader> w F") 'window-layout-flip-leftright)
  (which-key-add-key-based-replacements "<leader> w" "Window")

  ;;; Quit
  (evil-define-key 'normal 'global (kbd "<leader> q r") 'restart-emacs)
  (evil-define-key 'normal 'global (kbd "<leader> q q") 'save-buffers-kill-terminal)
  (which-key-add-key-based-replacements "<leader> q" "Quit")

  (evil-select-search-module 'evil-search-module 'isearch)

  ;; Window resize
  (define-key evil-motion-state-map (kbd "C-+") 'mk/enlarge-window-horizontally)
  (define-key evil-motion-state-map (kbd "C--") 'mk/shrink-window-horizontally)
  (define-key evil-motion-state-map (kbd "C-M-+") 'mk/enlarge-window-vertically)
  (define-key evil-motion-state-map (kbd "C-M--") 'mk/shrink-window-vertically)

  ;; Cursors
  (setq evil-normal-state-cursor '(box "DodgerBlue")
        evil-insert-state-cursor '(bar "DeepPink")
        evil-visual-state-cursor '(hollow "orchid"))

  ;; Escape in normal mode clears highlights and dismisses popups
  (evil-define-key 'normal 'global (kbd "<escape>") 'mk/escape-and-clear)

  ;; Escape in minibuffer acts like C-g
  (define-key minibuffer-local-map (kbd "<escape>") 'abort-recursive-edit)
  (define-key minibuffer-local-ns-map (kbd "<escape>") 'abort-recursive-edit)
  (define-key minibuffer-local-completion-map (kbd "<escape>") 'abort-recursive-edit)
  (define-key minibuffer-local-must-match-map (kbd "<escape>") 'abort-recursive-edit)

  (evil-mode 1))

(with-eval-after-load 'evil
  (dolist (state '(normal insert visual motion emacs))
    (evil-define-key state 'global (kbd "s-M") nil)
    (evil-define-key state 'global (kbd "C-.") nil)
    (evil-define-key state 'global (kbd "C-k") nil)))

(use-package evil-collection
  :after evil
  :demand t
  :config
  (evil-collection-init)
  (add-hook 'prog-mode-hook
            (lambda ()
              (evil-local-set-key 'insert (kbd "TAB") 'indent-for-tab-command)
              (evil-local-set-key 'insert (kbd "<tab>") 'indent-for-tab-command)
              (evil-local-set-key 'normal (kbd "TAB") 'indent-for-tab-command)
              (evil-local-set-key 'normal (kbd "<tab>") 'indent-for-tab-command)
              (evil-local-set-key 'visual (kbd "TAB") 'indent-for-tab-command)
              (evil-local-set-key 'visual (kbd "<tab>") 'indent-for-tab-command))))

(use-package evil-surround
  :ensure t
  :after evil
  :hook (after-init . global-evil-surround-mode))

(use-package evil-matchit
  :after evil-collection
  :config
  (global-evil-matchit-mode 1))

(use-package evil-commentary
  :ensure t
  :after evil
  :init
  (evil-commentary-mode 1))

(use-package evil-snipe
  :ensure t
  :after evil
  :config
  (evil-snipe-mode +1)
  (evil-snipe-override-mode +1))

(use-package hardtime
  :ensure nil
  :after evil
  :bind ("<leader> t h" . global-hardtime-mode)
  :config
  (setq hardtime-notification-type 'knockknock)
  (which-key-add-key-based-replacements "<leader> t h" "Hardtime"))

(use-package pulsar
  :hook (after-init . pulsar-global-mode)
  :config
  (setopt pulsar-pulse t
          pulsar-delay 0.055
          pulsar-iterations 12
          pulsar-face 'pulsar-cyan
          pulsar-highlight-face 'pulsar-yellow
          pulsar-pulse-functions '(ace-window
                                   backward-page
                                   bookmark-jump
                                   consult--jump
                                   delete-other-windows
                                   delete-window
                                   evil-delete
                                   evil-delete-line
                                   evil-jump-item
                                   evil-scroll-down
                                   evil-scroll-line-down
                                   evil-scroll-line-up
                                   evil-scroll-page-down
                                   evil-scroll-page-up
                                   evil-scroll-up
                                   evil-window-down
                                   evil-window-left
                                   evil-window-right
                                   evil-window-rotate-downwards
                                   evil-window-rotate-upwards
                                   evil-window-split
                                   evil-window-up
                                   evil-window-vsplit
                                   evil-yank
                                   evil-yank-line
                                   forward-page
                                   goto-char
                                   handle-switch-frame
                                   move-to-window-line-top-bottom
                                   next-buffer
                                   other-window
                                   outline-backward-same-level
                                   outline-forward-same-level
                                   outline-next-visible-heading
                                   outline-previous-visible-heading
                                   outline-up-heading
                                   previous-buffer
                                   recenter
                                   recenter-top-bottom
                                   reposition-window
                                   scroll-down-command
                                   scroll-up-command
                                   switch-to-buffer
                                   switch-to-buffer-other-frame
                                   switch-to-buffer-other-tab
                                   switch-to-buffer-other-window
                                   tab-close
                                   tab-new
                                   tab-next
                                   windmove-down
                                   windmove-left
                                   windmove-right
                                   windmove-swap-states-down
                                   windmove-swap-states-left
                                   windmove-swap-states-right
                                   windmove-swap-states-up
                                   windmove-up)))

(provide 'mk-evil)
;;; mk-evil.el ends here

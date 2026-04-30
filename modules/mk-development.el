;;; mk-development.el --- Programming mode setup -*- lexical-binding: t; -*-
;;; Commentary:
;; Programming mode hooks, project management, compilation, debugging, and linting.
;;; Code:

;;; --- Packages ---

(defun mk/maybe-enable-hs-mode ()
  "Enable hs-minor-mode only if the mode supports it."
  (ignore-errors (hs-minor-mode 1)))

(use-package ligature
  :ensure t
  :hook (prog-mode . ligature-mode)
  :config
  (ligature-set-ligatures 'prog-mode '("--" "---" "==" "===" "!=" "!==" "=!="
                                       "=:=" "=/=" "<=" ">=" "&&" "&&&" "&=" "++" "+++" "***" ";;" "!!"
                                       "??" "???" "?:" "?." "?=" "<:" ":<" ":>" ">:" "<:<" "<>" "<<<" ">>>"
                                       "<<" ">>" "||" "-|" "_|_" "|-" "||-" "|=" "||=" "##" "###" "####"
                                       "#{" "#[" "]#" "#(" "#?" "#_" "#_(" "#:" "#!" "#=" "^=" "<$>" "<$"
                                       "$>" "<+>" "<+" "+>" "<*>" "<*" "*>" "</" "</>" "/>" "<!--" "<#--"
                                       "-->" "->" "->>" "<<-" "<-" "<=<" "=<<" "<<=" "<==" "<=>" "<==>"
                                       "==>" "=>" "=>>" ">=>" ">>=" ">>-" ">-" "-<" "-<<" ">->" "<-<" "<-|"
                                       "<=|" "|=>" "|->" "<->" "<~~" "<~" "<~>" "~~" "~~>" "~>" "~-" "-~"
                                       "~@" "[||]" "|]" "[|" "|}" "{|" "[<" ">]" "|>" "<|" "||>" "<||"
                                       "|||>" "<|||" "<|>" "..." ".." ".=" "..<" ".?" "::" ":::" ":=" "::="
                                       ":?" ":?>" "//" "///" "/*" "*/" "/=" "//=" "/==" "@_" "__" "???"
                                       "<:<" ";;;")))

(use-package indent-bars
  :defer t
  :vc (indent-bars :url "https://github.com/jdtsmith/indent-bars" :branch "main" :rev :newest)
  :custom
  (indent-bars-color '(highlight :face-bg t :blend 0.15))
  (indent-bars-highlight-current-depth '(:blend 0.5))
  (indent-bars-treesit-support t)
  (indent-bars-treesit-ignore-blank-lines-types '("comment"))
  (indent-bars-width-frac 0.1)
  (indent-bars-prefer-character t))

(use-package breadcrumb
  :defer t
  :custom
  (breadcrumb-imenu-crumb-separator " ")
  (breadcrumb-project-crumb-separator " ")
  (breadcrumb-imenu-max-length 1.0)
  (breadcrumb-project-max-length 1.0)
  :preface
  (advice-add #'breadcrumb--format-project-node :around
              (lambda (og p more &rest r)
                (let ((string (apply og p more r)))
                  (if (not more)
                      (concat (nerd-icons-icon-for-file string) " " string)
                    (concat (nerd-icons-faicon "nf-fa-folder_open" :face 'breadcrumb-project-crumbs-face) " " string)))))
  (advice-add #'breadcrumb--project-crumbs-1 :filter-return
              (lambda (return)
                (when (listp return)
                  (setf (car return)
                        (concat " " (nerd-icons-faicon "nf-fa-rocket" :face 'breadcrumb-project-base-face) " " (car return))))
                return))
  (advice-add #'breadcrumb--format-ipath-node :around
              (lambda (og p more &rest r)
                (let ((string (apply og p more r)))
                  (if (not more)
                      (concat (nerd-icons-codicon "nf-cod-symbol_field" :face 'breadcrumb-imenu-leaf-face) " " string)
                    (cond ((string= string "Packages")
                           (concat (nerd-icons-codicon "nf-cod-package" :face 'breadcrumb-imenu-crumbs-face) " " string))
                          ((or (string= string "Property") (string= string "Properties"))
                           (concat (nerd-icons-codicon "nf-cod-symbol_property" :face 'breadcrumb-imenu-crumbs-face) " " string))
                          ((string= string "Requires")
                           (concat (nerd-icons-codicon "nf-cod-file_submodule" :face 'breadcrumb-imenu-crumbs-face) " " string))
                          ((or (string= string "Variable") (string= string "Variables"))
                           (concat (nerd-icons-codicon "nf-cod-symbol_variable" :face 'breadcrumb-imenu-crumbs-face) " " string))
                          ((string= string "Function")
                           (concat (nerd-icons-mdicon "nf-md-function_variant" :face 'breadcrumb-imenu-crumbs-face) " " string))
                          (t string)))))))

(use-package rainbow-delimiters :ensure t)

(use-package highlight-symbol
  :defer t
  :custom
  (highlight-symbol-idle-delay 0.8)
  (highlight-symbol-highlight-single-occurrence nil))

(use-package flycheck
  :ensure t
  :defer t
  :config
  (add-to-list 'flycheck-checkers 'javascript-eslint)
  (flycheck-add-mode 'javascript-eslint 'tsx-ts-mode)
  :custom
  (flycheck-check-syntax-automatically '(save mode-enabled idle-change))
  (flycheck-idle-change-delay 1.0)
  (flycheck-idle-buffer-switch-delay 1.0)
  (flycheck-indication-mode nil)
  (flycheck-checker-error-threshold 100))

(use-package drag-stuff
  :ensure t
  :defer t
  :bind (:map evil-visual-state-map
              ("C-j" . drag-stuff-down)
              ("C-k" . drag-stuff-up)))

(use-package dumb-jump
  :ensure t
  :defer t
  :custom
  (dumb-jump-window 'other)
  (dumb-jump-quiet t)
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  (setopt xref-show-definitions-function #'xref-show-definitions-completing-read))

(use-package hl-todo
  :ensure t
  :defer t
  :custom
  (hl-todo-highlight-punctuation ":")
  (hl-todo-keyword-faces
   '(("TODO"   . "#1E90FF")
     ("FIXME"  . "#FF4500")
     ("DEBUG"  . "#A020F0")
     ("GOTCHA" . "#FF8C00")
     ("STUB"   . "#1E90FF")
     ("MARK"   . "#777777")
     ("NOTE"   . "#00CED1")
     ("HACK"   . "#FF0000")
     ("REVIEW" . "#ADFF2F"))))

(use-package expand-region
  :ensure t
  :defer t
  :commands er/expand-region)

;;; --- Flyover (inline errors) ---

(use-package flyover
  :ensure nil
  :hook (flycheck-mode . flyover-mode)
  :custom
  (flyover-checkers '(flymake flycheck))
  (flyover-levels '(error warning info))
  (flyover-show-at-eol t)
  (flyover-use-theme-colors t)
  (flyover-background-lightness 40)
  (flyover-icon-background-tint 'darker)
  (flyover-icon-background-tint-percent 40)
  (flyover-icon-tint 'lighter)
  (flyover-icon-tint-percent 50)
  (flyover-text-tint 'lighter)
  (flyover-text-tint-percent 80)
  (flyover-icon-left-padding 0.55)
  (flyover-border-style 'pill)
  (flyover-border-match-icon t)
  (flyover-hide-checker-name t)
  (flyover-show-virtual-line t)
  (flyover-virtual-line-type 'none)
  (flyover-line-position-offset 1)
  (flyover-show-error-id t)
  (flyover-wrap-messages t)
  (flyover-max-line-length 80)
  (flyover-debounce-interval 0.2)
  (flyover-cursor-debounce-interval 0.3)
  (flyover-display-mode 'always))

(use-package flycheck-eglot
  :ensure nil
  :hook (eglot-managed-mode . flycheck-eglot-mode)
  :custom (flycheck-eglot-exclusive nil))

(use-package flycheck-package
  :ensure t
  :defer t
  :after flycheck
  :hook (emacs-lisp-mode . flycheck-package-setup))

;;; --- Eglot + dumb-jump xref fallback ---

(defun mk/toggle-flycheck-errors ()
  "Toggle the flycheck errors list buffer."
  (interactive)
  (if (get-buffer "*Flycheck errors*")
      (kill-buffer "*Flycheck errors*")
    (list-flycheck-errors)))

(defun xref-eglot+dumb-backend ()
  "Xref backend combining eglot with dumb-jump fallback."
  'eglot+dumb)

(advice-add 'eglot-xref-backend :override 'xref-eglot+dumb-backend)

(cl-defmethod xref-backend-identifier-at-point ((_backend (eql eglot+dumb)))
  (cons (xref-backend-identifier-at-point 'eglot)
        (xref-backend-identifier-at-point 'dumb-jump)))

(cl-defmethod xref-backend-identifier-completion-table ((_backend (eql eglot+dumb)))
  (xref-backend-identifier-completion-table 'eglot))

(cl-defmethod xref-backend-definitions ((_backend (eql eglot+dumb)) identifier)
  (or (xref-backend-definitions 'eglot (car identifier))
      (xref-backend-definitions 'dumb-jump (cdr identifier))))

(cl-defmethod xref-backend-references ((_backend (eql eglot+dumb)) identifier)
  (or (xref-backend-references 'eglot (car identifier))
      (xref-backend-references 'dumb-jump (cdr identifier))))

(cl-defmethod xref-backend-apropos ((_backend (eql eglot+dumb)) pattern)
  (xref-backend-apropos 'eglot pattern))

;;; --- Project ---

(put 'narrow-to-region 'disabled nil)

(defun project-root-override (dir)
  "Find DIR's project root via .xcodeproj, .envrc, or .projectile markers."
  (let ((root (or (locate-dominating-file dir ".xcodeproj")
                  (locate-dominating-file dir ".envrc")
                  (locate-dominating-file dir ".projectile")))
        (backend (ignore-errors (vc-responsible-backend dir))))
    (when root (list 'vc backend root))))

(use-package project
  :ensure nil
  :defer t
  :custom
  (project-switch-commands 'project-dired)
  :config
  (setopt project-files-relative-names t
          project-vc-ignores '(".git/" ".direnv/" "node_modules/" "dist/" ".*"))
  (add-hook 'project-find-functions #'project-root-override))

;;; --- Compilation ---

(use-package compile
  :ensure nil
  :defer t
  :hook (compilation-mode . visual-line-mode)
  :custom
  (compilation-always-kill t)
  (compilation-auto-jump-to-first-error t)
  (compilation-ask-about-save nil)
  (compilation-scroll-output 'all)
  (compilation-highlight-overlay t)
  (compilation-environment '("TERM=xterm-256color"))
  (compilation-window-height 10)
  (compilation-reuse-window t)
  (compilation-max-output-line-length nil)
  (compilation-error-screen-columns nil)
  (ansi-color-for-compilation-mode t)
  :config
  (add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)
  (add-hook 'compilation-filter-hook #'mk/compilation-auto-scroll)
  (add-hook 'compilation-finish-functions
            (lambda (buf str)
              (cond
               ((string-match "finished" str)
                (message "Compilation finished successfully")
                (run-at-time 1 nil (lambda ()
                                     (delete-windows-on buf)
                                     (bury-buffer buf))))
               ((string-match "exited abnormally" str)
                (message "Compilation failed"))))))

(defun mk/compilation-auto-scroll ()
  "Scroll compilation buffer to bottom when visible."
  (when-let* ((buffer (get-buffer "*compilation*"))
              (window (get-buffer-window buffer t)))
    (with-selected-window window
      (goto-char (point-max)))))

(defun mk/compilation-get-errors ()
  "Extract and display compilation errors."
  (interactive)
  (if (not compilation-locs)
      (message "No compilation errors found")
    (let ((errors '()))
      (maphash (lambda (_ value)
                 (when (and (car value) (compilation--loc->file-struct (car value)))
                   (let* ((loc (car value))
                          (file-struct (compilation--loc->file-struct loc))
                          (file (caar file-struct))
                          (line (compilation--loc->line loc))
                          (col (compilation--loc->col loc)))
                     (push (format "%s:%d:%d" file line (or col 0)) errors))))
               compilation-locs)
      (if errors
          (with-output-to-temp-buffer "*Compilation Errors*"
            (princ (format "Found %d error(s):\n\n" (length errors)))
            (dolist (error (sort errors 'string<))
              (princ (format "  %s\n" error))))
        (message "No compilation errors found")))))

;;; --- Debugger ---

(use-package dape
  :ensure t
  :commands (dape-info dape-repl dape)
  :hook
  ((dape-compile . kill-buffer)
   (dape-display-source . pulse-momentary-highlight-one-line)
   (dape-stopped . dape-info)
   (dape-stopped . dape-repl))
  :custom
  (dape-buffer-window-arrangement 'right)
  (dape-inlay-hints t))

(use-package repeat
  :ensure nil
  :defer t
  :hook (dape-on-start . repeat-mode)
  :custom
  (repeat-too-dangerous '(kill-this-buffer))
  (repeat-exit-timeout 5))

;;; --- Periphery (Swift tooling) ---

(use-package periphery-quick
  :ensure nil
  :after periphery-helper
  :commands (periphery-quick:find periphery-quick:find-ask periphery-quick:todos periphery-quick:find-in-file))

(use-package periphery-search
  :ensure nil
  :after periphery-helper
  :commands periphery-query-todos-and-fixmes)

;;; --- Prog-mode hooks ---

(use-package prog-mode
  :ensure nil
  :hook ((emacs-lisp-mode . electric-indent-mode)
         (prog-mode . electric-pair-mode)
         (prog-mode . highlight-symbol-mode)
         (prog-mode . drag-stuff-mode)
         (prog-mode . hl-todo-mode)
         (prog-mode . mk/maybe-enable-hs-mode)
         (prog-mode . rainbow-delimiters-mode)
         (prog-mode . flycheck-mode)
         (prog-mode . breadcrumb-mode)
         (prog-mode . display-line-numbers-mode)
         (prog-mode . indent-bars-mode)
         (prog-mode . prettify-symbols-mode)
         (prog-mode . (lambda ()
                        (setq-local tab-width 4
                                    indent-tabs-mode nil
                                    truncate-lines t))))
  :custom
  (display-line-numbers-widen t)
  (display-line-numbers-type 'relative)
  (display-line-numbers-width 4))

(use-package treesit
  :ensure nil
  :defer t
  :custom
  (treesit-font-lock-level 4))

(provide 'mk-development)
;;; mk-development.el ends here

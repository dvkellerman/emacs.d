;;; mk-tty.el --- Terminal (TTY) support -*- lexical-binding: t; -*-
;;; Commentary:
;; Adjustments for running Emacs in a terminal emulator.
;; Handles colors, mouse, clipboard, and UI fallbacks.
;;; Code:

(unless (display-graphic-p)

  ;; True color support (most modern terminals support this)
  (when (getenv "COLORTERM")
    (set-terminal-parameter nil 'background-mode 'dark))

  ;; Mouse support in terminal
  (xterm-mouse-mode 1)
  (global-set-key [mouse-4] (lambda () (interactive) (scroll-down 3)))
  (global-set-key [mouse-5] (lambda () (interactive) (scroll-up 3)))

  ;; System clipboard integration via OSC 52 (works in most modern terminals)
  (when (fboundp 'xterm-paste)
    (global-set-key [xterm-paste] #'xterm-paste))

  ;; Use osc.el for clipboard (Emacs 29+)
  (when (require 'osc nil t)
    (osc-foreign-selection-mode 1))

  ;; macOS: use pbcopy/pbpaste for kill-ring ↔ system clipboard
  (when (eq system-type 'darwin)
    (setq interprogram-cut-function
          (lambda (text &rest _)
            (let ((process-connection-type nil))
              (let ((proc (start-process "pbcopy" nil "pbcopy")))
                (process-send-string proc text)
                (process-send-eof proc))))
          interprogram-paste-function
          (lambda ()
            (let ((clip (shell-command-to-string "pbpaste")))
              (unless (string= clip (car kill-ring))
                clip)))))

  ;; Vertico: disable posframe in TTY (falls back to minibuffer)
  (with-eval-after-load 'vertico-posframe
    (setq vertico-multiform-commands
          '((t (:not posframe)))))

  ;; Eldoc-box: disable hover in TTY (no child frames)
  (with-eval-after-load 'eldoc-box
    (eldoc-box-hover-mode -1))

  ;; Corfu: use popup in terminal mode
  (with-eval-after-load 'corfu
    (when (fboundp 'corfu-terminal-mode)
      (corfu-terminal-mode 1)))

  ;; diff-hl: use margin mode instead of fringe (no fringes in TTY)
  (with-eval-after-load 'diff-hl
    (diff-hl-margin-mode 1))

  ;; Knockknock: disable posframe notifications in TTY
  (with-eval-after-load 'knockknock
    (setq knockknock-use-posframe nil))

  ;; Better cursor visibility
  (setq visible-cursor t)

  ;; Menu bar can be useful in TTY (press F10)
  ;; (menu-bar-mode 1)

  ;; Fix keys that terminals can't send properly
  (define-key input-decode-map "\e[1;5A" [C-up])
  (define-key input-decode-map "\e[1;5B" [C-down])
  (define-key input-decode-map "\e[1;5C" [C-right])
  (define-key input-decode-map "\e[1;5D" [C-left])
  (define-key input-decode-map "\e[1;3A" [M-up])
  (define-key input-decode-map "\e[1;3B" [M-down])
  (define-key input-decode-map "\e[1;3C" [M-right])
  (define-key input-decode-map "\e[1;3D" [M-left]))

(provide 'mk-tty)
;;; mk-tty.el ends here

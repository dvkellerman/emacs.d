;;; mk-term.el --- Terminal management -*- lexical-binding: t; -*-
;;; Commentary:
;; Vterm configuration and toggle command.
;;; Code:

(add-hook 'comint-mode-hook
          (lambda ()
            (setq-local comint-prompt-read-only t)
            (visual-line-mode 1)))

(use-package vterm
  :ensure t
  :commands (vterm vterm-other-window)
  :hook (vterm-mode . (lambda () (hl-line-mode -1)))
  :custom
  (vterm-timer-delay nil)
  (vterm-kill-buffer-on-exit t))

(defun toggle-vterm ()
  "Toggle vterm buffer visibility."
  (interactive)
  (if (get-buffer "*vterm*")
      (if (eq (current-buffer) (get-buffer "*vterm*"))
          (delete-window)
        (switch-to-buffer-other-window "*vterm*"))
    (vterm-other-window)))

(provide 'mk-term)
;;; mk-term.el ends here

;;; mk-vc.el --- Version control -*- lexical-binding: t; -*-
;;; Commentary:
;; Magit, git-timemachine, and diff-hl configuration.
;;; Code:

(use-package magit
  :ensure t
  :commands (magit magit-status magit-log-buffer-file magit-diff-buffer-file)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  (magit-diff-refine-hunk 'all)
  :config
  (setq magit-repository-directories `((,(expand-file-name user-emacs-directory) . 2)
                                       ("~/Documents/git" . 1))
        magit-format-file-function #'magit-format-file-nerd-icons))

(use-package git-timemachine
  :ensure t
  :commands (git-timemachine git-timemachine-toggle))

(defun mk/enable-diff-hl-if-git ()
  "Enable diff-hl-mode if buffer is in a Git repo."
  (when-let* ((file buffer-file-name)
              (backend (vc-backend file)))
    (when (eq backend 'Git)
      (diff-hl-mode 1)
      (when (display-graphic-p)
        (diff-hl-margin-mode 1)))))

(use-package diff-hl
  :ensure t
  :hook (prog-mode . mk/enable-diff-hl-if-git)
  :custom
  (diff-hl-disable-on-remote t)
  (diff-hl-side 'left)
  (diff-hl-margin-symbols-alist '((insert . "┃")
                                  (delete . "┃")
                                  (change . "┃")
                                  (unknown . "?")
                                  (ignored . "i"))))

(provide 'mk-vc)
;;; mk-vc.el ends here

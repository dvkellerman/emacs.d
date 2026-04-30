;;; mk-notifications.el --- Desktop notifications via KnockKnock -*- lexical-binding: t; -*-
;;; Commentary:
;; Shows posframe notifications for important Emacs messages (errors, builds, etc.)
;;; Code:

(require 'knockknock nil t)

(defun mk/notify-classify-icon (msg)
  "Return a Nerd Font icon name based on MSG content."
  (cond
   ((string-match-p "\\(error\\|failed?\\|exception\\)" msg) "nf-cod-error")
   ((string-match-p "\\(warn\\|warning\\)" msg) "nf-cod-warning")
   ((string-match-p "\\(success\\|completed?\\|passed\\)" msg) "nf-cod-check")
   ((string-match-p "\\(build\\|compil\\|make\\)" msg) "nf-cod-tools")
   ((string-match-p "\\(info\\|note\\)" msg) "nf-cod-info")
   (t "nf-fa-info_circle")))

(defun mk/notify (title message &optional duration)
  "Show a knockknock notification with TITLE, MESSAGE, and optional DURATION."
  (when (fboundp 'knockknock-notify)
    (knockknock-notify
     :title title
     :message message
     :icon (mk/notify-classify-icon message)
     :duration (or duration 3))))

(provide 'mk-notifications)
;;; mk-notifications.el ends here

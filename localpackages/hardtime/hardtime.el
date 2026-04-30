;;; hardtime.el --- Hardtime mode for Emacs -*- lexical-binding: t; -*-
;;; Commentary:
;; Stub for hardtime mode - prevents repeated key presses.
;;; Code:

(defgroup hardtime nil
  "Hardtime mode to build better Vim habits."
  :group 'convenience)

(defcustom hardtime-notification-type 'message
  "How to notify the user."
  :type 'symbol
  :group 'hardtime)

(defvar hardtime-mode nil)

;;;###autoload
(define-minor-mode global-hardtime-mode
  "Global minor mode to discourage repeated key usage."
  :global t
  :lighter " HT"
  :group 'hardtime)

(provide 'hardtime)
;;; hardtime.el ends here

;;; swift-ts-mode.el --- Tree-sitter major mode for Swift -*- lexical-binding: t; -*-

;; Copyright (C) 2024
;; Author: Mikael Konradsson
;; Version: 1.0.0
;; Package-Requires: ((emacs "29.1"))
;; Keywords: languages, swift, tree-sitter

;;; Commentary:
;; A tree-sitter based major mode for editing Swift files.

;;; Code:

(require 'treesit nil t)

(defgroup swift-ts nil
  "Swift tree-sitter mode."
  :group 'languages
  :prefix "swift-ts-")

(defcustom swift-ts-basic-offset 4
  "Basic indentation offset for Swift."
  :type 'integer
  :group 'swift-ts)

(defcustom swift-ts:indent-trailing-call-member t
  "Whether to indent trailing call members."
  :type 'boolean
  :group 'swift-ts)

(defvar swift-ts-mode-map (make-sparse-keymap)
  "Keymap for `swift-ts-mode'.")

;;;###autoload
(defun swift-ts:split-func-list ()
  "Split function parameter list into multiple lines."
  (interactive)
  (message "swift-ts:split-func-list not available in stub mode"))

(defvar swift-ts-mode--font-lock-rules nil
  "Font lock rules for swift-ts-mode.")

(when (and (fboundp 'treesit-available-p)
           (treesit-available-p))

  (setq swift-ts-mode--font-lock-rules
        (treesit-font-lock-rules
         :language 'swift
         :feature 'comment
         '((comment) @font-lock-comment-face
           (multiline_comment) @font-lock-comment-face)

         :language 'swift
         :feature 'keyword
         '(["import" "let" "var" "func" "class" "struct" "enum" "protocol"
            "extension" "return" "if" "else" "guard" "switch" "case" "default"
            "for" "in" "while" "repeat" "break" "continue" "throw" "throws"
            "try" "catch" "do" "async" "await" "typealias" "associatedtype"
            "init" "deinit" "subscript" "operator" "precedencegroup"
            "where" "some" "any" "Self" "self" "super" "nil"
            "true" "false" "is" "as" "static" "private" "fileprivate"
            "internal" "public" "open" "mutating" "nonmutating"
            "override" "final" "required" "convenience" "lazy"
            "weak" "unowned" "willSet" "didSet" "get" "set"
            "inout" "defer" "indirect" "@" "#"] @font-lock-keyword-face)

         :language 'swift
         :feature 'string
         '((line_string_literal) @font-lock-string-face
           (multi_line_string_literal) @font-lock-string-face)

         :language 'swift
         :feature 'type
         '((type_identifier) @font-lock-type-face
           (user_type (type_identifier) @font-lock-type-face))

         :language 'swift
         :feature 'function
         '((function_declaration name: (simple_identifier) @font-lock-function-name-face)
           (call_expression (simple_identifier) @font-lock-function-call-face))

         :language 'swift
         :feature 'number
         '((integer_literal) @font-lock-number-face
           (real_literal) @font-lock-number-face))))

;;;###autoload
(define-derived-mode swift-ts-mode prog-mode "Swift"
  "Major mode for editing Swift files, powered by tree-sitter."
  :group 'swift-ts
  :syntax-table (let ((table (make-syntax-table)))
                  (modify-syntax-entry ?/ ". 124" table)
                  (modify-syntax-entry ?* ". 23b" table)
                  (modify-syntax-entry ?\n ">" table)
                  (modify-syntax-entry ?\" "\"" table)
                  table)

  (setq-local tab-width swift-ts-basic-offset)
  (setq-local indent-tabs-mode nil)
  (setq-local comment-start "// ")
  (setq-local comment-end "")
  (setq-local comment-start-skip "//+\\s-*")

  (when (and (fboundp 'treesit-ready-p)
             (treesit-ready-p 'swift t))
    (treesit-parser-create 'swift)
    (setq-local treesit-font-lock-settings swift-ts-mode--font-lock-rules)
    (setq-local treesit-font-lock-feature-list
                '((comment)
                  (keyword string)
                  (type function)
                  (number)))
    (treesit-major-mode-setup)))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.swift\\'" . swift-ts-mode))
;;;###autoload
(add-to-list 'auto-mode-alist '("\\.swiftinterface\\'" . swift-ts-mode))

(provide 'swift-ts-mode)
;;; swift-ts-mode.el ends here

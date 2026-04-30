;;; mk-web.el --- Web development modes -*- lexical-binding: t; -*-
;;; Commentary:
;; Configuration for TypeScript, XML, and Markdown.
;;; Code:

(use-package nxml-mode
  :ensure nil
  :mode "\\.xml\\'"
  :hook ((nxml-mode . display-line-numbers-mode)
         (nxml-mode . colorful-mode)))

(use-package typescript-ts-mode
  :ensure nil
  :mode (("\\.ts\\'"  . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode)
         ("\\.js\\'"  . typescript-ts-mode)
         ("\\.mjs\\'" . typescript-ts-mode)
         ("\\.mts\\'" . typescript-ts-mode)
         ("\\.cjs\\'" . typescript-ts-mode)
         ("\\.jsx\\'" . tsx-ts-mode))
  :hook (typescript-ts-base-mode . (lambda ()
                                     (setq-local tab-width 4
                                                 typescript-ts-mode-indent-offset 4
                                                 js-indent-level 4))))

(use-package markdown-ts-mode
  :ensure nil
  :mode "\\.md\\'")

(provide 'mk-web)
;;; mk-web.el ends here

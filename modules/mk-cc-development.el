;;; mk-cc-development.el --- C/C++ development -*- lexical-binding: t; -*-
;;; Commentary:
;; C and C++ development using tree-sitter modes, eglot (clangd), and CMake support.
;;; Code:

;; Remap classic C/C++ modes to tree-sitter variants
(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
(add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))

(use-package c-ts-mode
  :ensure nil
  :mode (("\\.c\\'" . c-ts-mode)
         ("\\.h\\'" . c-ts-mode)
         ("\\.cpp\\'" . c++-ts-mode)
         ("\\.cc\\'" . c++-ts-mode)
         ("\\.cxx\\'" . c++-ts-mode)
         ("\\.hpp\\'" . c++-ts-mode)
         ("\\.hxx\\'" . c++-ts-mode))
  :hook ((c-ts-mode . eglot-ensure)
         (c++-ts-mode . eglot-ensure))
  :custom
  (c-ts-mode-indent-offset 4)
  (c-ts-mode-indent-style 'k&r)
  :config
  (dolist (lang '((c . ("https://github.com/tree-sitter/tree-sitter-c"))
                  (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))))
    (add-to-list 'treesit-language-source-alist lang)
    (unless (treesit-language-available-p (car lang))
      (treesit-install-language-grammar (car lang)))))

(use-package cmake-ts-mode
  :ensure nil
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'")
  :config
  (add-to-list 'treesit-language-source-alist '(cmake . ("https://github.com/uyha/tree-sitter-cmake")))
  (unless (treesit-language-available-p 'cmake)
    (treesit-install-language-grammar 'cmake)))

(use-package make-mode
  :ensure nil
  :mode (("Makefile\\'" . makefile-mode)
         ("makefile\\'" . makefile-mode)
         ("\\.mk\\'" . makefile-mode)))

(provide 'mk-cc-development)
;;; mk-cc-development.el ends here

;;; init-eglot.el --- LSP support via eglot          -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(when (maybe-require-package 'eglot)
  (maybe-require-package 'consult-eglot)

  (defun sanityinc/setup-typescript-keys ()
    "Set buffer-local keybindings for TypeScript navigation and refactors."
    (local-set-key (kbd "C-c . f") #'xref-find-references)
    (local-set-key (kbd "C-c . r") #'eglot-rename)
    (local-set-key (kbd "C-c . a") #'eglot-code-actions))

  (defun sanityinc/enable-eglot-for-typescript ()
    "Enable Eglot in TypeScript buffers when the language server is available."
    (when (executable-find "typescript-language-server")
      (eglot-ensure)))

  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '((typescript-mode typescript-ts-mode tsx-ts-mode)
                   . ("typescript-language-server" "--stdio"))))

  (dolist (hook '(typescript-mode-hook
                  typescript-ts-mode-hook
                  tsx-ts-mode-hook))
    (add-hook hook 'sanityinc/setup-typescript-keys)
    (add-hook hook 'sanityinc/enable-eglot-for-typescript)))



(provide 'init-eglot)
;;; init-eglot.el ends here

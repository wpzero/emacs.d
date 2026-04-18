;;; init-eglot.el --- LSP support via eglot          -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(when (maybe-require-package 'eglot)
  (maybe-require-package 'consult-eglot)

  (defun sanityinc/typescript-eglot-ensure ()
    "Ensure Eglot is active in the current TypeScript buffer."
    (unless (eglot-managed-p)
      (sanityinc/enable-eglot-for-typescript))
    (unless (eglot-managed-p)
      (condition-case nil
          (eglot)
        (error nil)))
    (when (eglot-managed-p)
      t))

  (defun sanityinc/typescript-find-references ()
    "Find references in TypeScript buffers via xref, starting Eglot if needed."
    (interactive)
    (unless (sanityinc/typescript-eglot-ensure)
      (user-error "Eglot is not active for this TypeScript buffer"))
    (let ((xref-backend-functions '(eglot-xref-backend t)))
      (call-interactively #'xref-find-references)))

  (defun sanityinc/typescript-eglot-doctor ()
    "Show TypeScript/Eglot diagnostics for the current buffer."
    (interactive)
    (let* ((project (ignore-errors (project-current)))
           (project-root (and project (ignore-errors (project-root project))))
           (server (ignore-errors (eglot-current-server))))
      (message
       (concat
        "file=%S mode=%S default-directory=%S project-root=%S "
        "managed=%S server=%S ts-ls=%S tsserver=%S")
       (buffer-file-name)
       major-mode
       default-directory
       project-root
       (ignore-errors (eglot-managed-p))
       server
       (executable-find "typescript-language-server")
       (executable-find "tsserver"))))

  (defun sanityinc/setup-typescript-xref ()
    "Prefer Eglot over JavaScript-specific xref backends in TypeScript buffers."
    (when (boundp 'xref-backend-functions)
      (remove-hook 'xref-backend-functions #'xref-js2-xref-backend t)))

  (defun sanityinc/setup-typescript-keys ()
    "Set buffer-local keybindings for TypeScript navigation and refactors."
    (local-set-key (kbd "C-c . f") #'sanityinc/typescript-find-references)
    (local-set-key (kbd "C-c . r") #'eglot-rename)
    (local-set-key (kbd "C-c . a") #'eglot-code-actions)
    (local-set-key (kbd "C-c . d") #'sanityinc/typescript-eglot-doctor))

  (defun sanityinc/enable-eglot-for-typescript ()
    "Enable Eglot in TypeScript buffers when the language server is available."
    ;; Some projects provide the language server from node_modules/.bin.
    ;; Make sure that path has been added before probing for the executable.
    (when (fboundp 'add-node-modules-path)
      (add-node-modules-path))
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
    (add-hook hook 'sanityinc/setup-typescript-xref)
    (add-hook hook 'sanityinc/enable-eglot-for-typescript)))



(provide 'init-eglot)
;;; init-eglot.el ends here

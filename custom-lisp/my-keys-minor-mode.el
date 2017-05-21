;;; custom minor mode for myself
(defvar my-keys-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "M-<") 'beginning-of-buffer)
    (define-key map (kbd "M->") 'end-of-buffer)
    (define-key map (kbd "C-M-s") 'isearch-forward-regexp)
    (define-key map (kbd "C-M-r") 'isearch-backward-regexp)
    map)
  "my-keys-minor-mode keymap.")

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  :init-value t
  :lighter " my-keys")

(my-keys-minor-mode 1)

(defun my-minibuffer-setup-hook ()
  (my-keys-minor-mode 0))

(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)


(provide 'my-keys-minor-mode)

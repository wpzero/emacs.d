;;; Multi-term START
(require 'multi-term)
(setq multi-term-program "/bin/zsh")
(global-set-key (kbd "C-c C-t") 'multi-term)
(global-set-key (kbd "C-c C-n") 'multi-term-next)
(global-set-key (kbd "C-c C-p") 'multi-term-next)
;;; Multi-term END

;;; line mode use term-raw-map
(define-key term-raw-map (kbd "C-y") 'term-paste)
;;; char mode use term-mode-map
(define-key term-mode-map (kbd "C-y") 'term-paste)

(define-key term-mode-map (kbd "C-c C-j") 'term-line-mode)
(define-key term-raw-map (kbd "C-c C-j") 'term-line-mode)

(define-key term-mode-map (kbd "C-c C-k") 'term-char-mode)
(define-key term-raw-map (kbd "C-c C-k") 'term-char-mode)

(provide 'my-multi-term)

;;; Multi-term START
(require 'multi-term)
(setq multi-term-program "/bin/zsh")
(global-set-key (kbd "C-c C-t") 'multi-term)
(global-set-key (kbd "C-c C-n") 'multi-term-next)
(global-set-key (kbd "C-c C-p") 'multi-term-next)
;;; Multi-term END

(provide 'my-multi-term)

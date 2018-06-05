;;; C CONFIG START
;;; irony complete function
;;; need to use compile_commands.json to setup cdb
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;;; rtags
(require 'rtags)
(setq rtags-path "/home/wpzero/workspace/c_workspace/rtags/bin")
(setq rtags-autostart-diagnostics t)
(setq rtags-display-result-backend 'ivy)

(define-key c++-mode-map (kbd "M-.") 'rtags-find-symbol-at-point)
(define-key c++-mode-map (kbd "M-,") 'rtags-location-stack-back)
(define-key c++-mode-map (kbd "C-.") 'rtags-find-references)

(define-key c-mode-map (kbd "M-.") 'rtags-find-symbol-at-point)
(define-key c-mode-map (kbd "M-,") 'rtags-location-stack-back)
(define-key c-mode-map (kbd "C-.") 'rtags-find-references)

;;; add etags table, auto add
(require 'etags-table)
;;; C CONFIG END

;;; c style
(setq c-default-style "linux"
      c-basic-offset 8)

(provide 'my-c-config)

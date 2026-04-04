;;; init-xterm.el --- Integrate with terminals such as xterm -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require 'init-frame-hooks)

(global-set-key [mouse-4] (lambda () (interactive) (scroll-down 1)))
(global-set-key [mouse-5] (lambda () (interactive) (scroll-up 1)))

(autoload 'mwheel-install "mwheel")

(defun sanityinc/terminal-macos-clipboard-available-p ()
  "Return non-nil when macOS pasteboard tools are available in a terminal frame."
  (and (eq system-type 'darwin)
       (not (display-graphic-p))
       (executable-find "pbcopy")
       (executable-find "pbpaste")
       t))

(defun sanityinc/copy-to-macos-clipboard (text &optional _push)
  "Copy TEXT to the macOS clipboard from terminal Emacs."
  (when (and text (sanityinc/terminal-macos-clipboard-available-p))
    (with-temp-buffer
      (insert text)
      (call-process-region (point-min) (point-max) "pbcopy"))))

(defun sanityinc/paste-from-macos-clipboard ()
  "Return clipboard contents from the macOS pasteboard in terminal Emacs."
  (when (sanityinc/terminal-macos-clipboard-available-p)
    (with-temp-buffer
      (when (zerop (call-process "pbpaste" nil t))
        (buffer-string)))))

(defun sanityinc/enable-terminal-macos-clipboard ()
  "Bridge the Emacs kill ring with the macOS clipboard in terminal Emacs."
  (when (sanityinc/terminal-macos-clipboard-available-p)
    (setq select-enable-clipboard t)
    (setq interprogram-cut-function #'sanityinc/copy-to-macos-clipboard)
    (setq interprogram-paste-function #'sanityinc/paste-from-macos-clipboard)))

(defun sanityinc/console-frame-setup ()
  (sanityinc/enable-terminal-macos-clipboard)
  (xterm-mouse-mode 1) ; Mouse in a terminal (Use shift to paste with middle button)
  (mwheel-install))



(add-hook 'after-make-console-frame-hooks 'sanityinc/console-frame-setup)

(provide 'init-xterm)
;;; init-xterm.el ends here

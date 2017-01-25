;; This file contains some functions needing autoload
;; show file name
(defun show-file-name ()
  "Show the full path file name in the echo"
  (interactive)
  (message (buffer-file-name)))

(defun server-shutdown ()
  "Save buffers, Quit and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs))

(defun open-custom-init-file ()
  "Open custom init file"
  (interactive)
  (find-file "~/.emacs.d/custom-lisp/custom-init.el"))

(defun open-init-file ()
  "Open init file"
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(provide 'custom-autoload)

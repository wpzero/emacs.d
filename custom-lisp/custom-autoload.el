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

(provide 'custom-autoload)

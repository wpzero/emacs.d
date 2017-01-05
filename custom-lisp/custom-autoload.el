;; This file contains some functions needing autoload
;; show file name
(defun show-file-name ()
  "Show the full path file name in the echo"
  (interactive)
  (message (buffer-file-name)))

(provide 'custom-autoload)

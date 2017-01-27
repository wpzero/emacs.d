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

;;; An example to interactive function
;; (defun multiple-hello (someone num)
;;   "Say hello to SOMEONE via M-x hello, for NUM times"
;;   (interactive "sWho do you want to say hello to? \nnHow many times?")
;;   (dotimes (i num)
;;     (insert (format "Hello %s\n" someone))))

;;; An example to interactive
;; (defun show-interactive-r (begin end)
;;   (interactive "r")
;;   (message (format "begin: %d, end: %d" begin end)))

;;; Insert around region
(defun wrap-char-region (str)
  "Wrap insert a char, and the around region is same char, replace them"
  (interactive "sInsert string: ")
  (save-excursion
    (let ((region-beginning (region-beginning))
          (region-end (region-end)))
      (if (and (not (eq region-beginning region-end)) (eq (char-after region-beginning) (char-before region-end)))
          (progn
            (goto-char region-beginning)
            (delete-char 1)
            (insert str)
            (goto-char (- region-end 1))
            (delete-char 1)
            (insert str))
        (progn
          (goto-char region-beginning)
          (insert str)
          (goto-char (+ region-end 1))
          (insert str)
          )))))

;;; Mark current word
(defun select-current-word ()
  "Select the word under cursor.
“word“ here is considered any alphanumeric sequence with “_” or “-”."
  (interactive)
  (let (pt)
    (skip-chars-backward "-_A-Za-z0-9")
    (setq pt (point))
    (skip-chars-forward "-_A-Za-z0-9")
    (set-mark pt)))

;;; Select current line
(defun select-current-line ()
  "Select the current line"
  (interactive)
  (end-of-line)
  (set-mark (line-beginning-position)))

;;; Select next line
(defun select-next-line (arg)
  "Select a line"
  (interactive "p")
  (forward-line (prefix-numeric-value arg))
  (end-of-line)
  (select-current-line))

;;; Select text in quote
(defun select-text-in-quote ()
  "Select text between the nearest left and right delimiters
Delimiters here includes the following chars: \"<>(){}[]“”‘’‹›«»「」『』【】〖〗《》〈〉〔〕（）"
  (interactive)
  (let (
        (-skip-chars "^\"<>(){}[]“”‘’‹›«»「」『』【】〖〗《》〈〉〔〕（）")
        -pos
        )
    (skip-chars-backward -skip-chars)
    (setq -pos (point))
    (skip-chars-forward -skip-chars)
    (set-mark -pos)))

(provide 'custom-autoload)




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

(defun open-custom-auto-file ()
  "Open custom autload file"
  (interactive)
  (find-file "~/.emacs.d/custom-lisp/custom-autoload.el"))

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
            (insert (get-delimiter-other-part-char str)))
        (progn
          (goto-char region-beginning)
          (insert str)
          (goto-char (+ region-end 1))
          (insert (get-delimiter-other-part-char str))
          )))))

(defun get-delimiter-other-part-char (str)
  "Return the other part of str if str is ( or {"
  (let ((delimiter-list '(("(" . ")") ("{" . "}"))))
    (if (assoc str delimiter-list)
        (cdr (assoc str delimiter-list))
      str)))

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
;;; Backward or forward bracket
(defvar wp-brackets nil "string of left/right brackets pairs")

(setq wp-brackets "()[]{}<>（）［］｛｝⦅⦆〚〛⦃⦄“”‘’‹›«»「」〈〉《》【】〔〕⦗⦘『』〖〗〘〙｢｣⟦⟧⟨⟩⟪⟫⟮⟯⟬⟭⌈⌉⌊⌋⦇⦈⦉⦊❛❜❝❞❨❩❪❫❴❵❬❭❮❯❰❱❲❳〈〉⦑⦒⧼⧽﹙﹚﹛﹜﹝﹞⁽⁾₍₎⦋⦌⦍⦎⦏⦐⁅⁆⸢⸣⸤⸥⟅⟆⦓⦔⦕⦖⸦⸧⸨⸩｟｠⧘⧙⧚⧛⸜⸝⸌⸍⸂⸃⸄⸅⸉⸊᚛᚜༺༻༼༽⏜⏝⎴⎵⏞⏟⏠⏡﹁﹂﹃﹄︹︺︻︼︗︘︿﹀︽︾﹇﹈︷︸")

(defvar wp-left-brackets nil "list of left brackets chars")

(progn
  (setq wp-left-brackets '())
  (dotimes (x (length wp-brackets))
    (when (= (% x 2) 0)
      (push (char-to-string (elt wp-brackets x))
            wp-left-brackets)))
  (setq wp-left-brackets (reverse wp-left-brackets)))

(defvar wp-right-brackets nil "list of left brackets chars")

(progn
  (setq wp-right-brackets '())
  (dotimes (x (length wp-brackets))
    (when (= (% x 2) 1)
      (push (char-to-string (elt wp-brackets x))
            wp-right-brackets)))
  (setq wp-right-brackets (reverse wp-right-brackets)))

(defun backward-left-bracket ()
  "Move cursor to the previous occurrence of left brackets"
  (interactive)
  (search-backward-regexp (regexp-opt wp-left-brackets) nil t))

(defun forward-right-bracket ()
  "Move cursor to the next occurrence of right brackets"
  (interactive)
  (search-forward-regexp (regexp-opt wp-right-brackets) nil t))

(defun goto-matching-bracket ()
  "Move cursor to the matching bracket."
  (interactive)
  (if (nth 3 (syntax-ppss))
      (backward-up-list 1 'ESCAPE-STRING 'NO-SYNTAX-CROSSING)
    (cond
     ((eq (char-after) ?\") (forward-sexp))
     ((eq (char-before) ?\") (backward-sexp))
     ((looking-at (regexp-opt wp-left-brackets)) (forward-sexp))
     ((looking-back (regexp-opt wp-right-brackets)) (backward-sexp))
     (t (backward-up-list 1 'ESCAPE-STRING 'NO-SYNTAX-CROSSING)))))

(defun sudo-find-file (file)
  "Opens FILE with root privileges."
  (interactive "FFind file: ")
  (set-buffer
   (find-file (concat "/sudo::" (expand-file-name file)))))

(defun sudo-remote-find-file (file)
  "Opens remote FILE with root privileges."
  (interactive "FFind file: ")
  (setq begin (replace-regexp-in-string  "scp" "ssh" (car (split-string file ":/"))))
  (setq end (car (cdr (split-string file "@"))))
  (set-buffer
   (find-file (format "%s" (concat begin "|sudo:root@" end)))))

(defun sudo-file ()
  "Open current file with sudo"
  (interactive)
  (let ((file (buffer-file-name)))
    (if file
        (if (and (numberp (string-match (regexp-quote "/ssh") file)) (= 0 (string-match (regexp-quote "/ssh") file)))
            (sudo-remote-find-file file)
          (sudo-find-file file))
      (message "current buffer is not a file"))))

(defun xcopy ()
  "Copy region text to system clipboard"
  (interactive)
  (call-process-region (point) (mark) "xclip" nil nil nil "-selection" "clipboard")
  (setq deactivate-mark t))

(defun xcut ()
  "Cut region text to system clipboard"
  (interactive)
  (pbcopy)
  (delete-region (region-beginning) (region-end)))

(defun xpaste ()
  "Paste clipboard text to emacs"
  (interactive)
  (call-process-region (point) (if mark-active (mark) (point)) "xclip" t t nil "-o" "-selection" "clipboard"))

(defun window-half-height ()
  (max 1 (/ (1- (window-height (selected-window))) 2)))

(defun scroll-up-half ()
  (interactive)
  (scroll-up (window-half-height)))

(defun scroll-down-half ()
  (interactive)
  (scroll-down (window-half-height)))

(defun copy-file-path (&optional *dir-path-only-p)
  "Copy the current buffer's file path or dired path to `kill-ring'.
Result is full path.
If `universal-argument' is called first, copy only the dir path.
URL `http://ergoemacs.org/emacs/emacs_copy_file_path.html'
Version 2017-01-27"
  (interactive "P")
  (let ((-fpath
         (if (equal major-mode 'dired-mode)
             (expand-file-name default-directory)
           (if (buffer-file-name)
               (buffer-file-name)
             (user-error "Current buffer is not associated with a file.")))))
    (kill-new
     (if *dir-path-only-p
         (progn
           (message "Directory path copied: 「%s」" (file-name-directory -fpath))
           (file-name-directory -fpath))
       (progn
         (message "File path copied: 「%s」" -fpath)
         -fpath )))))

(defun pretty-xml (start end)
  "Pretty xml"
  (interactive "r")
  (shell-command-on-region (point-min) (point-max) "xmllint --format -" (current-buffer) t))

(provide 'custom-autoload)

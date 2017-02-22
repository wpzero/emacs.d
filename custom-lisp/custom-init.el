;; Set the comment, comment line, a very cool feature
(global-set-key (kbd "C-x \/") 'comment-line) ;comment-line
(global-set-key (kbd "M-;") 'comment-dwim)  ; comment-dwin
;;; Set default google translate source and target language
(setq google-translate-default-source-language "en")
(setq google-translate-default-target-language "zh-CN")

;; The command is used to visit the symbol linked file instead of the symbol file
(defun visit-target-instead ()
  "Replace this buffer with a buffer visiting the link target"
  (interactive)
  (if buffer-file-name
      (let ((target (file-symlink-p buffer-file-name)))
        (if target
            (find-alternate-file target)
          (error "Not visiting a symlink")))
    (error "Not visiting a file")))

;; The command is used to replace a symbol with the content of the linked file
(defun clobber-symlink ()
  "Replace symlink with a copy of the file"
  (interactive)
  (if buffer-file-name
      (let ((target (file-symlink-p buffer-file-name)))
        (if target
            (if (yes-or-no-p (format "Replace %s with %s?"
                                     buffer-file-name
                                     target))
                (progn
                  (delete-file buffer-file-name)
                  (write-file buffer-file-name)))
          (error "Not visiting a symlink")))
    (error "Not visiting a file")))

;; Delete enhencement
(defun delete-backward-char-or-bracket ()
  "Delete backward 1 character, but if it's a bracket ()[] etc, delete bracket and the inner text. if it's bracket, put the deleted text on `kill-ring'"
  (interactive)
  (let (
        (-right-brackets (regexp-opt '(")" "]" "}" ">" "〕" "】" "〗" "〉" "》" "」" "』" "”" "’" "›" "»")))
        (-left-brackets (regexp-opt '("(" "{" "[" "<" "〔" "【" "〖" "〈" "《" "「" "『" "“" "‘" "‹" "«")))
        )
    (cond
     ((looking-back -right-brackets 1)
      (progn
        (backward-sexp)
        (mark-sexp)
        (kill-region (region-beginning) (region-end))))
     ((looking-back -left-brackets 1)
      (progn
        (backward-char)
        (mark-sexp)
        (kill-region (region-beginning) (region-end))))
     (t (delete-backward-char 1)))))

;;; paste or paste previouse
;; (defun past-or-past-previouse ()
;;   "Paste. When called repeatedly, paste previous. This command calls `yank', and if repeated, call `yank-pop'."
;;   (interactive)
;;   (progn
;;     (when (and delete-selection-mode (region-active-p))
;;       (delete-region (region-beginning) (region-end)))
;;     (if (or (eq real-last-command)))))

;; autoload usage
;; 1. first param is the function name
;; 2. second param is the file name
;; 3. a docstring
;; 4. boolean if a interactive function
(autoload 'show-file-name "custom-autoload"
  "Show file full path to echo"
  t)

(autoload 'server-shutdown "custom-autoload"
  "Save buffers, Quit, and Shutdown (kill) server"
  t)

(autoload 'open-init-file "custom-autoload"
  "Open init file"
  t)

(autoload 'open-custom-init-file "custom-autoload"
  "Open custom init file"
  t)

(autoload 'open-custom-auto-file "custom-autoload"
  "Open custom autoload file"
  t)

(autoload 'wrap-char-region "custom-autoload"
  "Wrap insert a char"
  t)

(autoload 'select-current-word "custom-autoload"
  "Select current word"
  t)

(autoload 'select-current-line "custom-autoload"
  "Select current line"
  t)

(autoload 'select-next-line "custom-autoload"
  "Select next line"
  t)

(autoload 'select-text-in-quote "custom-autoload"
  "Select text in quote"
  t)

(autoload 'forward-right-bracket "custom-autoload"
  "Forward to previous occurrence of the left brackets"
  t)

(autoload 'backward-left-bracket "custom-autoload"
  "Backward to next occurrence of the right brackets"
  t)

(autoload 'goto-matching-bracket "custom-autoload"
  "Move cursor to the matching bracket"
  t)

(autoload 'sudo-find-file "custom-autoload"
  "Opens file with root privileges."
  t)

(autoload 'sudo-remote-find-file "custom-autoload"
  "Opens remote file with root privileges."
  t)

(autoload 'sudo-file "custom-autoload"
  "Open current file with sudo"
  t)

(autoload 'pbcopy "custom-autoload"
  "Copy region text to system clipboard"
  t)

(autoload 'pbcut "custom-autoload"
  "Cut region text to system clipboard"
  t)

(autoload 'pbpaste "custom-autoload"
  "Past clipboard"
  t)

;;; Some custom settings
(setq make-backup-files nil)

;;; A custom minor mode
;; (require 'wp-refill-mode-init)

;;; elfeed rss feed read for emacs
(add-to-list 'load-path (expand-file-name "custom-lisp/elfeed-package" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "custom-lisp/elfeed-org" user-emacs-directory))
(load "elfeed.el")
(load "elfeed-org.el")
(require 'elfeed-org)
(elfeed-org)
(setq rmh-elfeed-org-files (list (expand-file-name "custom-lisp/elfeed-rss.org" user-emacs-directory)))

;;; neotree settings
(add-to-list 'load-path (expand-file-name "custom-lisp/emacs-neotree" user-emacs-directory))
(require 'neotree)

;;; rvm settings
(require 'rvm)
;; Normallly this apears at the very end of the file, so that the feature isn't "provided" unless everything preceding it worked correctly
(provide 'custom-init)

(defvar wp-refill-mode nil
  "Mode variable for refill minor mode.")

(make-variable-buffer-local 'wp-refill-mode)

;;; @params
;;; 1) the positions of beginning of the range of changed text
;;; 2) the positions of end of the range of changed text (the current point eql (point))
;;; 3) the length of deleted

;; (For an insertion, the pre-change length is zero;
;; for a deletion, that length is the number of chars deleted
;; and the post-change beginning and end are at the same place.

(defun wp-refill (start end len)
  "After a text change, refill the current paragraph *"
  (message (format "The start is %d, the end is %d, the len is %d" start end len)))

;;; wp write
;; (defun wp-refill (start end len)
;;   "After a text change, refill the current paragraph *"
;;   (message (format "The start is %d, the end is %d, the len is %d" start end len))
;;   (if (or (and (zerop len)
;;                (eq (char-syntax (preceding-char))
;;                    ?\ ))
;;           (first-of-line-p end))
;;       nil
;;     (save-excursion
;;       (fill-paragraph))))

(defun first-of-line-p (pos)
  (save-excursion
    (beginning-of-line)
    (back-to-indentation)
    (eq pos (point))))

(defun before-2nd-word-p (pos)
  "Does POS lie before the second word on the line?"
  (save-excursion
    (goto-char pos)
    (beginning-of-line)
    (skip-syntax-forward (concat "^ "
                                 (char-to-string
                                  (char-syntax ?\n))))
    (skip-syntax-forward " ")
    (< pos (point))))

(defun short-line-p (pos)
  "Does line containing POS stay within `fill-column'?"
  (save-excursion
    (goto-char pos)
    (end-of-line)
    (<= (current-column) fill-column)))

(defun same-line-p (start end)
  "Are START and END on the same line?"
  (save-excursion
    (goto-char start)
    (end-of-line)
    (<= end (point))))

;;; the book write
;; (defun wp-refill (start end len)
;;   "After a text change, refill the current paragraph."
;;   (let ((left (if (or (zerop len)
;;                       (not (before-2nd-word-p start)))
;;                   start
;;                 (save-excursion
;;                   (max (progn
;;                          (goto-char start)
;;                          (beginning-of-line 0)
;;                          (point))
;;                        (progn
;;                          (goto-char start)
;;                          (backward-paragraph 1)
;;                          (point)))))))
;;     (if (or (and (zerop len)
;;                  (same-line-p start end)
;;                  (short-line-p end))
;;             (and (eq (char-syntax (preceding-char))
;;                      ?\ )
;;                  (looking-at "\\s *$")))
;;         nil
;;       (save-excursion
;;         (fill-region left end nil nil t)))))

(defun wp-refill-mode (&optional arg)
  "Refill minor mode"
  (interactive "P")
  ;; NOTE it's a common idiom in minor mode definition
  (setq wp-refill-mode
        (if (null arg)
            (not wp-refill-mode)
          (> (prefix-numeric-value arg) 0)))
  (if wp-refill-mode
      (add-hook 'after-change-functions 'wp-refill nil t)
    (remove-hook 'after-change-functions 'wp-refill t)))

;;; Add a entry to minor-mode-alist
(if (not (assq 'wp-refill-mode minor-mode-alist))
    (setq minor-mode-alist
          (cons '(wp-refill-mode "Refill") minor-mode-alist)))

(provide 'wp-refill-mode-init)

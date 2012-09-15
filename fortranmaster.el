(defun find-and-decrement-integers (start end)
  "find any integers in the region and decrement them by 1."
  (defun decrement-string (integer-string)
    (number-to-string (- (parse-integer integer-string) 1)))
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (goto-char start)
    (while (re-search-forward "[0-9]+" nil t)
           (replace-match (decrement-string (match-string 0)) nil t))))

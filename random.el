(defun add-column-mode-macro (start end)
  "Convert some pair 1,2 to columnOrder(1,2,entriesPerRow)"
  (defun decrement-string (integer-string)
    (number-to-string (- (parse-integer integer-string) 1)))
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (goto-char start)
      (replace-regexp "\\([0-9]+\\),\\([0-9]+\\)" "f(\\1, \\2, 3)")))

(defun rational-to-decimal (start end)
  "Convert ratios of integers to their decimal equivalents."
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (goto-char 1)
    (let ((case-fold-search nil))
      (while (search-forward-regexp "\\([0-9]+\\)/\\([0-9]+\\)" nil t)
        (replace-match (number-to-string (/ (float (string-to-int (match-string 1)))
                                            (string-to-int (match-string 2))))
                       t nil)))))
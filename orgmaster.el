(defun org-surround-latex (start end)
  "surround the current region with #+BEGIN_SRC and #+END_SRC lines."
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (goto-char (point-min))
    (insert "#+BEGIN_SRC LaTeX\n")
    (goto-char (point-max))
    (insert "\n#+END_SRC LaTeX")))
;; functional.el
;; tools for writing functional emacs lisp.

;; Given two points in a buffer, extract the string and apply some function to it.
;; Replace the original string with the new one.
(defun functional-apply-function-to-buffer-range (start end func)
  "Apply a function to some range in a buffer."
    (let ((new-content (funcall func (buffer-substring-no-properties start end))))
      (progn
        (delete-region start end)
        (goto-char start)
        (insert new-content)
        nil)))

;; input  - symbol name, some 'pure' function that maps strings to strings
;; output - stateful function that .
(defmacro functional-wrap-pure-as-interactive (out-name in-name)
  "Wrap a pure function which maps strings to strings with some
interactive function."
  `(defun ,out-name (start end)
  (interactive "r")
  (apply-function-to-buffer-range start end #',in-name)))

(provide 'functional)
;; functional.el ends here

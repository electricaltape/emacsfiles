;; AucTeX initialization settings
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(add-to-list 'auto-mode-alist '("/*.\.tex$" . LaTeX-mode))
(setq-default TeX-master nil)
(setq TeX-parse-self t)
(setq TeX-auto-save t)

;; turn off the stupid resizing 'features'
(setq font-latex-fontify-script nil)
(setq font-latex-fontify-sectioning 'color)
(font-latex-update-sectioning-faces)
(font-lock-fontify-buffer)

;; turn off the very stupid resizing for beamer.
(custom-set-faces
 '(font-latex-slide-title-face ((t (:inherit font-lock-type-face)))))

; fix indentation.
(setq LaTeX-indent-level 4)
(setq TeX-newline-function 'newline-and-indent)
; add nice formatting and outline mode
(auto-fill-mode 1)
(outline-minor-mode)
; -------------------------------------------------------------------------------
; Custom elisp
; -------------------------------------------------------------------------------
(setq pair-list
  (list '(("(" . "\\left(")     . (")" . "\\right)"))
        '(("[" . "\\left[")     . ("]" . "\\right]"))
        '(("\\{" . "\\left\\{") . ("\\}" . "\\right\\}"))))

(defun toggle-left-right-ify-region (start end)
  "Toggle all the '\\left('s to '('s, or ')'s to '\\left)'s."
  ; see if we can find a \\left in the region.
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (setq found-left nil)
    (goto-char start)
    (while (and (< (point) end)
                (search-forward "\\left" end t))
      (setq found-left t)))
  (if found-left (un-left-right-ify-region start end)
                 (left-right-ify-region start end)))

(defmacro search-and-replace (pair)
  (list 'progn
        (list 'goto-char 'start)
        (list 'while (list 'search-forward (list 'car pair) nil t)
                     (list 'replace-match (list 'cdr pair) nil t))))

(defun left-right-ify-region (start end)
  "replace ( and ) with \\left( and \\right) respectively."
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (mapcar (lambda (pair)
              ; replace the first item in the pair.
              (search-and-replace (car pair))
              (search-and-replace (cdr pair)))
            pair-list)))

; (some text) [some other text]

(defun un-left-right-ify-region (start end)
  "replace \\left( and \\right) with ( and ) respectively."
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (mapcar (lambda (pair)
              ; reverse the order of the cons cells.
              (search-and-replace (cons (cdar pair) (caar pair)))
              (search-and-replace (cons (cddr pair) (cadr pair))))
            pair-list)))
;; this file is NOT part of GNU emacs.
(defvar vtex-mode-hook nil)

(defconst vtex-version 0.1
  "alpha copy of vtex.")

(defun vtex-comment-dwim (arg)
  "Comment blocks via newcomment."
  (interactive "*P")
  (require 'newcomment)
  (let ((comment-start "%") (comment-end ""))
    (comment-dwim arg)))

(defconst vtex-font-lock-keywords-1
  ; just so that I can check what colors do what.
  (list
   ; match \\
   '("\\(\\\\\\\\\\)" 1 font-lock-negation-char-face)
   '("\\(aaaaa\\)" 1 font-lock-warning-face)
   '("\\(bbbbb\\)" 1 font-lock-function-name-face)
   '("\\(ccccc\\)" 1 font-lock-variable-name-face)
   '("\\(ddddd\\)" 1 font-lock-keyword-face)
   '("\\(eeeee\\)" 1 font-lock-comment-face)
   '("\\(fffff\\)" 1 font-lock-comment-delimiter-face)
   '("\\(ggggg\\)" 1 font-lock-type-face)
   '("\\(hhhhh\\)" 1 font-lock-constant-face)
   '("\\(iiiii\\)" 1 font-lock-builtin-face)
   '("\\(jjjjj\\)" 1 font-lock-preprocessor-face)
   '("\\(kkkkk\\)" 1 font-lock-string-face)
   '("\\(lllll\\)" 1 font-lock-doc-face)
   '("\\(mmmmm\\)" 1 font-lock-constant-face)
   '("\\(nnnnn\\)" 1 font-lock-negation-char-face)
   '("\\(ooooo\\)" 1 font-lock-reference-face))
   "Minimal highlighting expressions for VTEX mode.")

(defconst vtex-font-lock-sectioning
  ; section, subsection, subsubsection
  (list '("\\(?:\\\\s\\(?:\\(?:ubs\\(?:ubs\\)?\\)?ection\\)\\)"
          . font-lock-keyword-face)
        '("section{\\(.*\\)}" 1 font-lock-builtin-face))
  "Additional Keywords to highlight in VTEX mode.")

(defconst vtex-font-lock-math-delimiters
  (list '("\\\\[]()[]" . font-lock-string-face))
  "Math delimiters.")

(defconst vtex-font-lock-catch-backslash
  (list '("\\(\\\\\\w+\\)" . font-lock-builtin-face))
  "catch additional backslashed terms.")

(defvar vtex-font-lock-keywords
  (append vtex-font-lock-math-delimiters
          vtex-font-lock-sectioning
          vtex-font-lock-keywords-1
          vtex-font-lock-catch-backslash)
  "Default highlighting expressions for VTEX mode.")

(defvar vtex-syntax-table
  (let ((vtex-mode-syntax-table (make-syntax-table)))
    (modify-syntax-entry ?_ "w" vtex-mode-syntax-table)
    (modify-syntax-entry ?% "< b" vtex-mode-syntax-table)
    (modify-syntax-entry ?\n "> b" vtex-mode-syntax-table)
    vtex-mode-syntax-table)
  "Syntax table for VTEX mode.")

(defvar vtex-mode-map
  (let ((vtm (make-keymap)))
    (define-key vtm "\C-j" 'newline-and-indent)
    (define-key vtm [remap comment-dwim] 'vtex-comment-dwim)
    (define-key vtm [remap comment-region] 'vtex-comment-dwim)
    vtm)
  "Keymap for VTEX major mode")

(defun vtex-matching-begin-indent ()
  "Assuming that the cursor is currently at an 'end' statement, find the
   indentation level of the matching begin statement."
  (interactive)
  (save-excursion
  (defvar stack-count 1)
  (setq stack-count 1)
    (while (and (not (bobp)) (not (eq stack-count 0)))
      (forward-line -1)
      (beginning-of-line)
      (if (search-forward "\\begin" (line-end-position) t)
          (setq stack-count (- stack-count 1))
      (if (search-forward "\\end" (line-end-position) t)
          (setq stack-count (+ 1 stack-count)))))
    (current-indentation)))

(defun vtex-fix-end-block ()
  (save-excursion
    (beginning-of-line)
    (if (looking-at "^ *\\\\end")
      (progn (message "found end block")
             (indent-line-to (vtex-matching-begin-indent))))))

(defun vtex-indent-line ()
  (interactive)
  (defvar vtex-next-indent 0)
  (setq vtex-max-look-count 2)
  (setq vtex-look-count 1)
  (save-excursion
    (progn
      (forward-line -1)
      (beginning-of-line)
      (cond
       ((bobp) (indent-line-to 0))
       ((looking-at "^ *\\\\section") (progn
                                        (indent-line-to 0)
                                        (setq vtex-next-indent 4)))
       ((looking-at "^ *\\\\subsection") (progn
                                           (indent-line-to 4)
                                           (setq vtex-next-indent 8)))
       ((looking-at "^ *\\\\subsubsection") (progn
                                              (indent-line-to 8)
                                              (setq vtex-next-indent 12)))
       ((looking-at "^.*\\\\begin") (progn
                                      (setq vtex-next-indent
                                            (+ 4 (current-indentation)))))
       ((looking-at "^.*\\\\end") (progn
                                    (indent-line-to
                                     (vtex-matching-begin-indent))
                                    (setq vtex-next-indent
                                          (current-indentation))))
       ((looking-at "^ *$") (progn (while (and (eq (current-indentation) 0)
                                               (< vtex-look-count
                                                  vtex-max-look-count)
                                               (not (bobp)))
                                     (forward-line -1)
                                     (setq vtex-look-count
                                           (1+ vtex-look-count)))
                                   (setq vtex-next-indent
                                         (current-indentation))))
       (t (setq vtex-next-indent (current-indentation))))))
  (indent-line-to vtex-next-indent)
  ; end blocks are badly behaved. Check it again.
  (vtex-fix-end-block))

(defun vtex-indent-region (start end)
  "Based on my preferences for how indentation works (i.e. fix
   section locations while indenting), override the usual
   indent-region command."
  (interactive "r")
  (save-excursion
    (save-restriction
    (narrow-to-region start end)
      (goto-char 0)
      (while (not (eobp))
        (vtex-indent-line)
        (forward-line 1)
        (end-of-line)))))

(define-derived-mode vtex-mode prog-mode
  "Major mode for editing LaTeX files."
  :syntax-table vtex-syntax-table
  (progn
    (setq font-lock-defaults vtex-font-lock-keywords)
    (setq comment-start "%")
    (setq comment-end "")
    (use-local-map vtex-mode-map)
    (set (make-local-variable 'font-lock-defaults) '(vtex-font-lock-keywords))
    (set (make-local-variable 'indent-line-function) 'vtex-indent-line)
    (set (make-local-variable 'indent-region) 'vtex-indent-region)
    (setq major-mode 'vtex-mode)
    (setq mode-name "VTEX")
    (add-hook 'before-save-hook (font-lock-fontify-buffer))
    (add-hook 'before-save-hook (lambda ()
                                  (setq font-lock-mode-major-mode nil)
                                  (font-lock-fontify-buffer)))
    (run-hooks 'vtex-mode-hook)))

(provide 'vtex-mode)
;;; vtex-mode.el ends here

;; this file is NOT a part of GNU emacs.
; TODOs
;
; 1. The indentation for subsections is not quite right; new lines under a
;    subsection are not indented enough when the line wraps.
;
; 2. If the previous line starts with a '&=', align to three spaces
; over. Perhaps align the next &= if possible?
;
; 3. Add in appropriate functions to run outline-minor-mode correctly.
;
; 4. Have a default highlighting color for math mode. Try something like the
; emacs regexp (as a string)
; "\\\\(\\([^\\][^)]\\)*\\\\)"
; to get the match (that is, anything but an ending delimeter between "\(" and
; "\)")
;
; 5. Get M-RET to insert the 'right' thing (item, section, subsection) based on
;    context.
;
; 6. get quotes working correctly (we wish to pair `` and ") (use header file)
;
; 7. get templates sorted out (currently don't do anything)
;
; 8. There is something wrong with indenting a line below a math block delimited
;    by \[ and \].
;
; 9. When running M-q, also break paragraphs at \]s.
;
; 10. for highlighting keywords (e.g. \foo) do not include underscores (so
;     \foo_bar should have "\foo" in white and "_bar" in blue).
;
; 11. When running M-q, if we are on a comment line then don't merge with the
;     previous paragraph.
;
; 12. There is still something wrong with the before-save-hook (it
;     overwrites the global value)
;
; 14. This may be a problem with evil, but when a line wraps the indentation is
;     incorrect.
;
; 15. The 'white' syntax highlighting inside a \section{} block is turned off if
;     I use special characters. There needs to be some 'layering' of
;     highlighting here (highlight the section, then do math last)
(defvar vtex-mode-hook nil)

(defconst vtex-version 0.1
  "alpha copy of vtex.")

(defun vtex-comment-dwim (arg)
  "Comment blocks via newcomment."
  (interactive "*P")
  (require 'newcomment)
  (let ((comment-start "%") (comment-end ""))
    (comment-dwim arg)))

;; syntax highlighting
(defconst vtex-font-lock-keywords-1
  ; just so that I can check what colors do what.
  (list
   ; match                                                                    \\
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
  (list `(,(concat
            (regexp-opt
  ; append "\\>" so that we match "\section" but not "\sectionX"
             '("\\section" "\\subsection" "\\subsubsection" "\\begin" "\\end"))
            "\\>")
          . font-lock-keyword-face)
        '("section{\\(.*\\)}" 1 font-lock-builtin-face)
        '("begin{\\(.*\\)}" 1 font-lock-builtin-face)
        '("end{\\(.*\\)}" 1 font-lock-builtin-face))
  "Additional keywords to highlight in VTEX mode.")

(defconst vtex-font-lock-math-delimiters
  (list '("\\\\[]()[]" . font-lock-string-face))
  "Math delimiters.")

(defconst vtex-font-lock-catch-backslash
  (list '("\\(\\\\\\w+\\)" . font-lock-builtin-face))
  "catch additional backslashed terms.")

(defconst vtex-font-lock-catch-backslash-special
  (list '("\\(\\\\[%&$#]\\|\\(&=\\)\\)" . font-lock-negation-char-face))
  "catch special backslashed terms.")

(defvar vtex-font-lock-keywords
  (append vtex-font-lock-math-delimiters
          vtex-font-lock-sectioning
          vtex-font-lock-keywords-1
          vtex-font-lock-catch-backslash
          vtex-font-lock-catch-backslash-special)
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

;; some utility regexps
(defconst vtex--new-LaTeX-block
  ;; TODO find some way to permit any non-"%" character.
  (regexp-opt '("^ *\\section" "^ *\\subsubsection")))

;; indentation
(defun vtex-matching-begin-indent ()
  "Assuming that the cursor is currently at an 'end' statement, find the
   indentation level of the matching begin statement."
  (interactive)
  (save-excursion
    (setq stack-count 1)
    (while (and (not (bobp)) (not (eq stack-count 0)))
      (forward-line -1)
      (beginning-of-line)
      (if (search-forward "\\begin" (line-end-position) t)
          (setq stack-count (- stack-count 1))
        (if (search-forward "\\end" (line-end-position) t)
            (setq stack-count (+ stack-count 1)))))
    (current-indentation)))

(defun vtex-fix-end-block ()
  (save-excursion
    (beginning-of-line)
    (if (looking-at "^ *\\\\end")
      (progn (message "found end block")
             (indent-line-to (vtex-matching-begin-indent))))))

;; TODO implement this.
(defun vtex--in-math-align-block ()
  "Determine if we are currently in some sort of math align environment."
  ; Assume that alignment sections cannot be nested. A new section or a begin
  ; block will terminate an align block.
  nil
  )

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
       ((looking-at "^ *\\\\section")
        (progn
          (indent-line-to 0)
          (setq vtex-next-indent 4)))
       ((looking-at "^ *\\\\subsection")
        (progn
          (indent-line-to 4)
          (setq vtex-next-indent 8)))
       ((looking-at "^ *\\\\subsubsection")
        (progn
          (indent-line-to 8)
          (setq vtex-next-indent 12)))
       ((and (looking-at "^.*\\\\begin")
             (not (looking-at "^.*\\\\begin{document}")))
        (progn
          (setq vtex-next-indent
                (+ 4 (current-indentation)))))
       ((looking-at "^.*\\\\end")
        (progn
          (indent-line-to
           (vtex-matching-begin-indent))
          (setq vtex-next-indent
                (current-indentation))))
       ; Add code for checking to see if inside a math alignment block here.  If
       ; the previous line ended with "//", then indent to the "&=". Otherwise
       ; indent 3 more than last line (to align with previous "&=").
;;       ((vtex--in-math-align-block)
;;        (progn ))
       ((looking-at "^ *$")
        (progn
          (while (and (eq (current-indentation) 0)
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

;; alignment of "\\"s
(defun vtex--align-continuation-right (line)
  "Align the \\\\ on the end of a string."
  (let ((index (string-match "\\\\\\\\$"
                             (replace-regexp-in-string " *\\\\\\\\ *$"
                                                       "\\\\\\\\" line))))
    (cond
     ((eq index nil) line)
     (t (concat (substring line 0 index)
                ; add appropriate spaces (or none if line too long)
                (make-string (max 0 (- fill-column index 2)) ? )
                "\\\\")))))

(defun vtex-align-continuation-right-buffer ()
  "Align the terminating \\\\s to be at the 78th and 79th columns."
  (save-excursion
    (goto-char (point-min))
    (while (search-forward-regexp "\\\\\\\\\\s-*$" (point-max) t)
      ; don't edit the line if it is already the correct length.
      (if (= (- (line-end-position) (line-beginning-position)) 80)
          nil
        (let ((new-content
             (vtex--align-continuation-right
                      (buffer-substring-no-properties (line-beginning-position)
                                                      (line-end-position)))))
        (progn
          (delete-region (line-beginning-position) (line-end-position))
          (goto-char (line-beginning-position))
          (insert new-content)
          nil))))))

;; paragraph filling
(defconst vtex-block-terminator-regexp
  (concat "^ *$\\|" "[^\\]%\\|" (regexp-opt
           '("\\section" "\\subsection" "\\subsubsection" "\\begin" "\\end")))
  "regexp to match at the end of a LaTeX block.")

(defun vtex--find-paragraph-border (direction)
  "Find the first or last character of a LaTeX block by
`vtex-block-terminator-regexp'. If the current line matches the
paragraph terminator, then return nil."
  (save-excursion
    (progn
      (goto-char (+ (line-beginning-position) (current-indentation)))
      (cond
       ((looking-at vtex-block-terminator-regexp) nil)
       ((eq direction 'up)
        (progn
          (search-backward-regexp vtex-block-terminator-regexp)
          (forward-line 1)
          (line-beginning-position)))
       ((eq direction 'down)
        (progn (search-forward-regexp vtex-block-terminator-regexp)
               (forward-line -1)
               (line-end-position)))
       (t (error (concat "unrecognized direction;"
                         "should be `up' or `down'")))))))

(defun vtex-fill-paragraph (arg)
  "Call fill-region based on a narrowed range."
  (interactive)
  ;; TODO just call fill-paragraph if inside a comment. Make sure that this is
  ;; not a recursive call.
  (let ((first-char (vtex--find-paragraph-border 'up))
        (last-char (vtex--find-paragraph-border 'down)))
    (if (or (eq first-char nil) (eq last-char nil))
        (message "At recognized keyword; no need to reformat")
      (fill-region first-char last-char))))

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
    ; should this be set as local?
    (set (make-local-variable 'fill-paragraph-function) 'vtex-fill-paragraph)
    (setq major-mode 'vtex-mode)
    (setq mode-name "VTEX")
    ;; TODO get rid of this?
    (add-hook 'before-save-hook (lambda ()
                                  (progn (font-lock-fontify-buffer))) nil t)
    (add-hook 'before-save-hook (lambda ()
                                  (vtex-align-continuation-right-buffer)))))

(provide 'vtex-mode)
;;; vtex-mode.el ends here

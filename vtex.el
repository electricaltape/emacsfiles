(defvar vtex-mode-hook nil)

(defvar vtex-mode-map
  (let ((vtex-mode-map (make-keymap)))
    (define-key vtex-mode-map "\C-j" 'newline-and-indent)
    vtex-mode-map)
  "Keymap for VTEX major mode")

(defconst vtex-font-lock-keywords-1
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
   '("\\(mmmmm\\)" 1 font-lock-negation-char-face)
   ; match comments (start with %)
   '("[^\\]\\(%.*$\\)" 1 font-lock-comment-face))
   "Minimal highlighting expressions for VTEX mode.")

(defconst vtex-font-lock-sectioning
  ; section, subsection, subsubsection
  (list '("\\(?:\\\\s\\(?:\\(?:ubs\\(?:ubs\\)?\\)?ection\\)\\)"
          . font-lock-keyword-face)
        '("section{\\(.*\\)}" 1 font-lock-builtin-face))
  "Additional Keywords to highlight in VTEX mode.")

; These are some possible built-in values for VTEX attributes
; "ROLE" "ORGANISATIONAL_UNIT" "STRING" "REFERENCE" "AND"
; "XOR" "WORKFLOW" "SYNCHR" "NO" "APPLICATIONS" "BOOLEAN"
; "INTEGER" "HUMAN" "UNDER_REVISION" "OR"
(defconst vtex-font-lock-keywords-2
  (list
   '("\\<\\(A\\(ND\\|PPLICATIONS\\)\\|BOOLEAN\\|HUMAN\\|INTEGER\\|NO\\|OR\\(GANISATIONAL_UNIT\\)?\\|R\\(EFERENCE\\|OLE\\)\\|S\\(TRING\\|YNCHR\\)\\|UNDER_REVISION\\|WORKFLOW\\|XOR\\)\\>" . font-lock-constant-face))
  "extra highlighting in VTEX mode.")

(defconst vtex-font-lock-catch-backslash
  (list '("\\(\\\\\\w+\\)" . font-lock-builtin-face))
  "catch additional backslashed terms.")

; these have to be done in order. We want to have:
; 1. the \\ command (that is, carriage returns)
; 2. known commands
; 3. unknown commands
(defvar vtex-font-lock-keywords
  (append vtex-font-lock-keywords-1
          vtex-font-lock-sectioning
          vtex-font-lock-keywords-2
          vtex-font-lock-catch-backslash)
  "Default highlighting expressions for VTEX mode.")

;; (defun vtex-indent-line ()
;;   "Indent current line as VTEX code."
;;   (interactive)
;;   (beginning-of-line)
;;   (if (bobp)
;; 	  (indent-line-to 0)		   ; First line is always non-indented
;; 	(let ((not-indented t) cur-indent)
;; 	  (if (looking-at "^[ \t]*END_") ; If the line we are looking at is the end of a block, then decrease the indentation
;; 		  (progn
;; 			(save-excursion
;; 			  (forward-line -1)
;; 			  (setq cur-indent (- (current-indentation) default-tab-width)))
;; 			(if (< cur-indent 0) ; We can't indent past the left margin
;; 				(setq cur-indent 0)))
;; 		(save-excursion
;; 		  (while not-indented ; Iterate backwards until we find an indentation hint
;; 			(forward-line -1)
;; 			(if (looking-at "^[ \t]*END_") ; This hint indicates that we need to indent at the level of the END_ token
;; 				(progn
;; 				  (setq cur-indent (current-indentation))
;; 				  (setq not-indented nil))
;; 			  (if (looking-at "^[ \t]*\\(PARTICIPANT\\|MODEL\\|APPLICATION\\|WORKFLOW\\|ACTIVITY\\|DATA\\|TOOL_LIST\\|TRANSITION\\)") ; This hint indicates that we need to indent an extra level
;; 				  (progn
;; 					(setq cur-indent (+ (current-indentation) default-tab-width)) ; Do the actual indenting
;; 					(setq not-indented nil))
;; 				(if (bobp)
;; 					(setq not-indented nil)))))))
;; 	  (if cur-indent
;; 		  (indent-line-to cur-indent)
;; 		(indent-line-to 0))))) ; If we didn't see an indentation hint, then allow no indentation

;; (defvar vtex-mode-syntax-table
;;   (let ((vtex-mode-syntax-table (make-syntax-table)))

;;     ; This is added so entity names with underscores can be more easily parsed
;; 	(modify-syntax-entry ?_ "w" vtex-mode-syntax-table)

;; 	; Comment styles are same as C++
;; 	(modify-syntax-entry ?/ ". 124b" vtex-mode-syntax-table)
;; 	(modify-syntax-entry ?* ". 23" vtex-mode-syntax-table)
;; 	(modify-syntax-entry ?\n "> b" vtex-mode-syntax-table)
;; 	vtex-mode-syntax-table)
;;   "Syntax table for vtex-mode")

(defun vtex-mode ()
  (interactive)
  (kill-all-local-variables)
  (use-local-map vtex-mode-map)
  ;; (set-syntax-table vtex-mode-syntax-table)
  ;; Set up font-lock
  (set (make-local-variable 'font-lock-defaults) '(vtex-font-lock-keywords))
  ;; Register our indentation function
  ;; (set (make-local-variable 'indent-line-function) 'vtex-indent-line)
  (setq major-mode 'vtex-mode)
  (setq mode-name "VTEX")
  (run-hooks 'vtex-mode-hook))

(provide 'vtex-mode)

;;; vtex-mode.el ends here
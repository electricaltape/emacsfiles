;; stuff required by aquamacs beta
(let ((root-dir "/Users/drwells/Applications/aquamacs-emacs/lisp/emacs-lisp/"))
  (mapcar (lambda (x) (load-file (concat root-dir x)))
          '("cl-extra.el" "cl-seq.el" "cl-lib.el" "cl-macs.el")))

;; This is the Aquamacs Preferences file.
;; Add Emacs-Lisp code here that should be executed whenever
;; you start Aquamacs Emacs. If errors occur, Aquamacs will stop
;; evaluating this file and print errors in the *Messags* buffer.
;; Use this file in place of ~/.emacs (which is loaded as well.)

; restore the scratch buffer to its former glory
(setq aquamacs-scratch-file nil
      initial-major-mode 'lisp-interaction-mode)

; turn off the odd GPL echo
(setq inhibit-startup-echo-area-message t)

(setq haskell-program-name "/sw/bin/ghci")
(setq-default inferior-lisp-program "/sw/bin/sbcl")

; display settings
(copy-face 'italic 'font-lock-comment-face)             ; italicize comments
(set-face-foreground 'font-lock-comment-face "#ff7f24") ; back to orange.
(setq aquamacs-autoface-mode nil)
(set-face-attribute 'default nil :height 130)
(setq aquamacs-save-options-on-quit nil)

; Yegge's suggestion
(global-set-key "\C-x\C-m" 'execute-extended-command)

;; set up linux style and then switch to indentation of 8.
(setq c-default-style "linux" c-basic-offset 8)

;; c-lineup-arglist-close-under-paren
;; (c-set-offset 'arglist-cont '(c-lineup-arglist-operators 0))
;; (c-set-offset 'arglist-cont-nonempty '(c-lineup-arglist-operators
;;                                         c-lineup-arglist))
;; (c-set-offset 'arglist-close '(c-lineup-arglist-close-under-paren))

; fix behavior of > and < in normal state.
(set (make-local-variable 'evil-shift-width) 8)
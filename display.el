;; display initialization setitings

(setq inhibit-x-resources t)
(require 'linum) ; line numbers
(when (featurep 'linum) (global-linum-mode 1))
(require 'color-theme)
(color-theme-initialize)
(color-theme-comidia)
(set-face-attribute 'default nil
                    :family "Monospace" :height 110)
(setq font-lock)
(set-face-foreground 'font-lock-negation-char-face "red")
; modify the syntax highlighting if in gui mode
(if window-system
    (progn (set-face-background 'default "grey12")
           ; italicize comments
           (copy-face 'italic 'font-lock-comment-face)
           ; back to grey.
           (set-face-foreground 'font-lock-comment-face "orange")
           nil))

; show column number.
(column-number-mode t)
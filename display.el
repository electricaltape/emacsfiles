;; display initialization setitings

(setq inhibit-x-resources t)
(require 'linum) ; line numbers
(when (featurep 'linum) (global-linum-mode 1))
(require 'color-theme)
(color-theme-initialize)
(color-theme-comidia)
(set-face-attribute 'default nil
                    :family "Monospace" :height 110)
; modify the syntax highlighting if in gui mode
(if window-system
    (progn (set-face-background 'default "grey12")
           ; italicize comments
           (copy-face 'italic 'font-lock-comment-face)
           ; back to orange.
           (set-face-foreground 'font-lock-comment-face "#ff7f24")
           nil))

; show column number.
(column-number-mode)
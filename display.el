;; display initialization settings (namely disable the default X11 settings)
(setq inhibit-x-resources t)
(require 'linum) ; line numbers
(when (featurep 'linum) (global-linum-mode 1))

;; Other display stuff
(column-number-mode t)
(require 'highlight-parentheses)
(defun turn-on-highlight-parentheses-mode ()
  "Enable highlight parentheses mode in the current buffer."
  (highlight-parentheses-mode t))

(define-globalized-minor-mode global-highlight-parentheses-mode
   highlight-parentheses-mode turn-on-highlight-parentheses-mode
  "Global mode to highlight parentheses.")
(global-highlight-parentheses-mode t)
(setq hl-paren-colors
      '("firebrick1" "IndianRed1" "IndianRed3" "IndianRed4"))

;; color theme stuff
(require 'color-theme)
(color-theme-initialize)
(color-theme-comidia)
(set-face-attribute 'default nil
                    :family "Monospace" :height 110)
(custom-set-faces
 '(mode-line ((t (:background "dim gray" :foreground "black" :box
                              (:line-width -1 :style released-button))))))
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

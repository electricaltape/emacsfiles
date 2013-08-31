; extra stuff for org-mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-log-done t) ; display timestamp when I complete something
(setq org-agenda-files '("~/org/work.org" "/org/school.org" "/org/home.org"))

(defun org-surround-latex (start end)
  "surround the current region with #+BEGIN_SRC and #+END_SRC lines."
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (goto-char (point-min))
    (insert "#+BEGIN_SRC LaTeX\n")
    (goto-char (point-max))
    (insert "\n#+END_SRC LaTeX")))

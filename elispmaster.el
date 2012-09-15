; extra commands for editing elisp
(add-hook 'emacs-lisp-mode-hook 'outline-minor-mode)

(add-hook 'outline-minor-mode-hook
  (lambda ()
    (define-key outline-minor-mode-map [tab] 'org-cycle)
    (define-key outline-minor-mode-map [(shift tab)] 'org-global-cycle)))
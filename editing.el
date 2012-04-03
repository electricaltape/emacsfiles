(require 'undo-tree) ; required by evil
(require 'evil)
(evil-mode 1)
(setq evil-shift-width 4) ; fix behavior of > and < in normal state.
(setq evil-repeat-move-cursor nil) ; on the . command do not move cursor
; bind window switching to something that will not give me carpal tunnel.

(defun cycle-selected-buffer () 'cycle-selected-buffer)
(define-key evil-normal-state-map "tn" 'other-window)

(load-file "~/.emacs.d/plugins/surround.el")
(require 'surround) ; add surround.
(global-surround-mode 1)
; yasnippet, cuz snippets rock.
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/plugins/yasnippet-snippets/snippets") ; local
(setq yas/indent-line 'fixed)
(require 'autopair)
(autopair-global-mode 1)

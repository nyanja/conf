;;;

(mapc (lambda (x) (global-set-key (kbd (car x)) (nth 1 x)))
      '(("H-s"       save-buffer)
        ("H-q"       save-buffers-kill-emacs)
        ("H-x"       kill-region)
        ("H-c"       kill-ring-save)
        ("H-v"       yank)
        ("C-s"       helm-swoop)
        ("H-f"       helm-swoop)
        ("H-w"       kill-this-buffer)

        ("H-="       zoom-frm-in)
        ("H--"       zoom-frm-out)

        ("H-<left>"  previous-buffer)
        ("<home>"    previous-buffer)
        ("H-<right>" next-buffer)
        ("<end>"     next-buffer)

        ("H-/"       comment-line)
        ("C-;"       comment-line)
        ("C-'"       comment-region)
        ("C-\""      uncomment-region)

        ("H-k"       sp-forward-barf-sexp)
        ("H-l"       sp-forward-slurp-sexp)
        ("H-h"       sp-backward-slurp-sexp)
        ("H-j"       sp-backward-barf-sexp)

        ("M-h"       sp-backward-kill-symbol)
        ("M-l"       sp-kill-symbol)
        ("M-j"       sp-splice-sexp-killing-forward)
        ("M-k"       sp-splice-sexp-killing-backward)
        ("M-s"       sp-splice-sexp)))


(define-key evil-normal-state-map (kbd "<end>") 'next-buffer)
(define-key evil-normal-state-map (kbd "<home>") 'previous-buffer)


(spacemacs|spacebind
 ""
 :global
 (("d" "nrn"
   ("r" nrn/sort-and-align-clj-require "sort requires")
   ("k" "mk"
    ("r" nrn/mk-reload-replica "reload replica")
    ("d" nrn/mk-reload-dev "reload dev")
    ("t" nrn/mk-trans "trans")))))



;; (define-key evil-insert-state-map (kbd "C-h") 'left-char)
;; (define-key evil-insert-state-map (kbd "C-l") 'right-char)
;; (define-key evil-insert-state-map (kbd "C-j") 'next-line)
;; (define-key evil-insert-state-map (kbd "C-k") 'previous-line)

;; (define-key evil-normal-state-map (kbd "C-j") 'move-line-down)
;; (define-key evil-normal-state-map (kbd "C-k") 'move-line-up)

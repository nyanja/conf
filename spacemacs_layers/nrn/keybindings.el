;;;

(mapc (lambda (x) (global-set-key (kbd (car x)) (nth 1 x)))
      '(("s-s"       save-buffer)
        ("s-q"       save-buffers-kill-emacs)
        ("s-x"       kill-region)
        ("s-c"       kill-ring-save)
        ("s-v"       yank)
        ("C-s"       helm-swoop)
        ("s-f"       helm-swoop)
        ("s-w"       kill-this-buffer)

        ("s-="       zoom-frm-in)
        ("s--"       zoom-frm-out)

        ("s-<left>"  previous-buffer)
        ("<home>"    previous-buffer)
        ("s-<right>" next-buffer)
        ("<end>"     next-buffer)

        ("s-/"       comment-line)
        ("C-;"       comment-line)
        ("C-'"       comment-region)
        ("C-\""      uncomment-region)

        ("s-k"       sp-forward-barf-sexp)
        ("s-l"       sp-forward-slurp-sexp)
        ("s-h"       sp-backward-slurp-sexp)
        ("s-j"       sp-backward-barf-sexp)

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

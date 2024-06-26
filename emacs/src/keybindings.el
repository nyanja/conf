(mapc (lambda (x) (global-set-key (kbd (car x)) (nth 1 x)))
      '(
        ("H-s"       save-buffer)
        ("H-q"       save-buffers-kill-emacs)
        ("H-x"       kill-region)
        ("H-c"       kill-ring-save)
        ("H-v"       yank)
        ("C-s"       helm-swoop)
        ("H-f"       helm-swoop)
        ("H-w"       kill-this-buffer)

        ("H-="       zoom-frm-in)
        ("H--"       zoom-frm-out)

        ("C-H-h"     previous-buffer)
        ("<home>"    previous-buffer)
        ("C-H-l"     next-buffer)
        ("<end>"     next-buffer)

        ;; ("H-/"       comment-line)
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

(define-key copilot-completion-map (kbd "<H-p>") 'copilot-accept-completion)

;; (define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)

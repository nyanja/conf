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
        ("M-s"       sp-splice-sexp)
        ("M-a"       sp-splice-sexp-killing-around)))


(define-key evil-normal-state-map (kbd "<end>") 'next-buffer)
(define-key evil-normal-state-map (kbd "<home>") 'previous-buffer)
(define-key evil-normal-state-map [escape] 'nrn/indent-sexp)

(spacemacs/set-leader-keys-for-major-mode 'clojure-mode
  "tt" 'kaocha-runner-run-test-at-point
  "tr" 'kaocha-runner-run-tests
  "ta" 'kaocha-runner-run-all-tests
  "tw" 'kaocha-runner-show-warnings
  "th" 'kaocha-runner-hide-windows)

(spacemacs|spacebind
 ""
 :global
 (("d" "nrn"
   ("r" nrn/sort-and-align-clj-require "sort requires")
   ("c" "cider"
    ("a" nrn/cider-clear-aliases "clear aliases"))
   ("k" "mk"
    ("f" nrn/mk-copy-and-find-api-function "find api handler")
    ("r" nrn/mk-reload-replica "reload replica")
    ("d" nrn/mk-reload-dev "reload dev")
    ("t" nrn/mk-trans "trans")))))

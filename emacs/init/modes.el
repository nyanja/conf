(use-package clojure-mode
  :ensure t
  :commands put-clojure-indent
  :mode ("\\.boot\\'" . clojure-mode)
        ("\\.edn\\'" . clojure-mode)
        ("\\.bb\\'" . clojure-mode)
  :init
  (setq clojure-indent-style :always-indent)
  (setq clojure-thread-all-but-last t)
  (setq clojure-align-forms-automatically t)
  (setq clojure-toplevel-inside-comment-form t)
  :config
  (define-clojure-indent
    (some->  0)
    (some->> 0)
    (as->    0)
    (and     0)
    (or      0)
    (>       0)
    (<       0)
    (>=      0)
    (<=      0)
    (=       0)
    (not=    0)
    (+       0)
    (-       0)
    (*       0)
    (/       0)
    (mod     0)
    (rem     0)
    (max     0)
    (min     0))
  (add-to-list 'clojure-align-cond-forms "better-cond.core/when-let")
  (add-to-list 'clojure-align-cond-forms "better-cond.core/if-let"))



(use-package cider
  :pin melpa-stable
  :ensure t
  :no-require t
  :commands cider-mode
  ;; :bind (:map cider-mode-map
              ;; ("C-c C-f" . nil)
         ;; :map cider-repl-mode-map
              ;; ("C-c M-r" . cider-repl-previous-matching-input)
              ;; ("C-c M-s" . cider-repl-next-matching-input))
  :init
  (add-hook 'clojure-mode-hook 'cider-mode)
  (add-hook 'cider-repl-mode-hook 'paredit-mode)
  :config
  ;; (setq cider-repl-history-file "~/.emacs.d/cider-history"
        ;; cider-cljs-repl "(do (require '[figwheel-sidecar.repl-api :as ra]) (ra/cljs-repl))"
        ;; cider-repl-display-help-banner nil)
  (add-to-list 'warning-suppress-types '(undo discard-info)))



(use-package web-mode
  :ensure t
  :mode "\\.html\\'"
  ;; :bind (:map web-mode-map
              ;; ("C-c /" . web-mode-element-close))
  :init
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-style-padding 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-script-padding 2))

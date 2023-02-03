;;; ../conf/doom/modes/clojure.el -*- lexical-binding: t; -*-
;;;




(defun nrn/init-clojure-mode ()
  (enable-paredit-mode)
  (clj-refactor-mode)
  (smartparens-strict-mode t)

  ;; (aggressive-indent-mode t)

  (setq clojure-indent-style :always-indent)
  (setq clojure-align-forms-automatically t)

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

  ;;  -> ->>  these form collide with elisp macros
  (put-clojure-indent '-> 0)
  (put-clojure-indent '->> 0)

  (add-to-list 'clojure-align-cond-forms "better-cond.core/when-let")
  (add-to-list 'clojure-align-cond-forms "better-cond.core/if-let"))


(add-hook! 'clojure-mode-hook #'nrn/init-clojure-mode)
(add-hook! 'clojurec-mode-hook #'nrn/init-clojure-mode)
(add-hook! 'clojurescript-mode-hook #'nrn/init-clojure-mode)

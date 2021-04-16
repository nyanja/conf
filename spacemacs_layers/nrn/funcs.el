;;;

(defun nrn/init-clojure-mode ()
  ;; (enable-paredit-mode)
  ;; (clj-refactor-mode)

  (setq clojure-indent-style :always-indent)

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

  ;(push '("nil"    . ?無) prettify-symbols-alist)
  ;(push '("false"  . ?假) prettify-symbols-alist)
  ;(push '("true"   . ?真) prettify-symbols-alist)
  )


(defun nrn/mk-reload-replica ()
  (interactive)
  (cider-insert-in-repl "(reload :replica)" t))

(defun nrn/mk-reload-dev ()
  (interactive)
  (cider-insert-in-repl "(reload :dev)" t))

(defun nrn/mk-trans ()
  (interactive)
  (cider-insert-in-repl "(trans)" t))

(defun nrn/save-buffers ()
  (save-some-buffers 'no-confirm (lambda () t)))

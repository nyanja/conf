;;;

(defvar nrn/lsp-clojure-enabled nil)
(defvar nrn/lsp-clojure-enabled-selected nil)


(defun nrn/init-clojure-mode ()
  (when (and (not nrn/lsp-clojure-enabled) (not nrn/lsp-clojure-enabled-selected))
    (setq nrn/lsp-clojure-enabled (y-or-n-p "Enable lsp for clojure?"))
    (setq nrn/lsp-clojure-enabled-selected t))
  (when nrn/lsp-clojure-enabled
    (lsp))


  (enable-paredit-mode)
  (clj-refactor-mode)

  (smartparens-mode t)
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
  (add-to-list 'clojure-align-cond-forms "better-cond.core/if-let")

  )

(defun nrn/init-web-mode ()
  (smartparens-mode t)
  ;; (aggressive-indent-mode t)
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

(defun nrn/init-lsp-mode ()
  (add-to-list 'lsp-language-id-configuration '(".*\\.scss" . "scss")))


(defun nrn/sort-and-align-clj-require ()
  (interactive)
  (save-excursion
    (when (or (string= (file-name-extension buffer-file-name) "clj")
              (string= (file-name-extension buffer-file-name) "cljc")
              (string= (file-name-extension buffer-file-name) "cljs"))
      (goto-char (point-min))
      (when (search-forward-regexp "(:require" nil t)
        (let ((start (point))
              (end (progn (up-list) (1- (point)))))
          (goto-char end)
          (while (search-backward-regexp "^\s*[\n]" nil t)
            (setq start (point)))
          (setq start (1+ start))
          (sort-lines nil start end)
          (align-regexp start end "\\(\\s-*\\):as" 1 1 t))))))


(defun nrn/indent-sexp ()
  (interactive)
  (save-excursion
    (beginning-of-defun)
    (mark-sexp)
    (indent-for-tab-command)))

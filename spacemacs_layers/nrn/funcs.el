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
  (add-to-list 'clojure-align-cond-forms "better-cond.core/if-let"))


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

(defun nrn/cider-clear-aliases ()
  (interactive)
  (cider-insert-in-repl
   "(require 'clojure.tools.namespace.repl)(clojure.tools.namespace.repl/clear-ns-aliases)" t))

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


(defun nrn/mk-copy-and-find-api-function ()
  "Copy the content of a string in double quotes under the caret, remove trailing / if necessary, and find the corresponding function in api-v2-routes."
  (interactive)
  (let ((str (thing-at-point 'filename t)))

    ;; Remove trailing slash if exists
    (when (string-suffix-p "/" str)
      (setq str (substring str 0 -1)))

    (let ((cider-buffer (cider-current-repl-buffer)))
      (if cider-buffer
          (with-current-buffer cider-buffer
            (goto-char (point-max))
            (insert "(require 'mk.api.app)\n")
            (cider-repl-return)
            (insert "(def routes mk.api.app/api-v2-routes)\n")
            (cider-repl-return)
            (insert "(defn find-route [str] (-> (filter (fn [[k v]] (re-find (re-pattern str) (first k))) routes) first second :original))\n")
            (cider-repl-return)
            (sleep-for 0.1)
            (insert (format "(find-route \"%s\")\n" str))
            (sleep-for 0.1)
            (cider-repl-return))))

    (cider-switch-to-repl-buffer)))

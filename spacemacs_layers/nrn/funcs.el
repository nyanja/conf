;;; -*- lexical-binding: t -*-

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

  (modify-syntax-entry ?\? "_" clojure-mode-syntax-table)
  (modify-syntax-entry ?\? "_" clojurec-mode-syntax-table)
  (modify-syntax-entry ?\? "_" clojurescript-mode-syntax-table)

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
   (min     0)
   (u/ukru  0))

  ;;  -> ->>  these form collide with elisp macros
  (put-clojure-indent '-> 0)
  (put-clojure-indent '->> 0)

  (add-to-list 'clojure-align-cond-forms "better-cond.core/when-let")
  (add-to-list 'clojure-align-cond-forms "better-cond.core/if-let"))


(defun nrn/init-web-mode ()
  (smartparens-mode t)
  ;; (aggressive-indent-mode t)
  (modify-syntax-entry ?% "_" web-mode-syntax-table)
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
  "Find the API function corresponding to the string at point and jump to its definition.
The function looks for a string (assumed to be in double quotes) under the cursor,
removes a trailing slash if present, then sends code to your Clojure nREPL that:
  - requires 'mk.api.app,
  - defines 'routes as mk.api.app/api-v2-routes,
  - defines a helper function `find-route` to locate the matching route,
  - prints (via pr-str) the result of (find-route <cleaned-string>).
If a match is found, its var is looked up and jumped to using `cider-find-var`.
Debug prints are included to show raw nREPL responses."
  (interactive)
  (let* ((str (thing-at-point 'filename t))
         (cleaned (and str (if (string-suffix-p "/" str)
                               (substring str 0 -1)
                             str))))
    (unless cleaned
      (user-error "No string found at point"))
    (message "Searching for API function matching: %s" cleaned)
    (let ((processed nil))
      (cider-interactive-eval
       (format
        "(do
           (require 'mk.api.app)
           (defn find-route [s]
             (->> mk.api.app/api-v2-route
                  (filter (fn [[k v]]
                            (re-find (re-pattern s) (first k))))
                  first
                  second
                  :original))
           (pr-str (find-route \"%s\")))"
        cleaned)
       (lambda (response)
         (let ((val (nrepl-dict-get response "value")))
           (if (not (or (null val) (string= val "nil")))
               (cider-find-var nil (substring (substring val 3) 0 -1)))))))))

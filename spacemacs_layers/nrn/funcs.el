;;; -*- lexical-binding: t -*-

(defun nrn/enable-paredit-mode-safe ()
  "Enable `paredit-mode' if it is available.
Guards against `enable-paredit-mode' being undefined during package
loaddef-scraping on a fresh install (e.g. after an Emacs version bump),
when paredit has not been loaded yet."
  (when (fboundp 'enable-paredit-mode)
    (enable-paredit-mode)))

(defun nrn/init-clojure-mode ()
  ;; Clojure backend (CIDER vs LSP) is chosen by Spacemacs via the
  ;; `clojure-backend' layer variable (set to 'cider in ~/.spacemacs), so no
  ;; per-buffer prompt is needed here. Flip that variable to 'lsp if you ever
  ;; want clojure-lsp instead.
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
   (cond->  0)
   (cond->> 0)
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
   (u/ukru  0)
   (dom/c   0))

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

(defvar nrn/mk-black-user-id 102
  "Default user id for `nrn/mk-remove-black'.")

(defun nrn/mk-remove-black (uid)
  "Remove loyalty and black subscription for UID via the CIDER REPL.
Prompts in the minibuffer, defaulting to `nrn/mk-black-user-id'."
  (interactive
   (list (read-number "Remove black for user id: " nrn/mk-black-user-id)))
  (cider-insert-in-repl
   (format "(do (require '[mk.api.db :as db] '[mk.api.cache :as cache])
    (db/execute {:delete-from :product_subscription :where [:= :user_id %d]})
    (db/execute {:delete-from :user_loyalty :where [:= :user_id %d]})
    (cache/invalidate :user %d))"
           uid uid uid)
   t))

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
  (if (and buffer-file-name
           (member (file-name-extension buffer-file-name) '("ts" "tsx" "js" "jsx")))
      ;; For TypeScript/JavaScript files, format with LSP or project tools
      (cond
       ;; Try LSP formatting first (respects eslint/prettier config)
       ((and (boundp 'lsp-mode) lsp-mode)
        (lsp-format-buffer))
       ;; Fall back to project's eslint (which includes prettier via plugin)
       ((locate-dominating-file default-directory "package.json")
        (let* ((project-root (locate-dominating-file default-directory "package.json"))
               (eslint-cmd (concat "cd " (shell-quote-argument project-root)
                                   " && npx eslint --fix " (shell-quote-argument buffer-file-name))))
          (save-buffer)
          (shell-command eslint-cmd)
          (revert-buffer t t t)
          (message "Formatted with project's ESLint")))
       ;; Last resort: try global prettier
       ((executable-find "prettier")
        (let ((current-pos (point)))
          (shell-command-on-region
           (point-min)
           (point-max)
           (format "prettier --stdin-filepath %s" (shell-quote-argument buffer-file-name))
           (current-buffer)
           t
           "*prettier-errors*"
           t)
          (goto-char (min current-pos (point-max)))))
       (t (message "No formatter found. Install prettier or enable LSP mode.")))
    ;; For other files, use the original indent behavior
    (save-excursion
      (beginning-of-defun)
      (mark-sexp)
      (indent-for-tab-command))))

(defun nrn/goto-css-module-class ()
  "Jump to CSS class definition in corresponding style module.
Works when cursor is on `styles.className` in TSX files."
  (interactive)
  (let* ((symbol (thing-at-point 'symbol t))
         (line (thing-at-point 'line t)))
    (when (and symbol (string-match "styles\\." line))
      (let* ((class-name symbol)
             ;; Find the import line for styles
             (import-pattern "import\\s-+styles\\s-+from\\s-+['\"]\\([^'\"]+\\)['\"]")
             style-file)
        (save-excursion
          (goto-char (point-min))
          (when (re-search-forward import-pattern nil t)
            (setq style-file (match-string 1))))
        (when style-file
          (let* ((current-dir (file-name-directory buffer-file-name))
                 (full-path (expand-file-name style-file current-dir)))
            ;; Handle extension-less imports
            (unless (file-exists-p full-path)
              (setq full-path (concat full-path ".module.scss"))
              (unless (file-exists-p full-path)
                (setq full-path (concat (file-name-sans-extension full-path) ".module.css"))))
            (when (file-exists-p full-path)
              (find-file full-path)
              (goto-char (point-min))
              (when (re-search-forward (format "\\.%s\\b" class-name) nil t)
                (beginning-of-line)))))))))

(defun nrn/maybe-goto-css-class (orig-fun &rest args)
  "Try CSS module navigation first, fall back to LSP."
  (let ((symbol (thing-at-point 'symbol t))
        (line (thing-at-point 'line t)))
    (if (and symbol
             buffer-file-name
             (member (file-name-extension buffer-file-name) '("tsx" "jsx"))
             (string-match "styles\\." line))
        (nrn/goto-css-module-class)
      (apply orig-fun args))))

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

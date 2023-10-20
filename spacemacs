;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.


(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   dotspacemacs-distribution 'spacemacs
   dotspacemacs-enable-lazy-installation 'unused
   dotspacemacs-ask-for-lazy-installation t
   dotspacemacs-configuration-layer-path '()

   dotspacemacs-configuration-layers
   '(rust
     python
     lua
     ;; python
     shell
     javascript
     typescript
     markdown
     yaml
     (html :variables
           css-enable-lsp t
           scss-enable-lsp t)
     web-beautify
     helm
     auto-completion
     emacs-lisp
     git
     sql
     syntax-checking
     (ruby :variables
           ruby-version-manager 'rbenv)

     ;; parinfer
     (clojure :variables
              clojure-backend 'cider              ;; use cider and disable lsp
              clojure-enable-linters '(clj-kondo) ;; clj-kondo included in lsp
              cider-repl-display-help-banner nil  ;; disable help banner
              cider-pprint-fn 'fipp               ;; fast pretty printing
              clojure-enable-clj-refactor             t
              ;; clojure-indent-style 'align-arguments
              clojure-align-forms-automatically t
              clojure-toplevel-inside-comment-form t ;; evaluate expressions in comment as top level
              cider-result-overlay-position 'at-point ;; results shown right after expression
              cider-overlays-use-font-lock t
              cider-repl-buffer-size-limit 100 ;; limit lines shown in REPL buffer
              )

     (lsp :variables
          lsp-enable-indentation nil
          lsp-ui-doc-enable nil      ;; disable all doc popups
          lsp-ui-sideline-enable nil ;; disable sideline bar for less distraction
          treemacs-space-between-root-nodes nil) ;; no spacing in treemacs views


     nrn)

   dotspacemacs-additional-packages
   '(
     sqlite3
     kaocha-runner
     flycheck-clj-kondo
     (forge :toggle nil)

     (copilot :location (recipe
                         :fetcher github
                         :repo "zerolfx/copilot.el"
                         :files ("*.el" "dist"))))

   dotspacemacs-frozen-packages '()
   dotspacemacs-excluded-packages '(spaceline)
   dotspacemacs-install-packages 'used-only))


(defun dotspacemacs/init ()
  ;; prevent Too many open files error
  ;; (setq max-specpdl-size 4000)
  (setq max-lisp-eval-depth 4000)

  (toggle-scroll-bar -1)
  (scroll-bar-mode -1)

  (setq-default
   dotspacemacs-enable-server nil
   dotspacemacs-mode-line-theme '(spacemacs)
   dotspacemacs-elpa-https t
   dotspacemacs-elpa-timeout 5
   dotspacemacs-check-for-update t
   dotspacemacs-editing-style 'vim
   dotspacemacs-startup-banner '000
   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'."
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))
   dotspacemacs-scratch-mode 'text-mode
   dotspacemacs-themes '(modus-vivendi
                         plan9
                         heroku)
   dotspacemacs-colorize-cursor-according-to-state t
   dotspacemacs-default-font '("Iosevka SS04"
                               :size 16
                               :height 120
                               :width normal
                               :powerline-scale 1)
   dotspacemacs-leader-key "SPC"
   dotspacemacs-emacs-command-key "SPC"
   dotspacemacs-ex-command-key ":"
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m")
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   dotspacemacs-auto-resume-layouts t
   dotspacemacs-large-file-size 1
   dotspacemacs-auto-save-file-location 'cache
   dotspacemacs-max-rollback-slots 5
   dotspacemacs-helm-resize nil
   dotspacemacs-helm-no-header nil
   dotspacemacs-helm-position 'bottom
   dotspacemacs-helm-use-fuzzy 'always
   dotspacemacs-enable-paste-transient-state nil
   dotspacemacs-which-key-delay 0.4
   dotspacemacs-which-key-position 'bottom
   dotspacemacs-loading-progress-bar t
   dotspacemacs-fullscreen-at-startup nil
   dotspacemacs-fullscreen-use-non-native nil
   dotspacemacs-maximized-at-startup t
   dotspacemacs-show-transient-state-color-guide t
   dotspacemacs-mode-line-unicode-symbols t
   dotspacemacs-smooth-scrolling t
   dotspacemacs-line-numbers nil
   dotspacemacs-smartparens-strict-mode nil
   dotspacemacs-search-tools '("rg" "grep" "ag" "pt" "ack")
   dotspacemacs-whitespace-cleanup 'changed))

(defun dotspacemacs/user-init ())


(defun dotspacemacs/user-config ()

  ;; Ignored by LSP
  ;;
  (with-eval-after-load 'lsp-mode
    (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]migrations\\'")
    (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]resources\\'")
    (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]out\\'")
    (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.repl\\'")
    (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]docs\\'"))

  (define-key evil-normal-state-map [escape] 'nrn/indent-sexp)


  ;; parinfer
  ;;
  (setq parinfer-rust-library "~/.emacs.spc/parinfer-rust/parinfer-rust-darwin.so")
  (setq parinfer-rust-auto-download t)


  ;; copilot
  ;;
  (with-eval-after-load 'company
    ;; disable inline previews
    (delq 'company-preview-if-just-one-frontend company-frontends))

  (with-eval-after-load 'copilot
    (define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
    ;;(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)
    )

  (add-hook 'prog-mode-hook 'copilot-mode)

  (define-key evil-insert-state-map (kbd "<backtab>") 'copilot-accept-completion-by-word)
  ;; (define-key evil-insert-state-map (kbd "C-TAB") 'copilot-accept-completion-by-word)


  (spacemacs/set-leader-keys-for-major-mode 'clojure-mode
    "tt" 'kaocha-runner-run-test-at-point
    "tr" 'kaocha-runner-run-tests
    "ta" 'kaocha-runner-run-all-tests
    "tw" 'kaocha-runner-show-warnings
    "th" 'kaocha-runner-hide-windows))


(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#0a0814" "#f2241f" "#67b11d" "#b1951d" "#4f97d7" "#a31db1" "#28def0" "#b2b2b2"])
 '(cider-switch-to-repl-on-insert nil)
 '(compilation-scroll-output 'first-error)
 '(css-indent-offset 2)
 '(custom-safe-themes
   '("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "36ca8f60565af20ef4f30783aa16a26d96c02df7b4e54e9900a5138fb33808da" "bf798e9e8ff00d4bf2512597f36e5a135ce48e477ce88a0764cfb5d8104e8163" default))
 '(evil-want-C-u-scroll nil)
 '(evil-want-Y-yank-to-eol nil)
 '(highlight-parentheses-background-colors '("#e8fce8" "#c1e7f8" "#f8e8e8"))
 '(hl-todo-keyword-faces
   '(("TODO" . "#dc752f")
     ("NEXT" . "#dc752f")
     ("THEM" . "#2d9574")
     ("PROG" . "#3a81c3")
     ("OKAY" . "#3a81c3")
     ("DONT" . "#f2241f")
     ("FAIL" . "#f2241f")
     ("DONE" . "#42ae2c")
     ("NOTE" . "#b1951d")
     ("KLUDGE" . "#b1951d")
     ("HACK" . "#b1951d")
     ("TEMP" . "#b1951d")
     ("FIXME" . "#dc752f")
     ("XXX+" . "#dc752f")
     ("\\?\\?\\?+" . "#dc752f")))
 '(js-indent-level 2)
 '(line-spacing 0)
 '(mode-line-percent-position '(6 "%q"))
 '(package-selected-packages
   '(dap-mode lsp-docker bui yaml-mode ws-butler winum which-key web-mode web-beautify volatile-highlights vi-tilde-fringe uuidgen use-package undo-tree toc-org tern telega rainbow-identifiers visual-fill-column tagedit string-inflection sql-indent smeargle slim-mode scss-mode sass-mode restart-emacs rainbow-delimiters pug-mode pretty-mode popwin po-mode persp-mode pcre2el paradox orgit org-plus-contrib org-bullets open-junk-file neotree move-text mmm-mode markdown-toc markdown-mode magit-gitflow magit-popup macrostep lorem-ipsum livid-mode skewer-mode simple-httpd linum-relative link-hint json-mode json-snatcher json-reformat js2-refactor js2-mode js-doc indent-guide hungry-delete hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation helm-themes helm-swoop helm-projectile projectile helm-mode-manager helm-make helm-gitignore request helm-flx helm-descbinds helm-css-scss helm-company helm-c-yasnippet helm-ag haml-mode google-translate golden-ratio gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link gh-md fuzzy flycheck-pos-tip pos-tip flycheck-joker flycheck-clj-kondo flycheck flx-ido flx fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired f evil-tutor evil-surround evil-search-highlight-persist highlight evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit magit git-commit with-editor transient evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-args evil-anzu anzu evil goto-chg emmet-mode elisp-slime-nav dumb-jump s diminish define-word company-web web-completion-data dash company-statistics company column-enforce-mode coffee-mode clojure-snippets clj-refactor hydra inflections multiple-cursors paredit lv clean-aindent-mode cider-eval-sexp-fu eval-sexp-fu cider sesman seq spinner queue pkg-info parseedn clojure-mode parseclj a epl bind-map bind-key auto-yasnippet yasnippet auto-highlight-symbol auto-compile packed aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line helm avy helm-core async ac-ispell auto-complete popup heroku-theme))
 '(paradox-github-token t)
 '(pdf-view-midnight-colors '("#655370" . "#fbf8ef"))
 '(projectile-globally-ignored-directories
   '(".idea" ".ensime_cache" ".eunit" ".git" ".hg" ".fslckout" "_FOSSIL_" ".bzr" "_darcs" ".tox" ".svn" ".stack-work" "img"))
 '(scroll-bar-mode nil)
 '(scroll-conservatively 101)
 '(scroll-preserve-screen-position t)
 '(sql-connection-alist
   '(("mk"
      (sql-product 'postgres)
      (sql-user "modnakastauser")
      (sql-database
       #("modnakasta" 0 10
         (ws-butler-chg chg)))
      (sql-server ""))))
 '(vc-annotate-background "#ecf0f1")
 '(vc-annotate-color-map
   '((30 . "#e74c3c")
     (60 . "#c0392b")
     (90 . "#e67e22")
     (120 . "#d35400")
     (150 . "#f1c40f")
     (180 . "#d98c10")
     (210 . "#2ecc71")
     (240 . "#27ae60")
     (270 . "#1abc9c")
     (300 . "#16a085")
     (330 . "#2492db")
     (360 . "#0a74b9")))
 '(vc-annotate-very-old-color "#0a74b9")
 '(wakatime-python-bin nil)
 '(warning-suppress-log-types '((lsp-mode)))
 '(window-divider-default-right-width 1)
 '(window-divider-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(highlight-parentheses-highlight ((nil (:weight ultra-bold))) t)
 '(window-divider ((t (:foreground "dim gray"))))
 '(window-divider-last-pixel ((t (:foreground "dim gray")))))
)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#0a0814" "#f2241f" "#67b11d" "#b1951d" "#4f97d7" "#a31db1" "#28def0" "#b2b2b2"])
 '(package-selected-packages
   '(yaml-mode ws-butler winum which-key web-mode web-beautify volatile-highlights vi-tilde-fringe uuidgen use-package undo-tree toc-org tern telega rainbow-identifiers visual-fill-column tagedit string-inflection sql-indent smeargle slim-mode scss-mode sass-mode restart-emacs rainbow-delimiters pug-mode pretty-mode popwin po-mode persp-mode pcre2el paradox orgit org-plus-contrib org-bullets open-junk-file neotree move-text mmm-mode markdown-toc markdown-mode magit-gitflow magit-popup macrostep lorem-ipsum livid-mode skewer-mode simple-httpd linum-relative link-hint json-mode json-snatcher json-reformat js2-refactor js2-mode js-doc indent-guide hungry-delete hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation helm-themes helm-swoop helm-projectile projectile helm-mode-manager helm-make helm-gitignore request helm-flx helm-descbinds helm-css-scss helm-company helm-c-yasnippet helm-ag haml-mode google-translate golden-ratio gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link gh-md fuzzy flycheck-pos-tip pos-tip flycheck-joker flycheck-clj-kondo flycheck flx-ido flx fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired f evil-tutor evil-surround evil-search-highlight-persist highlight evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit magit git-commit with-editor transient evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-args evil-anzu anzu evil goto-chg emmet-mode elisp-slime-nav dumb-jump s diminish define-word company-web web-completion-data dash company-statistics company column-enforce-mode coffee-mode clojure-snippets clj-refactor hydra inflections multiple-cursors paredit lv clean-aindent-mode cider-eval-sexp-fu eval-sexp-fu cider sesman seq spinner queue pkg-info parseedn clojure-mode parseclj a epl bind-map bind-key auto-yasnippet yasnippet auto-highlight-symbol auto-compile packed aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line helm avy helm-core async ac-ispell auto-complete popup heroku-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

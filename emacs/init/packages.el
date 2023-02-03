(use-package which-key
  :ensure t
  :config
  ;; TODO timings
  (which-key-mode))


(use-package paredit
  :ensure t
  :no-require t
  :commands paredit-mode
  ;; :bind (:map paredit-mode-map
  ;;        ;; ("C-M-," . paredit-forward-barf-sexp)
  ;;        )
  :init
  (add-hook 'clojure-mode-hook 'paredit-mode)
  (add-hook 'emacs-lisp-mode-hook 'paredit-mode))


(use-package evil
  :ensure t
  :init
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
  :config ;; tweak evil after loading it
  (evil-mode)
  )


(use-package evil-leader
  :ensure t
  :init
  (global-evil-leader-mode)
  :config
  (evil-leader/set-leader "SPC")
  (evil-leader/set-key "SPC" 'helm-M-x)
  (evil-leader/set-key "/" 'helm-ag)
  )


(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq company-dabbrev-downcase 0)
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 1)
  (setq company-tooltip-align-annotations t))


(use-package helm
  :ensure t
  :init
  (require 'helm-config)
  :config
  (global-set-key (kbd "M-x") #'helm-M-x)
  (global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
  (global-set-key (kbd "C-x C-f") #'helm-find-files)
  (helm-mode 1))


(use-package helm-swoop
  :ensure t)


(use-package projectile
  :ensure t
  :bind (;; :map projectile-command-map
	      )
  :config
  (projectile-mode)
  (evil-leader/set-key (kbd "p") projectile-command-map)
  )


;; (use-package helm-projectile
  ;; :ensure t
  ;; :bind (("SPC /" . helm-projectile-ag))
  ;; :config
  ;; (helm-projectile-on))


(require 'zoom-frm)



(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)
         ;; ("C-x M-g" . magit-dispatch)
	 )
  ;; :config
  ;; (setq magit-save-repository-buffers nil)

  ;;; https://jakemccrary.com/blog/2020/11/14/speeding-up-magit/
  ;; (remove-hook 'magit-status-sections-hook 'magit-insert-tags-header)
  ;; (remove-hook 'magit-status-sections-hook 'magit-insert-status-headers)
  ;; (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-pushremote)
  ;; (add-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-upstream-or-recent)
  ;; (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-pushremote)
  ;; (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-upstream)

  ;; (defun magit-rebase-origin-master (args)
    ;; (interactive (list (magit-rebase-arguments)))
    ;; (message "Rebasing...")
    ;; (magit-git-rebase "origin/master" args)
    ;; (message "Rebasing...done"))

  ;; (transient-define-suffix magit-push-current-with-lease (args)
    ;; "Push the current branch to its push-remote with lease."
    ;; :if 'magit-get-current-branch
    ;; :description 'magit-push--pushbranch-description
    ;; (interactive (list (magit-push-arguments)))
    ;; (pcase-let ((`(,branch ,remote)
                 ;; (magit--select-push-remote "push there")))
      ;; (run-hooks 'magit-credential-hook)
      ;; (magit-run-git-async "push" "-v" "--force-with-lease" args remote
                           ;; (format "refs/heads/%s:refs/heads/%s"
                                   ;; branch branch))))

  ;; (transient-append-suffix 'magit-rebase "e" '("o" "origin/master" magit-rebase-origin-master))
  ;; (transient-append-suffix 'magit-push "e" '("P" "pushRemote with lease" magit-push-current-with-lease))
  )

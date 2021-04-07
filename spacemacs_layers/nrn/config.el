(setq-default
 mac-option-modifier 'meta
 ;; mac-command-modifier 'super
 coding-system-for-read 'utf-8
 coding-system-for-write 'utf-8
 ruby-insert-encoding-magic-comment nil

 clojure-align-forms-automatically t

 powerline-default-separator nil

 web-mode-css-indent-offset 2
 web-mode-code-indent-offset 2

 mouse-wheel-scroll-amount '(3 ((shift) . 1) ((control) . nil))
 mouse-wheel-progressive-speed nil

 mac-pass-command-to-system nil
 mac-pass-control-to-system nil)


(prefer-coding-system 'utf-8)
(set-language-environment 'UTF-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(global-prettify-symbols-mode t)

;(mac-auto-operator-composition-mode t)
(mouse-wheel-mode t)


(add-hook 'focus-out-hook 'nrn/save-buffers)
(add-hook 'magit-mode-hook 'evil-escape-mode)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
(add-hook 'clojure-mode-hook #'nrn/init-clojure-mode)
(add-hook 'scss-mode-hook #'web-mode)

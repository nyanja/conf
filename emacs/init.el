;;; Hi ^-^
(message "hi")

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/"))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(eval-when-compile
  (unless (fboundp 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))
  (require 'use-package))


(add-to-list 'load-path "~/.emacs.d/init/")
(add-to-list 'load-path "~/.emacs.d/lisp/")


(defun autocompile ()
  "Compile itself if this is config file."
  (interactive)
  (if (or
       (string-match ".emacs.d/init/[a-z]+.el$" (buffer-file-name))
       (string-match ".emacs.d/init.el$" (buffer-file-name)))
      (progn
	(byte-compile-file (buffer-file-name))
	(message "Recompiled `%s'" (buffer-name)))))

;; (add-hook 'after-save-hook 'autocompile)


;; (blink-cursor-mode nil)


(setq
 custom-file "~/.emacs.d/custom.el"
 inhibit-startup-message t
 initial-scratch-message nil
 make-backup-files nil
 vc-follow-symlinks t
 delete-old-versions t
 auto-save-interval 512
 cursor-in-non-selected-windows nil
 split-width-threshold 200

 mac-pass-command-to-system nil
 mac-command-modifier 'hyper

 coding-system-for-read 'utf-8
 coding-system-for-write 'utf-8
 ruby-insert-encoding-magic-comment nil

 powerline-default-separator nil

 )


(mapc (lambda (name)
          (load name))
      '("packages"
	"modes"
	"frame"
	"keybindings"
	"hooks"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(package-selected-packages
   '(paredit magit web-mode cider clojure-mode zoom-frm quelpa-use-package quelpa evil-leader helm-swoop helm-projectile projectile helm company evil which-key use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "White" :foreground "Black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 190 :width normal :foundry "nil" :family "Iosevka SS04")))))

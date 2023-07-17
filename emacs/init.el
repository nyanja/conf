;;; Hi ^-^
(message "hi")

(package-initialize)

;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
;; (add-to-list 'package-archives
  ;; '("melpa" . "http://melpa.milkbox.net/packages/"))


(unless package-archive-contents
  (package-refresh-contents))

(eval-when-compile
  (unless (fboundp 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))
  (require 'use-package))


(add-to-list 'load-path "~/conf/emacs/load/")
(add-to-list 'load-path "~/conf/emacs/lisp/")


(defun autocompile ()
  "Compile itself if this is config file."
  (interactive)
  (if (or
       (string-match "~/conf/emacs/load/[a-z]+.el$" (buffer-file-name))
       (string-match "~/conf/emacs/init.el$" (buffer-file-name)))
      (progn
	(byte-compile-file (buffer-file-name))
	(message "Recompiled `%s'" (buffer-name)))))

;; (add-hook 'after-save-hook 'autocompile)


(blink-cursor-mode 0)

(set-face-attribute 'default nil :height 170)




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
 mac-option-modifier 'meta

 coding-system-for-read 'utf-8
 coding-system-for-write 'utf-8
 ruby-insert-encoding-magic-comment nil

 powerline-default-separator nil
 )

;; create function that reloads the init file



;; make leader SPC



(mapc (lambda (name)
        (load name))
      '(
        "packages"
	"modes"
	"frame"
	"keybindings"
	"hooks"
        ))

;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Oleksandr Syletskyi"
      user-mail-address "nyancache@gmail.com")


(setq doom-theme 'doom-nord
      doom-font (font-spec :family "Iosevka SS04" :size 17)
      doom-localleader-key ","
      doom-font-increment 1
      which-key-idle-delay 0.4
      display-line-numbers-type nil
      mac-pass-command-to-system nil
      ;; find newly added files
      projectile-enable-caching nil
      magit-save-repository-buffers t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


(add-hook! 'window-setup-hook #'toggle-frame-maximized)
(add-hook! 'focus-out-hook #'(lambda () (save-some-buffers 'no-confirm (lambda () t))))


(map! "M-q"       #'indent-region
      "C-s"       #'consult-line :desc "Find in a buffer"

      :nvi "<s-left>"  #'previous-buffer
      :nvi "<s-right>" #'next-buffer
      :nvi "<home>"    #'previous-buffer
      :nvi "<end>"     #'next-buffer

      :desc "(  )>" :ni "s-k" #'sp-forward-barf-sexp
      :desc "(  <)" :ni "s-l" #'sp-forward-slurp-sexp
      :desc "<(  )" :ni "s-h" #'sp-backward-slurp-sexp
      :desc "(>  )" :ni "s-j" #'sp-backward-barf-sexp

      :desc "(a) -> a"     :ni "M-s" #'sp-splice-sexp
      :desc "(a_b) -> a"   :ni "M-j" #'sp-splice-sexp-killing-forward
      :desc "(a_b) -> b"   :ni "M-k" #'sp-splice-sexp-killing-backward
      :desc "(a_b c) -> b" :ni "M-a" #'sp-splice-sexp-killing-around

      "C-;"       #'comment-line
      "s-w"       #'kill-current-buffer)


(map! :leader
      "SPC" #'execute-extended-command

      "ttl" (lambda () (interactive) (load-theme 'doom-one-light))
      "ttd" (lambda () (interactive) (load-theme 'doom-nord))

      (:prefix ("d" . "nrn")
               (:prefix ("k" . "mk")
                :desc "trans"
                "t" (lambda () (interactive) (cider-insert-in-repl "(trans)" t))
                :desc "reload :dev"
                "d" (lambda () (interactive) (cider-insert-in-repl "(reload :dev)" t))
                :desc "reload :replica"
                "r" (lambda () (interactive) (cider-insert-in-repl "(reload :replica)" t)))))


(define-key evil-normal-state-map ";" nil)

(map!
 (:prefix ";"
          :n "r" #'transpose-sexps
          :n "(" #'sp-wrap-round
          :n "[" #'sp-wrap-square
          :n "{" #'sp-wrap-curly

          (:prefix ("f" . "slurp/barf")
           :desc "(  )>" :n "k" #'sp-forward-barf-sexp
           :desc "(  <)" :n "l" #'sp-forward-slurp-sexp
           :desc "<(  )" :n "h" #'sp-backward-slurp-sexp
           :desc "(>  )" :n "j" #'sp-backward-barf-sexp)

          (:prefix ("s" . "splice/kill")
           :desc "(a) -> a"     :n "s" #'sp-splice-sexp
           :desc "(a_b) -> a"   :n "j" #'sp-splice-sexp-killing-forward
           :desc "(a_b) -> b"   :n "k" #'sp-splice-sexp-killing-backward
           :desc "(a_b c) -> b" :n "a" #'sp-splice-sexp-killing-around)))







(load! "modes/clojure.el")

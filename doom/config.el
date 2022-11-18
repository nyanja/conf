;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Oleksandr Syletskyi"
      user-mail-address "nyancache@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord
      doom-font (font-spec :family "Iosevka SS04" :size 18)
      doom-localleader-key ","
      doom-font-increment 1
      which-key-idle-delay 0.3
      display-line-numbers-type nil
      mac-pass-command-to-system nil)

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

      "<s-left>"  #'previous-buffer
      "<s-right>" #'next-buffer
      "<home>"    #'previous-buffer
      "<end>"     #'next-buffer

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

(map! :map cider-mode-map
      :localleader
      "ef" #'cider-eval-defun-at-point)




(defun nrn/init-clojure-mode ()
  (enable-paredit-mode)
  (clj-refactor-mode)

  ;; (smartparens-mode t)
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


(add-hook! 'clojure-mode-hook #'nrn/init-clojure-mode)

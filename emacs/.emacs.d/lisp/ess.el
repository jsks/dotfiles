;;; Settings for R/Stats work
;; Command interpreter settings, set to define behavior at R prompt
(eval-after-load "comint"
  '(progn
     (define-key comint-mode-map [up]
       'comint-previous-matching-input-from-input)
     (define-key comint-mode-map [down]
       'comint-next-matching-input-from-input)

     ;; Behave like terminal, don't modify comint buffer
     (setq comint-prompt-read-only t)

     (setq comint-scroll-to-bottom-on-input t
           comint-scroll-to-bottom-on-output t
           comint-scroll-show-maximum-output t
           comint-move-point-for-output t)))

;; Function to quickly start R
(defun r-repl ()
  "Start an interactive R session.
Buffer is opened to the right of the current buffer whilst still
presering focus."
  (interactive)
  (split-window nil nil 'left)
  (call-interactively 'R)
  (other-window -1))

(use-package ess-site
  :load-path "~/.emacs.d/local/ess-18.10.2/lisp"
  :commands R
  :mode ("\\.R\\'" . R-mode)
  :general
  (:states 'normal
           :prefix "SPC"
           "e" '(:ignore t :which-key "ESS")
           "ei" 'r-repl)
  :config
  (require 'ess-site)
  (require 'ess-rdired)
  (require 'ess-jags-d)

  ;; You really don't want this enabled. Disable indenting comments
  ;; based on how many leading characters. This needs to be a hook
  ;; since it's buffer specific.
  (defun my-ess-settings ()
    (setq ess-indent-with-fancy-comments nil))
  (add-hook 'ess-mode-hook #'my-ess-settings)

  ;; Save all history into a single file
  (setq ess-history-directory "~/.R/")

  (setq ess-nuke-trailing-whitespace-p t
        ess-default-style 'C++
        ess-eval-visibly-p 'nowait
        ess-tab-complete-in-script t)

  (push '("%>%" . ?▶) ess-r-prettify-symbols)
  (push '("%<>%" . ?⧎) ess-r-prettify-symbols)
  (push '("%$%" . ?◆) ess-r-prettify-symbols)
  (push '(">=" . ?≥) ess-r-prettify-symbols)
  (push '("<=" . ?≤) ess-r-prettify-symbols)
  (push '("!=" . ?≠) ess-r-prettify-symbols))

(use-package stan-mode)

;;; Python
(use-package elpy
  :after python
  :hook (python-mode . elpy-mode)
  :init
  (setq python-shell-interpreter "jupyter"
        python-shell-interpreter-args "console --simple-prompt"
        python-shell-prompt-detect-failure-warning nil)
  (add-to-list 'python-shell-completion-native-disabled-interpreters
               "jupyter")

  (elpy-enable)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  :config
  (diminish 'highlight-indentation-mode))

;;; Dockerfile syntax highlighting
(use-package dockerfile-mode
  :mode ("Dockerfile\\'" . dockerfile-mode))

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

(use-package ess
  :init (require 'ess-site)
  :commands R
  :general
  (:states 'insert
            :keymaps 'ess-mode-map
            ";" 'ess-insert-assign)
  (:states 'insert
           :keymaps 'inferior-ess-mode-map
           ";" 'ess-insert-assign)
  (:states 'normal
           :prefix "SPC"
           "e" '(:ignore t :which-key "ESS")
           "ei" 'R
           "ed" 'ess-rdired)
  :config
  (defun local-ess-settings ()
    ;; You really don't want this enabled. Disable indenting comments
    ;; based on how many leading characters. This needs to be a hook
    ;; since it's buffer specific.
    (setq ess-indent-with-fancy-comments nil)

    ;; Auto append newline after opening brace
    (electric-layout-mode))
  (add-hook 'ess-mode-hook #'local-ess-settings)

  (defun local-inferior-ess-settings ()
    ;; Make the read-only comint prompt play nicer with evil-mode
    (setq-local comint-use-prompt-regexp nil)
    (setq-local inhibit-field-text-motion nil))
  (add-hook 'inferior-ess-mode-hook #'local-inferior-ess-settings)

  ;; Save all history into a single file
  (setq ess-history-directory "~/.R/")

  (setq ess-nuke-trailing-whitespace-p t
        ess-style 'C++)

  (push '("%>%" . ?▶) ess-r-prettify-symbols)
  (push '("%<>%" . ?⧎) ess-r-prettify-symbols)
  (push '("%$%" . ?◆) ess-r-prettify-symbols)
  (push '(">=" . ?≥) ess-r-prettify-symbols)
  (push '("<=" . ?≤) ess-r-prettify-symbols)
  (push '("!=" . ?≠) ess-r-prettify-symbols))

(use-package stan-mode)

;;; Dockerfile syntax highlighting
(use-package dockerfile-mode
  :mode ("Dockerfile\\'" . dockerfile-mode))

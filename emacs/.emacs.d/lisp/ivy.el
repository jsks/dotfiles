(use-package ivy
  :diminish ivy-mode
  :general
  (:keymaps 'ivy-minibuffer-map
        "RET" 'ivy-alt-done
        "<backtab>" 'ivy-backward-kill-word ;; Up a dir
        "<escape>" 'minibuffer-keyboard-quit)
  (:states 'normal
   :prefix "SPC"
   "bb" 'ivy-switch-buffer)

  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")

  ;; Double number of items shown
  (setq ivy-height 20)

  ;; Highlight select item
  (setq ivy-format-function 'ivy-format-function-line)

  ;; Really prefer fuzzy matching at prompt
  (setq ivy-re-builders-alist
        '((t . ivy--regex-fuzzy)))

  (ivy-mode 1))

(use-package ivy-xref
  :init (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))

;; Used by ivy--regex-fuzzy
(use-package flx)

(use-package counsel
  :bind (([remap completion-at-point] . counsel-company))
  :general
  (:states 'normal
   :prefix "SPC"
   "eh" 'counsel-shell-history
   "fr" 'counsel-recentf
   "ff" 'counsel-find-file
   "fa" 'counsel-ag
   "fg" 'counsel-git
   "of" 'counsel-org-goto-all
   "oq" 'counsel-org-tags
   "re" 'counsel-evil-registers))

(defun cloud/vterm-hook ()
  "Vterm mode hook.
Disable global highlight current line and mode line.  Much of this is
taken from feebleline; however, we only want to drop moody-line for
vterm."
  (setq-local mode-line-format "")
  (face-remap-add-relative 'mode-line nil :height 10)
  (setq-local global-hl-line-mode nil)
  (company-mode -1))

;; Finally, thank the Lord, a decent terminal
(use-package vterm
  :load-path "~/.emacs.d/local/emacs-libvterm"
  :commands vterm
  :init
  (evil-set-initial-state 'vterm-mode 'emacs)
  (add-hook 'vterm-mode-hook 'cloud/vterm-hook)
  (setq vterm-keymap-exceptions
        '("C-c" "C-x" "C-u" "C-g" "C-h" "M-x" "M-o"
          "M-v" "C-y" "C-j" "C-k" "C-l")))

(use-package shell-pop
  :general (:keymaps 'override
            "C-q" 'shell-pop)
  :config
  (setq shell-pop-shell-type '("vterm" "vterm" 'vterm))
  (shell-pop--set-shell-type 'shell-pop-shell-type shell-pop-shell-type)

  (setq shell-pop-window-position "top"
        shell-pop-window-size 40
        shell-pop-full-span t
        shell-pop-autocd-to-working-dir nil))

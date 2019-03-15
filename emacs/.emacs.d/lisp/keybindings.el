;; Default keybindings, modeled after spacemacs
(general-define-key
 :keymaps 'normal
 :prefix "SPC"
 ;; apps
 "a"  '(:ignore t :which-key "apps")
 "aC" 'calc-dispatch
 "ad" 'dired
 "ao" 'org-agenda
 "ap" 'proced
 "aP" 'list-processes
 "au" 'undo-tree-visualize

 ;; buffers
 "b"  '(:ignore t :which-key "buffers")
 "bc" 'clean-buffer-list
 "bd" 'kill-this-buffer
 "be" 'safe-erase-buffer
 "bK" 'kill-other-buffers
 "bn" 'next-buffer
 "bp" 'previous-buffer
 "bR" 'save-revert-buffer
 "bw" 'read-only-mode

 ;; files
 "f"  '(:ignore t :which-key "files")
 "fD" 'delete-current-buffer-file
 "fE" 'sudo-edit
 "fR" 'rename-current-buffer-file
 "fs" 'evil-write-all

 ;; narrow/numbers
 "n"  '(:ignore t :which-key "narrow/numbers")
 "n+" 'evil-numbers-increase
 "n-" 'evil-numbers-decrease
 "nf" 'narrow-to-defun
 "np" 'narrow-to-region
 "nw" 'widen

 ;; register
 "r"  '(:ignore t :which-key "registers")

 ;; toggle
 "t"  '(:ignore t :which-key "toggle")
 "tl" 'cloud/toggle-left-margin
 "tv" 'toggle-truncate-lines

 ;; windows
 "w"  '(:ignore t :which-key "windows")
 "w-" 'split-window-below
 "w/" 'split-window-right
 "w=" 'balance-windows
 "wc" 'delete-window
 "wf" 'toggle-frame-fullscreen
 "wh" 'evil-window-move-far-left
 "wj" 'evil-window-move-very-top
 "wk" 'evil-window-move-very-top
 "wl" 'evil-window-move-far-right
 "wm" 'maximize-buffer
 "wR" 'rotate-windows)

;; Help can still be accessed with "F1"
(general-define-key
 "C-j" 'evil-window-down
 "C-k" 'evil-window-up
 "C-l" 'evil-window-right
 "C-h" 'evil-window-left)

(general-define-key
 :keymaps 'text-mode-map
 :states '(visual motion)
 "j" 'evil-next-visual-line
 "k" 'evil-previous-visual-line
 "$" 'evil-end-of-visual-line)

(add-hook 'text-mode-hook #'turn-on-visual-line-mode)

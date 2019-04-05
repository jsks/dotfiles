;;; cloud's terrible emacs config.
;;;
;;; Display options
(setq inhibit-startup-screen t)

(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))

;; Highlight current line & disable blinking cursor
(global-hl-line-mode t)
(blink-cursor-mode 0)

;; Display column count and hide inactive cursor
(setq column-number-mode t
      cursor-in-non-selected-windows nil)

;; Increase fringe offset
(fringe-mode '(25 . 25))

;; Yes, I'm fancy. So what?
(global-prettify-symbols-mode t)
(setq prettify-symbols-unprettify-at-point -1)

;; Set default font
(add-to-list 'default-frame-alist '(font . "Hack"))

;; Highlight matching parentheses at point
(show-paren-mode 1)

;;; Modify some behavior
(fset 'yes-or-no-p 'y-or-n-p)

;; Silence the horrible sound
(setq ring-bell-function 'ignore)

;; Remote editing
(setq-default tramp-default-method "ssh")

;; Resize all windows when splitting
(setq window-combination-resize t)

;; Keep the initial scratch buffer simple
(setq initial-scratch-message nil
      initial-major-mode 'text-mode)

;; No tabs, 4 spaces
(setq-default indent-tabs-mode nil
              tab-width 4)

;; Allow TAB to trigger completion-at-point
(setq tab-always-indent 'complete)

;; Not the best when collaborating, but let's be strict about
;; whitespace.
(add-hook 'before-save-hook 'whitespace-cleanup)

(when (equal system-type 'darwin)
  (setq mac-pass-command-to-system nil))

(setq backup-directory-alist '(("" . "~/.emacs.d/backup")))

;; http://trey-jackson.blogspot.com/2010/04/emacs-tip-36-abort-minibuffer-when.html
(defun stop-using-minibuffer ()
  "Autokill minibuffer."
  (when (and (>= (recursion-depth) 1) (active-minibuffer-window))
    (abort-recursive-edit)))

(add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer)

;; Let's escape on a spaceship to Mars
(define-key minibuffer-local-map (kbd "<escape>") 'keyboard-escape-quit)
(define-key minibuffer-local-ns-map (kbd "<escape>") 'keyboard-escape-quit)
(define-key minibuffer-local-completion-map (kbd "<escape>") 'keyboard-escape-quit)
(define-key minibuffer-local-must-match-map (kbd "<escape>") 'keyboard-escape-quit)
(define-key minibuffer-local-isearch-map (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key [escape] 'keyboard-quit)

;;; use-package
(require 'package)

(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;; Ensure all pkgs get installed
(setq use-package-always-ensure t)

;;; Package time
;; Start with a simple wrapper to change theme
(defun cloud/xtheme (theme)
  "Custom wrapper to 'load-theme' THEME.
Disables all enabled themes first before loading the target theme."
  (interactive
   (list
    (intern (completing-read "Load custom theme: "
                             (mapc #'symbol-name (custom-available-themes))))))
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme theme t)

  ;; Reset mode-line for moody
  (let ((line (face-attribute 'mode-line :underline)))
    (set-face-attribute 'mode-line          nil :overline   line)
    (set-face-attribute 'mode-line-inactive nil :overline   line)
    (set-face-attribute 'mode-line-inactive nil :underline  line)
    (set-face-attribute 'mode-line          nil :box        nil)
    (set-face-attribute 'mode-line-inactive nil :box        nil))

  ;; Ensure fringe is always the same color as our buffer bg
  (set-face-attribute 'fringe nil :background nil))

(use-package color-theme-sanityinc-tomorrow)
(use-package kaolin-themes
  :init (cloud/xtheme 'kaolin-light))

;; Fancy mode-line
(use-package moody
  :config
  (setq x-underline-at-descent-line t)
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode))

(use-package diminish)
(eval-after-load "eldoc"
  '(diminish 'eldoc-mode))
(eval-after-load "undo-tree"
  '(diminish 'undo-tree-mode))

(use-package which-key
  :diminish which-key-mode
  :config
  ;; Too slow by default
  (setq which-key-idle-delay 0.2)
  (which-key-mode))

;; I'm going to pretend I never left vim
(use-package evil
  :init
  (setq evil-search-module 'evil-search)
  (evil-mode t)
  :hook (git-commit-mode . evil-insert-state))

(use-package general
  :config
  (load "~/.emacs.d/lisp/keybindings.el"))

;; Workspace management
(use-package perspective
  :diminish persp-mode
  :general (:states 'normal
            :prefix "SPC"
            "p" '(:ignore t :which-key "perspective")
            "ps" 'persp-switch
            "pk" 'persp-remove-buffer
            "pc" 'persp-kill
            "pr" 'persp-rename
            "pa" 'persp-add-buffer
            "pA" 'persp-set-buffer
            "pI" 'persp-import
            "pj" 'persp-next
            "pk" 'persp-prev)
  :config
  (persp-mode))

;; Color code delimiters by depth
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Highlight current parantheses pair
(use-package highlight-parentheses
  :diminish highlight-parentheses-mode
  :hook (prog-mode . highlight-parentheses-mode))

;; I too have colleagues
(use-package editorconfig
  :diminish editorconfig-mode
  :config (editorconfig-mode))

;; It's impossible to go back to git cli after this
(use-package magit
  :general
  (:states 'normal
   :prefix "SPC"
   "g" '(:ignore t :which-key "magit")
   "gg" 'magit-status
   "gp" 'magit-dispatch-popup))

;; Mark git line changes
(use-package git-gutter
  :diminish git-gutter-mode
  :init (global-git-gutter-mode))

;; Completion
(use-package company
  :diminish company-mode
  :config
  (setq company-idle-delay 0.2)
  (add-hook 'after-init-hook 'global-company-mode))

;; Syntax checking
(use-package flycheck
  :diminish (flycheck-mode . " ω")
  :init (global-flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically '(mode-enabled save)))

;; Tooltip popup of syntax errors
(use-package flycheck-pos-tip
  :init (eval-after-load 'flycheck
          (flycheck-pos-tip-mode)))

;; Patched version of pdf-tools for macOS
(use-package pdf-tools
  :ensure f
  :pin manual
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-page))

;;; Config specific files
;; vterm terminal
(load "~/.emacs.d/lisp/term.el")

;; ivy/counsel
(load "~/.emacs.d/lisp/ivy.el")

;; R/ESS
(load "~/.emacs.d/lisp/ess.el")

;; org-mode, markdown, ref management
(load "~/.emacs.d/lisp/writing.el")

;;; Finally, separate file for M-x customize
(setq custom-file "~/.emacs.d/custom.el")
(unless (file-exists-p custom-file)
  (with-temp-buffer (write-file custom-file)))

(load custom-file)
